import SwiftUI
import WebKit
import AVKit

struct ContentView: View {
    @StateObject private var viewModel = FeedViewModel()
    @StateObject private var playerState = PlayerState.shared
    @State private var showPopup = false
    @State private var selectedTeam: TeamData? = nil
    @State private var expandedVideoID: String? = nil
    @State private var showErrorAlert = false
    @State private var initialLoadDone = false
    @State private var loadingProgress: Double = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                if viewModel.isLoading && viewModel.feedItems.isEmpty {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Loading indicator at the top
                            VStack(spacing: 12) {
                                ProgressView()
                                    .scaleEffect(1.5)
                                
                                Text("Loading content...")
                                    .foregroundColor(.secondary)
                                
                                // Progress bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: geometry.size.width, height: 4)
                                            .cornerRadius(2)
                                        
                                        Rectangle()
                                            .fill(Color.blue)
                                            .frame(width: geometry.size.width * loadingProgress, height: 4)
                                            .cornerRadius(2)
                                    }
                                }
                                .frame(height: 4)
                                .frame(width: 200)
                            }
                            .padding(.vertical)
                            
                            // Skeleton views
                            LazyVStack(spacing: 16) {
                                ForEach(0..<3) { _ in
                                    SkeletonView(isYouTube: true)
                                        .padding(.horizontal)
                                }
                                ForEach(0..<2) { _ in
                                    SkeletonView(isYouTube: false)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    .onAppear {
                        // Animate the progress bar
                        withAnimation(.easeInOut(duration: 3.0)) {
                            loadingProgress = 0.6  // Show initial content load
                        }
                        
                        // After a delay, complete the progress
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                            withAnimation(.easeOut(duration: 2.0)) {
                                loadingProgress = 1.0
                            }
                        }
                    }
                } else if let error = viewModel.error, viewModel.feedItems.isEmpty {
                    // Complete error view when no content is available
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text("Unable to load content")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(error.localizedDescription)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        Button(action: {
                            viewModel.refreshContent()
                        }) {
                            Text("Try Again")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            // Show partial error message if there was an issue with some feeds
                            if viewModel.hasPartialError {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle")
                                        .foregroundColor(.orange)
                                    
                                    Text("Some content couldn't be loaded")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        viewModel.refreshContent()
                                    }) {
                                        Text("Retry")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal)
                            }
                            
                            ForEach(viewModel.feedItems) { item in
                                FeedItemView(item: item,
                                           isVideoExpanded: item.contentType == .youtube && item.id == expandedVideoID,
                                           onTap: {
                                    switch item.contentType {
                                    case .youtube:
                                        if expandedVideoID == item.id {
                                            expandedVideoID = nil
                                        } else {
                                            // Stop podcast if playing
                                            playerState.cleanup()
                                            expandedVideoID = item.id
                                        }
                                    case .podcast:
                                        // Stop YouTube video if playing
                                        expandedVideoID = nil
                                        playerState.play(podcast: item)
                                    }
                                })
                                .padding(.horizontal)
                            }
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding()
                            }
                        }
                        // Add bottom padding if mini-player is visible
                        .padding(.bottom, playerState.currentPodcast != nil ? 60 : 0)
                    }
                    .refreshable {
                        loadingProgress = 0  // Reset progress when refreshing
                        viewModel.refreshContent()
                    }
                }
                
                // Mini player
                MiniPlayerView()
            }
            .navigationTitle("Footy Feed")
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Playback Error"),
                    message: Text("There was a problem playing this content. Please try again."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .sheet(isPresented: $showPopup) {
            PopupView(selectedTeam: $selectedTeam)
        }
        .onChange(of: selectedTeam) { newTeam in
            if let team = newTeam {
                viewModel.setFavoriteTeam(team.name)
                showPopup = false
            }
        }
        .onAppear {
            // Only show popup if no favorite team is set
            if viewModel.favoriteTeam == nil {
                showPopup = true
            }
            
            // Only trigger initial content load if not already done
            if !initialLoadDone {
                initialLoadDone = true
                // Content loading is now handled by FeedViewModel's init
            }
        }
    }
}