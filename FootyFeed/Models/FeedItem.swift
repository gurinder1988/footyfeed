import Foundation

public enum ContentType: String, Codable {
    case youtube
    case podcast
}

public struct FeedItem: Identifiable, Hashable, Codable {
    public let id: String
    public let title: String
    public let description: String
    public let publishedDate: Date
    public let thumbnailURL: URL?
    public let contentURL: URL
    public let contentType: ContentType
    public let channelName: String
    
    // Additional properties for RSS/Podcast items
    public let link: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case publishedDate
        case thumbnailURL
        case contentURL
        case contentType
        case channelName
        case link
    }
    
    public init(id: String,
         title: String,
         description: String,
         publishedDate: Date,
         thumbnailURL: URL?,
         contentURL: URL,
         contentType: ContentType,
         channelName: String,
         link: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.publishedDate = publishedDate
        self.thumbnailURL = thumbnailURL
        self.contentURL = contentURL
        self.contentType = contentType
        self.channelName = channelName
        self.link = link
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        lhs.id == rhs.id
    }
} 