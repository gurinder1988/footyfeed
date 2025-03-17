import SwiftUI

struct SkeletonView: View {
    let isYouTube: Bool
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isYouTube {
                // YouTube video layout
                VStack(alignment: .leading, spacing: 8) {
                    // Thumbnail placeholder
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .cornerRadius(8)
                        .overlay(
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white.opacity(0.3))
                        )
                        .shimmer(isAnimating: isAnimating)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // Title placeholder
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 20)
                            .frame(width: 250)
                            .cornerRadius(4)
                            .shimmer(isAnimating: isAnimating)
                        
                        HStack {
                            // Channel name placeholder
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 16)
                                .frame(width: 120)
                                .cornerRadius(4)
                                .shimmer(isAnimating: isAnimating)
                            
                            Spacer()
                            
                            // Date placeholder
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 16)
                                .frame(width: 80)
                                .cornerRadius(4)
                                .shimmer(isAnimating: isAnimating)
                        }
                    }
                }
            } else {
                // Podcast layout
                HStack(alignment: .top, spacing: 12) {
                    // Thumbnail placeholder
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 120, height: 68)
                        .cornerRadius(8)
                        .overlay(
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 35))
                                .foregroundColor(.white.opacity(0.3))
                        )
                        .shimmer(isAnimating: isAnimating)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // Title placeholder
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 20)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(4)
                            .shimmer(isAnimating: isAnimating)
                        
                        HStack {
                            // Channel name placeholder
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 16)
                                .frame(width: 120)
                                .cornerRadius(4)
                                .shimmer(isAnimating: isAnimating)
                            
                            Spacer()
                            
                            // Date placeholder
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 16)
                                .frame(width: 80)
                                .cornerRadius(4)
                                .shimmer(isAnimating: isAnimating)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

// Shimmer effect modifier
struct ShimmerModifier: ViewModifier {
    let isAnimating: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        Color.white.opacity(0.1)
                            .mask(
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.clear, .white.opacity(0.5), .clear]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width/2)
                                    .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                            )
                    }
                }
            )
            .clipped()
    }
}

extension View {
    func shimmer(isAnimating: Bool) -> some View {
        modifier(ShimmerModifier(isAnimating: isAnimating))
    }
}

#Preview {
    VStack(spacing: 16) {
        SkeletonView(isYouTube: true)
        SkeletonView(isYouTube: false)
    }
    .padding()
} 