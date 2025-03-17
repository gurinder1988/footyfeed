import Foundation
import Combine

// Import Services module to access CacheManager
@MainActor
class FeedViewModel: ObservableObject {
    @Published private(set) var feedItems: [FeedItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published private(set) var favoriteTeam: String?
    @Published private(set) var youtubeUnavailable = false
    @Published private(set) var hasPartialError = false
    @Published private(set) var errorMessage: String?
    
    private let youtubeService: YouTubeService
    private let podcastService: PodcastService
    private let cacheManager: CacheManager
    private var currentTask: Task<Void, Never>?
    private let favoriteTeamKey = "favorite_team"
    
    init(youtubeService: YouTubeService = YouTubeService(),
         podcastService: PodcastService = PodcastService(),
         cacheManager: CacheManager = CacheManager.shared) {
        self.youtubeService = youtubeService
        self.podcastService = podcastService
        self.cacheManager = cacheManager
        
        // Load favorite team from UserDefaults
        self.favoriteTeam = UserDefaults.standard.string(forKey: favoriteTeamKey)
        
        // Try to load cached items immediately
        if let cachedItems = cacheManager.getCachedFeedItems() {
            self.feedItems = cachedItems
        }
    }
    
    func setFavoriteTeam(_ team: String?) {
        favoriteTeam = team
        // Save to UserDefaults
        if let team = team {
            UserDefaults.standard.set(team, forKey: favoriteTeamKey)
        } else {
            UserDefaults.standard.removeObject(forKey: favoriteTeamKey)
        }
        refreshContent()
    }
    
    func refreshContent() {
        // Cancel any existing task
        currentTask?.cancel()
        
        // Create new load task
        currentTask = Task { [weak self] in
            await self?.loadContent()
        }
    }
    
    private func loadContent() async {
        isLoading = true
        error = nil
        hasPartialError = false
        errorMessage = nil
        
        // If we have cached items, show them while loading new content
        if feedItems.isEmpty, let cachedItems = cacheManager.getCachedFeedItems() {
            feedItems = cachedItems
        }
        
        var loadErrors: [String] = []
        var loadedAny = false
        
        // Load team content first
        do {
            let (teamItems, teamErrors, teamLoaded) = await loadTeamContent()
            if teamLoaded {
                // Sort and display team items immediately
                feedItems = teamItems.sorted(by: { $0.publishedDate > $1.publishedDate })
                loadedAny = true
                print("Loaded \(teamItems.count) team-specific items")
            }
            loadErrors.append(contentsOf: teamErrors)
            
            // Start loading general content in the background
            if !Task.isCancelled {
                Task { [weak self] in
                    do {
                        let (generalItems, generalErrors, generalLoaded) = await self?.loadGeneralContent() ?? ([], [], false)
                        if generalLoaded {
                            await MainActor.run {
                                // Merge and sort all items
                                self?.feedItems = (self?.feedItems ?? []) + generalItems
                                self?.feedItems.sort(by: { $0.publishedDate > $1.publishedDate })
                                print("Added \(generalItems.count) general items")
                                
                                // Cache all items
                                self?.cacheManager.cacheFeedItems(self?.feedItems ?? [])
                            }
                        }
                        if !generalErrors.isEmpty {
                            await MainActor.run {
                                self?.hasPartialError = true
                                self?.errorMessage = generalErrors.first
                                print("Partial error loading general content: \(generalErrors.first ?? "Unknown error")")
                            }
                        }
                    } catch {
                        print("Error loading general content: \(error)")
                        await MainActor.run {
                            self?.hasPartialError = true
                            self?.errorMessage = error.localizedDescription
                        }
                    }
                }
            }
        } catch {
            print("Error loading team content: \(error)")
            loadErrors.append(error.localizedDescription)
        }
        
        // Check if task was cancelled
        if Task.isCancelled {
            print("Content loading was cancelled")
            isLoading = false
            return
        }
        
        // Handle complete failure case
        if !loadedAny {
            error = NSError(domain: "FeedViewModel", 
                          code: -1, 
                          userInfo: [NSLocalizedDescriptionKey: "Failed to load any content",
                                   NSLocalizedRecoverySuggestionErrorKey: loadErrors.joined(separator: "\n")])
            print("Error loading content: \(loadErrors.joined(separator: "\n"))")
            
            // Use cached items as fallback if available
            if let cachedItems = cacheManager.getCachedFeedItems(), !cachedItems.isEmpty {
                feedItems = cachedItems
                print("Using \(cachedItems.count) cached items as fallback")
            }
        }
        
        isLoading = false
    }
    
    private func loadTeamContent() async -> ([FeedItem], [String], Bool) {
        var items: [FeedItem] = []
        var errors: [String] = []
        var loaded = false
        
        guard let team = favoriteTeam,
              let sources = TeamSources.getSourcesForTeam(team) else {
            return ([], [], false)
        }
        
        print("Loading team-specific content for \(team)")
        
        // Load YouTube videos
        do {
            let videos = try await loadYouTubeVideos(fromChannels: sources.youtubeChannelIds)
            if !videos.isEmpty {
                items.append(contentsOf: videos)
                loaded = true
                print("Loaded \(videos.count) YouTube items for team \(team)")
            }
        } catch {
            let errorMsg = "Failed to load team YouTube content: \(error.localizedDescription)"
            errors.append(errorMsg)
            print(errorMsg)
        }
        
        // Load Podcasts
        if !Task.isCancelled {
            do {
                let podcasts = try await loadPodcastEpisodes(fromFeeds: sources.podcastFeeds)
                if !podcasts.isEmpty {
                    items.append(contentsOf: podcasts)
                    loaded = true
                    print("Loaded \(podcasts.count) Podcast items for team \(team)")
                }
            } catch {
                let errorMsg = "Failed to load team podcast content: \(error.localizedDescription)"
                errors.append(errorMsg)
                print(errorMsg)
            }
        }
        
        return (items, errors, loaded)
    }
    
    private func loadGeneralContent() async -> ([FeedItem], [String], Bool) {
        var items: [FeedItem] = []
        var errors: [String] = []
        var loaded = false
        
        print("Loading general content")
        
        // Load YouTube videos
        do {
            let videos = try await loadYouTubeVideos()
            if !videos.isEmpty {
                items.append(contentsOf: videos)
                loaded = true
                print("Loaded \(videos.count) general YouTube items")
            }
        } catch {
            let errorMsg = "Failed to load general YouTube content: \(error.localizedDescription)"
            errors.append(errorMsg)
            print(errorMsg)
        }
        
        // Load Podcasts
        if !Task.isCancelled {
            do {
                let podcasts = try await loadPodcastEpisodes()
                if !podcasts.isEmpty {
                    items.append(contentsOf: podcasts)
                    loaded = true
                    print("Loaded \(podcasts.count) general Podcast items")
                }
            } catch {
                let errorMsg = "Failed to load general podcast content: \(error.localizedDescription)"
                errors.append(errorMsg)
                print(errorMsg)
            }
        }
        
        return (items, errors, loaded)
    }
    
    private func loadYouTubeVideos(fromChannels channels: [String]? = nil) async throws -> [FeedItem] {
        if let channels = channels {
            return try await youtubeService.fetchLatestVideos(fromChannels: channels)
        } else {
            return try await youtubeService.fetchLatestVideos()
        }
    }
    
    private func loadPodcastEpisodes(fromFeeds feeds: [String]? = nil) async throws -> [FeedItem] {
        if let feeds = feeds {
            return try await podcastService.fetchLatestEpisodes(fromFeeds: feeds)
        } else {
            return try await podcastService.fetchLatestEpisodes()
        }
    }
    
    deinit {
        currentTask?.cancel()
    }
}