# FootyFeed

FootyFeed is an iOS application that aggregates and presents football (soccer) content from various sources, including YouTube channels and podcasts, with a specific focus on the Premier League. The app provides a unified feed that combines general football content with team-specific content based on your favorite Premier League team selection.

## Vision

FootyFeed aims to be the ultimate destination for passionate Premier League fans, offering a comprehensive and seamless content experience. By bringing together high-quality content from trusted sources - including match analysis, transfer news, fan discussions, and club-specific coverage - we eliminate the need to juggle multiple apps and websites. Whether you're a die-hard supporter of a specific club or a general Premier League enthusiast, FootyFeed delivers all your football content needs in one beautifully designed, easy-to-use platform.

Our mission is to:
- Simplify how fans consume Premier League content
- Provide personalized, team-specific content while maintaining broader league coverage
- Deliver a premium user experience that respects both casual viewers and hardcore supporters
- Create a single, reliable source for all Premier League-related content needs

## Features

### Content Aggregation
- **Premier League Focus**: Dedicated coverage of all 20 Premier League teams
- **Smart Content Mix**: 
  - Base feed includes content from popular football channels and podcasts
  - Additional team-specific content automatically integrated when a favorite team is selected
  - Seamless combination of general football news and team-focused coverage
- **YouTube Integration**: Automatically fetches latest videos from popular football channels
- **Podcast Support**: Streams audio content from football-focused podcasts
- **Team Selection**: Choose your favorite Premier League team from all 20 premier league clubs to customize your feed
- **General Football Content**: Access to broader football content beyond team-specific news

### User Interface
- **Modern Design**: Clean, intuitive interface with distinct card layouts for videos and podcasts
- **Video Player**: 
  - Embedded YouTube player
  - Expandable video cards with 16:9 thumbnails
  - Seamless playback integration
- **Podcast Player**:
  - Built-in audio player with playback controls
  - Background audio support
  - Mini player for continuous listening while browsing
- **Smart Feed**:
  - Chronological content organization
  - Pull-to-refresh functionality
  - Cached content for offline viewing
  - Error handling with graceful fallbacks

### Technical Features
- **Async Content Loading**: Parallel fetching of content from multiple sources
- **Caching System**: Local storage of feed items for improved performance
- **Error Handling**: Robust error management with user-friendly messages
- **State Management**: Efficient view model architecture with SwiftUI
- **Background Audio**: AVFoundation integration for podcast playback


2. Build and run the project (⌘+R)

## Project Structure

```
FootyFeed/
├── App/
│   └── FootyFeedApp.swift
├── Views/
│   ├── ContentView.swift
│   ├── FeedItemView.swift
│   ├── MediaPlayerView.swift
│   ├── YouTubePlayerView.swift
│   ├── MiniPlayerView.swift
│   └── PopupView.swift
├── ViewModels/
│   ├── FeedViewModel.swift
│   └── PlayerState.swift
├── Models/
│   ├── FeedItem.swift
│   └── TeamSources.swift
└── Services/
    ├── YouTubeService.swift
    ├── PodcastService.swift
    └── CacheManager.swift
```

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Data structures representing content items and team sources
- **Views**: SwiftUI views for rendering the user interface
- **ViewModels**: Business logic and state management
- **Services**: Data fetching and caching functionality

### Key Components

- `FeedViewModel`: Manages content fetching and feed state
- `PlayerState`: Handles audio playback and player UI state
- `YouTubeService`: Fetches and parses YouTube RSS feeds
- `PodcastService`: Manages podcast feed parsing and audio streaming
- `CacheManager`: Handles local storage of feed items

## Content Sources

### Base Content (Available to All Users)
- **YouTube Channels**:
  - Tifo Football
  - The Overlap
  - That's Football
  - HITC Sevens
  - Fabrizio Romano
  - The Athletic FC
  - Thogden

- **Podcasts**:
  - The Football Ramble
  - The Guardian Football Weekly
  - ESPN FC
  - Totally Football Show
  - Men in Blazers
  - The Gary Neville Podcast
  - Sky Sports Football Podcast

### Team-Specific Content
- Automatically added to your feed based on your selected Premier League team
- Each Premier League team has its dedicated:
  - YouTube channels
  - Fan podcasts
  - Club media content

### Content Integration
- Base content and team-specific content are seamlessly merged into a single chronological feed
- Smart filtering ensures relevant content priority
- All content maintains high quality and relevance to Premier League football
