import AVFoundation
import AVKit

class PlayerState: NSObject, ObservableObject {
    static let shared = PlayerState()
    
    @Published var currentPodcast: FeedItem?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var progress: Double = 0
    @Published var error: String?
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var audioSessionInitialized = false
    private let maxRetries = 3
    
    private override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession(retryCount: Int = 0) {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            audioSessionInitialized = true
            error = nil
            print("Audio session initialized successfully")
        } catch {
            print("Failed to set up audio session (attempt \(retryCount + 1)): \(error)")
            
            if retryCount < maxRetries {
                // Wait briefly before retrying
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    self?.setupAudioSession(retryCount: retryCount + 1)
                }
            } else {
                self.error = "Failed to initialize audio: \(error.localizedDescription)"
                audioSessionInitialized = false
            }
        }
    }
    
    func play(podcast: FeedItem) {
        print("Attempting to play podcast: \(podcast.title)")
        print("Content URL: \(podcast.contentURL)")
        
        // Ensure audio session is initialized
        if !audioSessionInitialized {
            setupAudioSession()
            // Wait briefly for audio session to initialize
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.initializePlayer(for: podcast)
            }
            return
        }
        
        initializePlayer(for: podcast)
    }
    
    private func initializePlayer(for podcast: FeedItem) {
        // If it's the same podcast, just toggle play/pause
        if currentPodcast?.id == podcast.id {
            isPlaying ? pause() : resume()
            return
        }
        
        // Clean up existing player
        cleanup()
        
        // Create a clean URL from the string to handle any encoding issues
        let urlString = podcast.contentURL.absoluteString
        
        // Set up new player with properly encoded URL
        let item: AVPlayerItem
        if let cleanURL = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString) {
            item = AVPlayerItem(url: cleanURL)
        } else {
            item = AVPlayerItem(url: podcast.contentURL)
        }
        
        player = AVPlayer(playerItem: item)
        
        // Add status observer
        item.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
        
        currentPodcast = podcast
        
        // Add error observer
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(handlePlaybackError),
                                             name: .AVPlayerItemFailedToPlayToEndTime,
                                             object: item)
        
        // Get duration
        Task { @MainActor in
            do {
                let duration = try await item.asset.load(.duration)
                self.duration = duration.seconds
                print("Duration loaded: \(duration.seconds) seconds")
            } catch {
                print("Failed to load duration: \(error)")
                self.error = "Failed to load audio duration: \(error.localizedDescription)"
            }
        }
        
        // Observe playback time
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            Task { @MainActor in
                guard let self = self else { return }
                self.currentTime = time.seconds
                if self.duration > 0 {
                    self.progress = self.currentTime / self.duration
                }
            }
        }
        
        // Start playback
        player?.play()
        isPlaying = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let playerItem = object as? AVPlayerItem {
            DispatchQueue.main.async { [weak self] in
                switch playerItem.status {
                case .failed:
                    if let error = playerItem.error {
                        print("Player item failed: \(error)")
                        self?.error = "Playback failed: \(error.localizedDescription)"
                    }
                case .readyToPlay:
                    print("Player item ready to play")
                    self?.error = nil
                default:
                    break
                }
            }
        }
    }
    
    @objc private func handlePlaybackError(_ notification: Notification) {
        if let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error {
            print("Playback error: \(error)")
            self.error = "Playback error: \(error.localizedDescription)"
        }
    }
    
    func resume() {
        player?.play()
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func seek(by seconds: Double) {
        guard let player = player else { return }
        let newTime = player.currentTime() + CMTime(seconds: seconds, preferredTimescale: 1)
        player.seek(to: newTime)
    }
    
    func cleanup() {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
        player?.pause()
        player = nil
        currentPodcast = nil
        isPlaying = false
        currentTime = 0
        duration = 0
        progress = 0
        error = nil
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    deinit {
        cleanup()
        NotificationCenter.default.removeObserver(self)
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}