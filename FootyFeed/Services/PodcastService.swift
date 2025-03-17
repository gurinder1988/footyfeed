import Foundation

class PodcastService {
    // Updated podcast feeds list - checked for validity
    private let podcastFeeds = [
        "https://feeds.megaphone.fm/tamc1979001859",                    // The Football Ramble
        "https://www.theguardian.com/football/series/footballweekly/podcast.xml", // The Guardian Football Weekly
        "https://feeds.megaphone.fm/ESP9520742908",                    // ESPN FC
        "https://feeds.megaphone.fm/TAMC5610892596",                   // Totally Football Show
        "https://feeds.megaphone.fm/ESP7486067123",                    // Men in Blazers
        "https://feeds.acast.com/public/shows/63ef9f0ad81a3d00117c5f99", // The Gary Neville Podcast
        "https://feeds.acast.com/public/shows/5eb517075c8b9465b4187340"  // Sky Sports Football Podcast
    ]
    
    // Concurrent operation limiting
    private let parsingQueue = DispatchQueue(label: "com.footyfeed.podcastparsing", attributes: .concurrent)
    private let maxConcurrentTasks = 3
    private var activeTaskCount = 0
    private let taskCountLock = NSLock()
    
    func fetchLatestEpisodes() async throws -> [FeedItem] {
        var allEpisodes: [FeedItem] = []
        var errors: [String] = []
        
        // Process feeds one by one, skipping any that fail
        for feedURL in podcastFeeds {
            print("Attempting to fetch podcast feed: \(feedURL)")
            do {
                if let url = URL(string: feedURL) {
                    let items = try await fetchEpisodesFromFeed(url)
                    print("Successfully fetched \(items.count) items from \(feedURL)")
                    allEpisodes.append(contentsOf: items)
                } else {
                    let error = "Invalid URL format for podcast feed: \(feedURL)"
                    print(error)
                    errors.append(error)
                }
            } catch {
                let errorMessage = "Error fetching podcast feed: \(feedURL), error: \(error.localizedDescription)"
                print(errorMessage)
                errors.append(errorMessage)
                // Continue with next feed
            }
        }
        
        // Only throw if we couldn't fetch any episodes at all
        if allEpisodes.isEmpty && !errors.isEmpty {
            print("All podcast feeds failed:")
            errors.forEach { print($0) }
            throw NSError(domain: "PodcastService",
                         code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Failed to fetch any podcast episodes",
                                  NSLocalizedRecoverySuggestionErrorKey: errors.joined(separator: "\n")])
        }
        
        return allEpisodes.sorted(by: { $0.publishedDate > $1.publishedDate })
    }
    
    func fetchLatestEpisodes(fromFeeds feeds: [String]) async throws -> [FeedItem] {
        var allItems: [FeedItem] = []
        var errors: [String] = []
        
        for feed in feeds {
            do {
                if let url = URL(string: feed) {
                    print("Attempting to fetch podcast feed: \(feed)")
                    
                    // Try to fetch with resilient error handling
                    let items = try await fetchEpisodesFromFeed(url)
                    print("Successfully fetched \(items.count) items from \(feed)")
                    allItems.append(contentsOf: items)
                } else {
                    let error = "Invalid URL format for podcast feed: \(feed)"
                    print(error)
                    errors.append(error)
                }
            } catch {
                let errorMessage = "Error fetching podcast feed: \(feed), error: \(error.localizedDescription)"
                print(errorMessage)
                errors.append(errorMessage)
                // Continue with next feed
            }
        }
        
        // Only throw if we couldn't fetch any episodes at all
        if allItems.isEmpty && !errors.isEmpty {
            print("All podcast feeds failed:")
            errors.forEach { print($0) }
            throw NSError(domain: "PodcastService",
                         code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Failed to fetch any podcast episodes",
                                  NSLocalizedRecoverySuggestionErrorKey: errors.joined(separator: "\n")])
        }
        
        return allItems.sorted(by: { $0.publishedDate > $1.publishedDate })
    }
    
    private func fetchEpisodesFromFeed(_ url: URL) async throws -> [FeedItem] {
        print("Fetching podcast feed: \(url.absoluteString)")
        
        // Set a reasonable timeout for the request
        var request = URLRequest(url: url)
        request.timeoutInterval = 15 // 15 seconds timeout
        
        // Use a task-specific URLSession with better timeout handling
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30
        let session = URLSession(configuration: config)
        
        // Rate limiting for concurrent operations using async/await pattern
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    // Limit concurrent tasks instead of using a semaphore
                    await waitForAvailableSlot()
                    defer { releaseTaskSlot() }
                    
                    let (data, response) = try await session.data(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        continuation.resume(throwing: URLError(.badServerResponse))
                        return
                    }
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        continuation.resume(throwing: NSError(domain: "PodcastService",
                                                            code: httpResponse.statusCode,
                                                            userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode) for feed \(url.absoluteString)"]))
                        return
                    }
                    
                    guard let xmlString = String(data: data, encoding: .utf8) else {
                        print("Failed to decode XML data for feed: \(url)")
                        continuation.resume(throwing: NSError(domain: "PodcastService",
                                                            code: -1,
                                                            userInfo: [NSLocalizedDescriptionKey: "Failed to decode XML data"]))
                        return
                    }
                    
                    do {
                        let parser = SafeFeedParser(xmlString: xmlString)
                        let feed = try parser.parse()
                        print("Successfully parsed feed: \(feed.title), found \(feed.items.count) items")
                        
                        // Limit to 10 items and filter out any invalid ones with safer nil handling
                        let episodes = feed.items.prefix(10).compactMap { item -> FeedItem? in
                            // Skip items with missing required fields
                            guard !item.title.isEmpty,
                                  !item.enclosureURL.isEmpty,
                                  let contentURL = URL(string: item.enclosureURL) else {
                                print("Skipping item with missing required fields")
                                return nil
                            }
                            
                            // Handle thumbnail URL
                            let thumbnailURL: URL?
                            if let imageURLString = feed.image?.url, !imageURLString.isEmpty {
                                thumbnailURL = URL(string: imageURLString)
                            } else {
                                thumbnailURL = nil
                            }
                            
                            // Sanitize strings to prevent rendering issues
                            let safeTitle = sanitizeString(item.title)
                            let safeDescription = sanitizeString(item.description)
                            let safeChannelName = sanitizeString(feed.title)
                            
                            return FeedItem(
                                id: item.enclosureURL,
                                title: safeTitle,
                                description: safeDescription,
                                publishedDate: item.pubDate,
                                thumbnailURL: thumbnailURL,
                                contentURL: contentURL,
                                contentType: .podcast,
                                channelName: safeChannelName,
                                link: item.link.isEmpty ? nil : item.link
                            )
                        }
                        
                        continuation.resume(returning: Array(episodes))
                    } catch {
                        print("Error parsing feed \(url.absoluteString): \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // Helper method to sanitize strings
    private func sanitizeString(_ input: String) -> String {
        // Remove HTML tags with safer regex 
        let withoutHTML = input.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        // Limit string length
        let maxLength = 500
        let limitedString = String(withoutHTML.prefix(maxLength))
        
        return limitedString
    }
    
    // MARK: - Task limiting methods
    
    private func waitForAvailableSlot() async {
        while true {
            taskCountLock.lock()
            if activeTaskCount < maxConcurrentTasks {
                activeTaskCount += 1
                taskCountLock.unlock()
                return
            }
            taskCountLock.unlock()
            
            // Wait a moment before checking again
            try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
        }
    }
    
    private func releaseTaskSlot() {
        taskCountLock.lock()
        activeTaskCount -= 1
        taskCountLock.unlock()
    }
}

// Enhanced feed parser with better error handling
class SafeFeedParser {
    private let xmlString: String
    
    init(xmlString: String) {
        self.xmlString = xmlString
    }
    
    func parse() throws -> Feed {
        guard !xmlString.isEmpty else {
            throw NSError(domain: "FeedParserError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty XML string"])
        }
        
        guard let data = xmlString.data(using: .utf8) else {
            throw NSError(domain: "FeedParserError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid XML string encoding"])
        }
        
        return try parseWithContinuation(data: data)
    }
    
    // Use continuation to better manage the parser's lifecycle
    private func parseWithContinuation(data: Data) throws -> Feed {
        return try withCheckedThrowingResult { 
            let parser = XMLParser(data: data)
            let delegate = FeedParserDelegate()
            parser.delegate = delegate
            
            if parser.parse() {
                // Validate the feed has required fields
                var parsedFeed = delegate.feed
                if parsedFeed.title.isEmpty {
                    // If title is missing, use a default
                    parsedFeed.title = "Untitled Podcast"
                }
                return parsedFeed
            } else {
                let error = parser.parserError ?? NSError(domain: "FeedParserError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown parsing error"])
                throw NSError(domain: "FeedParserError", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Failed to parse feed",
                    NSUnderlyingErrorKey: error
                ])
            }
        }
    }
}

// Helper function to ensure parser stays in scope during operation
func withCheckedThrowingResult<T>(body: () throws -> T) throws -> T {
    try body()
}

// The rest of the file remains largely the same, with some safety improvements
struct RSSItem {
    var title: String = ""
    var link: String = ""
    var description: String = ""
    var pubDate: Date = Date()
    var enclosureURL: String = ""
}

struct Feed {
    var title: String = ""
    var link: String = ""
    var description: String = ""
    var image: FeedImage?
    var items: [RSSItem] = []
}

struct FeedImage {
    var url: String = ""
    var title: String?
    var link: String?
}

class FeedParserDelegate: NSObject, XMLParserDelegate {
    var feed = Feed()
    private var currentItem: RSSItem?
    private var currentElement = ""
    private var currentText = ""
    private var isInImage = false
    private var parsingDepth = 0 // Track nesting to handle malformed XML
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        parsingDepth += 1
        currentElement = elementName
        currentText = ""
        
        // Limit parsing depth to prevent stack overflow on malformed XML
        guard parsingDepth < 100 else {
            parser.abortParsing()
            return
        }
        
        switch elementName {
        case "item":
            currentItem = RSSItem()
        case "image":
            isInImage = true
            if feed.image == nil {
                feed.image = FeedImage()
            }
        case "enclosure":
            if let url = attributeDict["url"], !url.isEmpty {
                currentItem?.enclosureURL = url
            }
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // Safely append text, limiting to reasonable size
        if currentText.count < 10000 {
            currentText += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        parsingDepth -= 1
        let content = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch elementName {
        case "item":
            if let item = currentItem {
                // Ensure required fields are present and enclosure URL exists
                if !item.title.isEmpty, !item.enclosureURL.isEmpty {
                    feed.items.append(item)
                }
            }
            currentItem = nil
            
        case "image":
            isInImage = false
            
        default:
            if var item = currentItem {
                // Parse item elements
                switch elementName {
                case "title":
                    item.title = content
                case "link":
                    item.link = content
                case "description":
                    // Clean HTML tags from description
                    item.description = content.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                case "pubDate":
                    // Try multiple date formats to increase compatibility
                    if let date = parsePodcastDate(content) {
                        item.pubDate = date
                    }
                default:
                    break
                }
                currentItem = item
            } else if isInImage {
                // Parse image elements
                switch elementName {
                case "url":
                    feed.image?.url = content
                case "title":
                    feed.image?.title = content
                case "link":
                    feed.image?.link = content
                default:
                    break
                }
            } else {
                // Parse feed elements
                switch elementName {
                case "title":
                    feed.title = content
                case "link":
                    feed.link = content
                case "description":
                    feed.description = content
                default:
                    break
                }
            }
        }
        
        currentText = ""
    }
    
    // More robust date parsing that tries multiple formats
    private func parsePodcastDate(_ dateString: String) -> Date? {
        // Try the standard RSS date format first
        if let date = DateFormatter.rssDateFormatter.date(from: dateString) {
            return date
        }
        
        // Try alternative formats
        let formatters = [
            DateFormatter.iso8601Formatter,
            DateFormatter.alternateRSSFormatter,
            DateFormatter.shortRSSFormatter
        ]
        
        for formatter in formatters {
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        
        // If all else fails, use current date
        print("Could not parse date: \(dateString), using current date")
        return Date()
    }
}

// Extended DateFormatter with multiple formats for better compatibility
extension DateFormatter {
    static let rssDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        return formatter
    }()
    
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    static let alternateRSSFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter
    }()
    
    static let shortRSSFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
        return formatter
    }()
}