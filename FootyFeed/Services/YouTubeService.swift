import Foundation

class YouTubeService: NSObject, XMLParserDelegate {
    private let channels = [
        (username: "thogden", id: "UCnU7ly6zEcQxUScjhkgFYAQ"),
        (username: "Tifo", id: "UCGYYNGmyhZ_kwBF_lqqXdAQ"),
        (username: "thatsfootball", id: "UCFxG3MxHC1ogUglvJeMHmVQ"),
        (username: "theoverlap", id: "UCjXIw1GlwaY1IzpW_jN9iCQ"),
        (username: "HITCSevens", id: "UCi9SqUCnW_flgsrl6_PRJFQ"),
        (username: "FabrizioRomanoYT", id: "UCX1em-uaFMS02Rrk_Bowyng"),
        (username: "TheAthleticFC", id: "UC6ZMmQaL9wZYo4iLw8n8xiA")
    ]
    
    // MARK: - XML Parsing Properties
    private var currentElement = ""
    private var isInAuthor = false
    private var videos: [FeedItem] = []
    private var parsingError: Error?
    private var parserBuckets: [String: String] = [:]
    
    // Thread safety - store parser reference
    private var activeParser: XMLParser?
    
    func fetchLatestVideos() async throws -> [FeedItem] {
        // Process default channels sequentially
        var allVideos: [FeedItem] = []
        
        for channel in channels {
            do {
                print("Fetching RSS feed for channel: \(channel.username)")
                let channelVideos = try await fetchVideosForChannel(channel.id)
                allVideos.append(contentsOf: channelVideos)
            } catch {
                print("Error fetching videos for channel \(channel.username): \(error)")
                // Continue with next channel instead of failing completely
            }
        }
        
        print("Total videos fetched: \(allVideos.count)")
        return allVideos.sorted(by: { $0.publishedDate > $1.publishedDate })
    }
    
    func fetchLatestVideos(fromChannels channelIds: [String]) async throws -> [FeedItem] {
        var allVideos: [FeedItem] = []
        
        // Process channels sequentially instead of concurrently
        for channelId in channelIds {
            do {
                print("Fetching RSS feed for channel ID: \(channelId)")
                let channelVideos = try await fetchVideosForChannel(channelId)
                allVideos.append(contentsOf: channelVideos)
            } catch {
                print("Error fetching videos for channel \(channelId): \(error)")
                // Continue with next channel instead of failing completely
            }
        }
        
        print("Total videos fetched: \(allVideos.count)")
        return allVideos.sorted(by: { $0.publishedDate > $1.publishedDate })
    }
    
    private func fetchVideosForChannel(_ channelId: String) async throws -> [FeedItem] {
        let feedURL = "https://www.youtube.com/feeds/videos.xml?channel_id=\(channelId)"
        guard let url = URL(string: feedURL) else {
            throw URLError(.badURL)
        }
        
        // Use a task-specific URLSession with timeout
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30
        let session = URLSession(configuration: config)
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "YouTubeService",
                         code: httpResponse.statusCode,
                         userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode) for channel \(channelId)"])
        }
        
        // Reset parsing state - with thread safety
        return try await parseXMLData(data)
    }
    
    // Separate method for parsing to better manage object lifecycle
    private func parseXMLData(_ data: Data) async throws -> [FeedItem] {
        return try await withCheckedThrowingContinuation { continuation in
            // Reset state before parsing
            videos = []
            parsingError = nil
            resetParsingState()
            
            // Create parser on the same thread that will use the delegate callbacks
            let parser = XMLParser(data: data)
            
            // Store reference to avoid deallocation during parsing
            self.activeParser = parser
            parser.delegate = self
            
            // Run the parsing
            if parser.parse() {
                // Make a copy to avoid race conditions
                let parsedVideos = videos
                continuation.resume(returning: parsedVideos)
            } else if let error = parsingError {
                continuation.resume(throwing: error)
            } else if let parserError = parser.parserError {
                continuation.resume(throwing: parserError)
            } else {
                continuation.resume(throwing: NSError(domain: "YouTubeService",
                                                    code: -1,
                                                    userInfo: [NSLocalizedDescriptionKey: "Failed to parse feed"]))
            }
            
            // Clear reference after parsing completes
            self.activeParser = nil
        }
    }
    
    // Reset all parsing state variables
    private func resetParsingState() {
        currentElement = ""
        parserBuckets = [:]
        isInAuthor = false
    }
    
    // MARK: - XMLParserDelegate Methods
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        
        switch elementName {
        case "entry":
            // Reset dictionary for new entry
            parserBuckets = [
                "title": "",
                "description": "",
                "videoId": "",
                "channelName": "",
                "publishedDate": "",
                "thumbnailURL": ""
            ]
        case "author":
            isInAuthor = true
        case "media:thumbnail":
            if let url = attributeDict["url"] {
                parserBuckets["thumbnailURL"] = url
            }
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // Skip if element is not of interest
        guard ["title", "name", "published", "media:description", "description", "yt:videoId"].contains(currentElement) else {
            return
        }
        
        // Use safer string concatenation
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !data.isEmpty else { return }
        
        switch currentElement {
        case "title":
            if !isInAuthor {
                let current = parserBuckets["title"] ?? ""
                parserBuckets["title"] = current + data
            }
        case "name":
            if isInAuthor {
                let current = parserBuckets["channelName"] ?? ""
                parserBuckets["channelName"] = current + data
            }
        case "published":
            let current = parserBuckets["publishedDate"] ?? ""
            parserBuckets["publishedDate"] = current + data
        case "media:description", "description":
            let current = parserBuckets["description"] ?? ""
            parserBuckets["description"] = current + data
        case "yt:videoId":
            let current = parserBuckets["videoId"] ?? ""
            parserBuckets["videoId"] = current + data
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "entry":
            // Safely extract values with nil-coalescing
            guard let videoId = parserBuckets["videoId"],
                  !videoId.isEmpty,
                  let title = parserBuckets["title"],
                  !title.isEmpty,
                  let publishedDate = parserBuckets["publishedDate"],
                  let date = ISO8601DateFormatter().date(from: publishedDate),
                  let thumbnailURLString = parserBuckets["thumbnailURL"],
                  let thumbnailURL = URL(string: thumbnailURLString) else {
                print("Skipping invalid or incomplete entry")
                return
            }
            
            // Get the channel name and description, providing defaults if missing
            let channelName = parserBuckets["channelName"] ?? "Unknown Channel"
            let description = parserBuckets["description"] ?? "No description"
            
            // Sanitize title and description to handle potential malformed data
            let safeTitle = sanitizeString(title)
            let safeDescription = sanitizeString(description)
            let safeChannelName = sanitizeString(channelName)
            
            // Create video URL
            guard let embedURL = URL(string: "https://www.youtube.com/embed/\(videoId)") else {
                print("Failed to create URL for video ID: \(videoId)")
                return
            }
            
            let video = FeedItem(
                id: videoId,
                title: safeTitle,
                description: safeDescription,
                publishedDate: date,
                thumbnailURL: thumbnailURL,
                contentURL: embedURL,
                contentType: .youtube,
                channelName: safeChannelName
            )
            
            videos.append(video)
        case "author":
            isInAuthor = false
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        parsingError = parseError
        print("XML parse error: \(parseError.localizedDescription)")
    }
    
    // MARK: - Helper Methods
    
    // Add a string sanitization method to handle malformed content
    private func sanitizeString(_ input: String) -> String {
        // Handle HTML content
        let decodedString = input.htmlDecoded()
        
        // Limit string length to prevent any potential buffer overflows
        let maxLength = 500
        let limitedString = String(decodedString.prefix(maxLength))
        
        // Replace or remove problematic characters if needed
        return limitedString
    }
    
    // Add cleanup method for reliable resource release
    func cleanup() {
        // Cancel any active parsing operations
        activeParser?.abortParsing()
        activeParser = nil
    }
    
    deinit {
        cleanup()
    }
}

// Add HTML decoding extension if not already present
extension String {
    func htmlDecoded() -> String {
        // Add safety checks to prevent crashes
        guard !self.isEmpty else { return self }
        guard let data = self.data(using: .utf8) else { return self }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error decoding HTML string: \(error)")
            return self // Return original string if decoding fails
        }
    }
}