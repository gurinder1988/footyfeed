import SwiftUI
import WebKit
import AVKit

struct MediaPlayerView: View {
    let feedItem: FeedItem
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Group {
                switch feedItem.contentType {
                case .youtube:
                    YouTubePlayerView(videoURL: feedItem.contentURL)
                case .podcast:
                    AudioPlayerView(audioURL: feedItem.contentURL)
                }
            }
            .navigationTitle(feedItem.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AudioPlayerView: View {
    let audioURL: URL
    @StateObject private var audioPlayer = AudioPlayer()
    
    var body: some View {
        VStack {
            Spacer()
            
            // Audio controls
            VStack(spacing: 20) {
                // Progress bar
                ProgressView(value: audioPlayer.progress)
                    .padding(.horizontal)
                
                // Time labels
                HStack {
                    Text(formatTime(audioPlayer.currentTime))
                    Spacer()
                    Text(formatTime(audioPlayer.duration))
                }
                .font(.caption)
                .padding(.horizontal)
                
                // Playback controls
                HStack(spacing: 40) {
                    Button(action: { audioPlayer.seek(by: -15) }) {
                        Image(systemName: "gobackward.15")
                            .font(.title)
                    }
                    
                    Button(action: { audioPlayer.isPlaying ? audioPlayer.pause() : audioPlayer.play() }) {
                        Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 50))
                    }
                    
                    Button(action: { audioPlayer.seek(by: 15) }) {
                        Image(systemName: "goforward.15")
                            .font(.title)
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .onAppear {
            audioPlayer.setAudio(url: audioURL)
        }
        .onDisappear {
            audioPlayer.cleanup()
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

class AudioPlayer: ObservableObject {
    private var player: AVPlayer?
    private var timeObserver: Any?
    
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var progress: Double = 0
    
    func setAudio(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // Observe duration
        playerItem.asset.loadValuesAsynchronously(forKeys: ["duration"]) { [weak self] in
            DispatchQueue.main.async {
                self?.duration = playerItem.asset.duration.seconds
            }
        }
        
        // Observe playback time
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
            self.progress = self.duration > 0 ? self.currentTime / self.duration : 0
        }
        
        // Start playing
        play()
    }
    
    func play() {
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
    }
} 