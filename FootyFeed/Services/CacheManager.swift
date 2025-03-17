import Foundation

class CacheManager {
    static let shared = CacheManager()
    private let feedItemsKey = "cached_feed_items"
    private let lastCacheTimeKey = "last_cache_time"
    private let cacheExpirationInterval: TimeInterval = 86400 // 24 hours (24 * 60 * 60)
    
    private init() {}
    
    func cacheFeedItems(_ items: [FeedItem]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(items)
            UserDefaults.standard.set(data, forKey: feedItemsKey)
            UserDefaults.standard.set(Date(), forKey: lastCacheTimeKey)
        } catch {
            print("Error caching feed items: \(error)")
        }
    }
    
    func getCachedFeedItems() -> [FeedItem]? {
        guard let lastCacheTime = UserDefaults.standard.object(forKey: lastCacheTimeKey) as? Date,
              Date().timeIntervalSince(lastCacheTime) < cacheExpirationInterval,
              let data = UserDefaults.standard.data(forKey: feedItemsKey) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([FeedItem].self, from: data)
        } catch {
            print("Error retrieving cached feed items: \(error)")
            return nil
        }
    }
    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: feedItemsKey)
        UserDefaults.standard.removeObject(forKey: lastCacheTimeKey)
    }
} 