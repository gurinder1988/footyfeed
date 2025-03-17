import SwiftUI

struct MiniPlayerView: View {
    @StateObject private var playerState = PlayerState.shared
    
    var body: some View {
        if let podcast = playerState.currentPodcast {
            VStack(spacing: 0) {
                // Progress bar
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * playerState.progress)
                        .frame(height: 2)
                }
                .frame(height: 2)
                
                HStack(spacing: 16) {
                    // Thumbnail
                    if let thumbnailURL = podcast.thumbnailURL {
                        AsyncImage(url: thumbnailURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                        .frame(width: 40, height: 40)
                        .cornerRadius(4)
                    }
                    
                    // Title and channel or error
                    VStack(alignment: .leading, spacing: 2) {
                        if let error = playerState.error {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        } else {
                            Text(podcast.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .lineLimit(1)
                            
                            Text(podcast.channelName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Controls
                    HStack(spacing: 20) {
                        Button(action: { playerState.seek(by: -15) }) {
                            Image(systemName: "gobackward.15")
                                .font(.title3)
                        }
                        
                        Button(action: { playerState.isPlaying ? playerState.pause() : playerState.resume() }) {
                            Image(systemName: playerState.isPlaying ? "pause.fill" : "play.fill")
                                .font(.title3)
                        }
                        
                        Button(action: { playerState.seek(by: 15) }) {
                            Image(systemName: "goforward.15")
                                .font(.title3)
                        }
                        
                        Button(action: { playerState.cleanup() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color(.separator)),
                    alignment: .top
                )
            }
        }
    }
} 