import SwiftUI
import WebKit

struct FeedItemView: View {
    let item: FeedItem
    let isVideoExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Main content area (clickable)
            Button(action: onTap) {
                if item.contentType == .youtube {
                    // YouTube video layout
                    VStack(alignment: .leading, spacing: 8) {
                        // Thumbnail or video player based on expanded state
                        if isVideoExpanded {
                            YouTubePlayerView(videoURL: item.contentURL)
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .cornerRadius(8)
                        } else {
                            // Thumbnail with 16:9 aspect ratio
                            if let thumbnailURL = item.thumbnailURL {
                                AsyncImage(url: thumbnailURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(16/9, contentMode: .fill)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .cornerRadius(8)
                                .overlay(
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                        .opacity(0.8)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                                .lineLimit(2)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Image(systemName: "play.rectangle.fill")
                                    .foregroundColor(.red)
                                
                                Text(item.channelName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Text(relativeDate(from: item.publishedDate))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } else {
                    // Podcast layout
                    HStack(alignment: .top, spacing: 12) {
                        // Thumbnail with play button overlay
                        ZStack {
                            if let thumbnailURL = item.thumbnailURL {
                                AsyncImage(url: thumbnailURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                }
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                            }
                            
                            Circle()
                                .fill(Color.black.opacity(0.4))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 35))
                                .foregroundColor(.white)
                        }
                        .frame(width: 120, height: 68)
                        .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                                .lineLimit(2)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Image(systemName: "headphones")
                                    .foregroundColor(.blue)
                                
                                Text(item.channelName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Text(relativeDate(from: item.publishedDate))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // Helper to format date as relative time
    private func relativeDate(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}