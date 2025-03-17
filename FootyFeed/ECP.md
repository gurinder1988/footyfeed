# FootyFeed - External Context Protocol

## Project Metadata
```json
{
    "projectName": "FootyFeed",
    "version": "1.0.0",
    "platform": "iOS",
    "minimumDeploymentTarget": "15.0",
    "primaryLanguage": "Swift",
    "architecturePattern": "MVVM",
    "lastUpdated": "2024-03-15"
}
```

## Project Structure
```json
{
    "rootDirectories": {
        "App": "Core application files",
        "Models": "Data models and structures",
        "ViewModels": "MVVM view models",
        "Views": "SwiftUI views",
        "Services": "Network and data services",
        "Extensions": "Swift extensions",
        "Resources": "Assets and resources"
    }
}
```

## Core Features
```json
{
    "features": [
        {
            "name": "Team-specific Content Feed",
            "status": "Implemented",
            "components": ["FeedViewModel", "ContentService"],
            "description": "Displays team-specific news, videos, and podcasts"
        },
        {
            "name": "General Football Content",
            "status": "Implemented",
            "components": ["FeedViewModel", "ContentService"],
            "description": "Shows general football news and media"
        },
        {
            "name": "YouTube Integration",
            "status": "Implemented",
            "components": ["YouTubeService"],
            "description": "Fetches and displays team-specific YouTube content"
        },
        {
            "name": "Podcast Integration",
            "status": "Implemented",
            "components": ["PodcastService"],
            "description": "Manages podcast feeds and episodes"
        }
    ]
}
```

## Services
```json
{
    "services": {
        "YouTubeService": {
            "purpose": "Handles YouTube API interactions",
            "status": "Implemented",
            "dependencies": ["YouTubeAPI"]
        },
        "PodcastService": {
            "purpose": "Manages podcast feed parsing and playback",
            "status": "Implemented",
            "dependencies": ["RSS Parser"]
        },
        "ContentService": {
            "purpose": "Coordinates content loading and caching",
            "status": "Implemented",
            "dependencies": ["YouTubeService", "PodcastService"]
        }
    }
}
```

## Recent Changes
```json
{
    "changes": [
        {
            "date": "2024-03-16",
            "component": "CacheManager",
            "type": "Enhancement",
            "description": "Extended cache duration from 1 hour to 24 hours",
            "files": ["CacheManager.swift"],
            "status": "Completed"
        },
        {
            "date": "2024-03-16",
            "component": "Launch Screen",
            "type": "Enhancement",
            "description": "Enhanced launch screen with larger icon (150x150) and text (48pt)",
            "files": ["LaunchScreen.storyboard"],
            "status": "Completed"
        },
        {
            "date": "2024-03-15",
            "component": "Launch Screen",
            "type": "Feature",
            "description": "Implemented launch screen with app icon and title",
            "files": ["LaunchScreen.storyboard"],
            "status": "Completed"
        },
        {
            "date": "2024-03-15",
            "component": "App Icon",
            "type": "Asset",
            "description": "Added app icon in all required sizes",
            "files": ["Assets.xcassets/AppIcon.appiconset"],
            "status": "Completed"
        },
        {
            "date": "2024-03-14",
            "component": "FeedViewModel",
            "type": "Enhancement",
            "description": "Improved content loading and error handling",
            "files": ["FeedViewModel.swift"],
            "status": "Completed"
        }
    ]
}
```

## Current State
```json
{
    "developmentStage": "Pre-launch",
    "completedItems": [
        "Core functionality",
        "Content loading",
        "Error handling",
        "App icon",
        "Launch screen"
    ],
    "pendingItems": [
        "App Store screenshots",
        "App Store listing content",
        "Privacy policy",
        "Terms of service",
        "Analytics integration",
        "TestFlight setup"
    ]
}
```

## Technical Specifications
```json
{
    "frameworks": [
        "SwiftUI",
        "Combine",
        "URLSession"
    ],
    "apis": {
        "youtube": {
            "version": "v3",
            "features": ["channel content", "playlists"]
        },
        "rss": {
            "type": "RSS 2.0",
            "features": ["podcast feeds"]
        }
    },
    "persistence": {
        "type": "Local cache",
        "implementation": "FileManager"
    }
}
```

## Build Configuration
```json
{
    "configurations": {
        "debug": {
            "optimization": "none",
            "debugging": "enabled"
        },
        "release": {
            "optimization": "speed",
            "debugging": "disabled"
        }
    },
    "targetDevices": [
        "iPhone",
        "iPad"
    ],
    "orientations": [
        "portrait"
    ]
}
```

## Notes for AI Systems
```json
{
    "contextNotes": [
        "Project uses MVVM architecture with SwiftUI",
        "Content loading is asynchronous using async/await",
        "Error handling is implemented at service and view model levels",
        "UI follows iOS Human Interface Guidelines",
        "App is universal (iPhone + iPad)",
        "Minimum deployment target is iOS 15.0"
    ],
    "codeConventions": [
        "Swift style guide followed",
        "Async/await preferred over completion handlers",
        "MVVM pattern strictly enforced",
        "Services are protocol-based for testability"
    ]
}
```

## Launch Screen Implementation
- Created a custom `LaunchScreen.storyboard` for the app launch experience
- Implemented a centered layout with stack view containing:
  - Launch icon (150x150 pixels)
  - App title "Footy Feed" with 48pt bold font
- Used Auto Layout constraints to ensure proper centering and spacing
- Set background color to match app theme (dark purple: #320032)
- Configured proper image assets and text styling for optimal visibility
- Ensured proper configuration in project settings and Info.plist 

## UI/UX Design Specifications
```json
{
    "theme": {
        "colors": {
            "primary": {
                "hex": "#320032",
                "usage": ["app background", "launch screen"]
            },
            "text": {
                "primary": {
                    "hex": "#FFFFFF",
                    "usage": ["headlines", "titles"]
                },
                "secondary": {
                    "hex": "#E0E0E0",
                    "usage": ["subtitles", "descriptions"]
                }
            },
            "accent": {
                "hex": "#FFD700",
                "usage": ["buttons", "highlights"]
            }
        },
        "typography": {
            "appTitle": {
                "font": "System Bold",
                "size": "48pt",
                "usage": ["launch screen"]
            },
            "headlines": {
                "font": "System Bold",
                "size": "24pt",
                "usage": ["feed item titles"]
            },
            "body": {
                "font": "System Regular",
                "size": "16pt",
                "usage": ["feed item descriptions"]
            }
        },
        "spacing": {
            "standard": "16pt",
            "compact": "8pt",
            "loose": "24pt"
        }
    },
    "components": {
        "launchScreen": {
            "layout": "centered stack",
            "elements": [
                {
                    "type": "image",
                    "asset": "LaunchIcon",
                    "size": "150x150pt",
                    "constraints": "centered"
                },
                {
                    "type": "text",
                    "content": "Footy Feed",
                    "style": "appTitle",
                    "color": "text.primary"
                }
            ],
            "background": "primary"
        },
        "feedItem": {
            "layout": "vertical stack",
            "padding": "16pt",
            "cornerRadius": "12pt",
            "elements": [
                {
                    "type": "image",
                    "asset": "thumbnail",
                    "aspectRatio": "16:9",
                    "cornerRadius": "8pt"
                },
                {
                    "type": "text",
                    "style": "headlines",
                    "content": "title",
                    "padding": "8pt"
                },
                {
                    "type": "text",
                    "style": "body",
                    "content": "description",
                    "maxLines": 2
                },
                {
                    "type": "metadata",
                    "elements": [
                        {
                            "type": "text",
                            "content": "publishDate",
                            "style": "caption"
                        },
                        {
                            "type": "text",
                            "content": "channelName",
                            "style": "caption"
                        }
                    ]
                }
            ]
        },
        "contentTypeIndicator": {
            "types": {
                "youtube": {
                    "icon": "play.circle.fill",
                    "color": "#FF0000"
                },
                "podcast": {
                    "icon": "headphones",
                    "color": "#8E44AD"
                }
            }
        }
    },
    "navigation": {
        "style": "tab-based",
        "tabs": [
            {
                "title": "Feed",
                "icon": "newspaper",
                "primary": true
            },
            {
                "title": "Settings",
                "icon": "gear"
            }
        ]
    },
    "animations": {
        "transitions": {
            "feedItemAppear": {
                "type": "fade",
                "duration": "0.3s",
                "timing": "easeInOut"
            },
            "contentLoading": {
                "type": "skeleton",
                "duration": "infinite",
                "timing": "linear"
            }
        }
    },
    "accessibility": {
        "minimumTapArea": "44x44pt",
        "dynamicType": "supported",
        "voiceOver": {
            "feedItem": "Article: {title}, from {channelName}, published {date}",
            "contentType": "{type} content"
        }
    }
}
``` 