import Foundation

struct TeamSources {
    let youtubeChannelIds: [String]
    let podcastFeeds: [String]
    
    static func getSourcesForTeam(_ team: String) -> TeamSources? {
        switch team {
        case "Arsenal":
            return TeamSources(
                youtubeChannelIds: [
                    "UCpryVRk_VDudG8SHXgWcG0w",  // Arsenal official channel
                    "UCBTy8j2cPy6zw68godcE7MQ",  // AFTV (Arsenal Fan TV)
                ],
                podcastFeeds: [
                    "https://feeds.acast.com/public/shows/arseblog",                      // Arsecast
                    "https://feeds.simplecast.com/sjbSL_pM",          // Arsenal Vision Podcast
                    "https://feeds.megaphone.fm/tamc8710867513",                          // The Athletic's Arsenal podcast
                ]
            )
        case "Aston Villa":
            return TeamSources(
                youtubeChannelIds: [
                    "UCICNP0mvtr0prFwGUQIABfQ",  // Aston Villa official channel
                ],
                podcastFeeds: [
                    "pcast://feeds.megaphone.fm/RPSL1112526468",                              // Claret & Blue
                    "pcast://feeds.megaphone.fm/COMG3846388170",                 // 1874
                ]
            )
        case "Bournemouth":
            return TeamSources(
                youtubeChannelIds: [
                    "UCeOCuVSSweaEj6oVtJZEKQw",  // AFC Bournemouth official channel
                ],
                podcastFeeds: [
                    "https://feeds.megaphone.fm/COMG6908062414",     // Back of the Net: The AFC Bournemouth Podcast
                ]
            )
        case "Brentford":
            return TeamSources(
                youtubeChannelIds: [
                    "UCAalMUm3LIf504ItA3rqfug",  // Brentford FC official channel
                ],
                podcastFeeds: [
                    "https://feeds.acast.com/public/shows/the-beesotted-brentford-pride-of-west-london-podcast",  // Beesotted: The Brentford Podcast
                ]
            )
        case "Brighton & Hove Albion":
            return TeamSources(
                youtubeChannelIds: [
                    "UCA7P8SdcKV2GjvMGu2SRBggUCf-cpC9WAdOsas19JHipukA",  // Brighton & Hove Albion official channel
                ],
                podcastFeeds: [
                    "https://audioboom.com/channels/4930733.rss",                          // Albion Roar
                ]
            )
        case "Chelsea":
            return TeamSources(
                youtubeChannelIds: [
                    "UCU2PacFf99vhb3hNiYDmxww",  // Chelsea FC official channel
                    "UCrqLlEb8x9sePxwLgo0EmrA",  // Chelsea Fan TV
                ],
                podcastFeeds: [
                    "https://rss.art19.com/london-is-blue",                           // London Is Blue
                    "https://feeds.megaphone.fm/tamc3480149888",                          // The Athletic's Chelsea podcast (Straight Outta Cobham)
                ]
            )
        case "Crystal Palace":
            return TeamSources(
                youtubeChannelIds: [
                    "UCWB9N0012fG6bGyj486Qxmg",  // Crystal Palace FC official channel
                ],
                podcastFeeds: [
                    "https://feeds.megaphone.fm/COMG8424453613",              // FYP Podcast
                ]
            )
        case "Everton":
            return TeamSources(
                youtubeChannelIds: [
                    "UCtK4QAczAN2mt2ow_jlGinQ",  // Everton FC official channel
                    "UCGW8QX7RCU_UBKKcDRN0Dgg",   // Toffee TV
                ],
                podcastFeeds: [
                    "https://feeds.megaphone.fm/COMG3276268605",      // The Blue Room
                ]
            )
        case "Fulham":
            return TeamSources(
                youtubeChannelIds: [
                    "UC2VLfz92cTT8jHIFOecC-LA",  // Fulham FC official channel
                ],
                podcastFeeds: [
                    "https://rss.art19.com/fulhamish",                     // Fulhamish
                ]
            )
        case "Ipswich Town":
            return TeamSources(
                youtubeChannelIds: [
                    "UCjNwxJec96lMWgCXjEDhXgQ",  // Ipswich Town FC official channel
                ],
                podcastFeeds: [
                    "https://feeds.acast.com/public/shows/bluemondaypodcast",                     // Blue Monday Podcast
                ]
            )
        case "Leicester City":
            return TeamSources(
                youtubeChannelIds: [
                    "UCBkRQtxofyXr09mWtgoUUqw",  // Leicester City official channel
                ],
                podcastFeeds: [
                    "https://feeds.megaphone.fm/COMG3069761203",      // The Big Strong Leicester Boys
                ]
            )
        case "Liverpool":
            return TeamSources(
                youtubeChannelIds: [
                    "UC9LQwHZoucFT94I2h6JOcjw",  // Liverpool FC official channel
                    "UC30avO2n6knAFiH2c8e4qiw",  // The Redmen TV
                    "UCc5C5dNupCMbyutNatfBujQ",  // The Anfield Wrap
                ],
                podcastFeeds: [
                    "https://feeds.megaphone.fm/tamc1571459869",                          // Walk On: The Athletic FC's Liverpool show
                    "https://feeds.megaphone.fm/COMG6516013185",      // The Anfield Wrap
                    "https://feeds.megaphone.fm/RPSL9422504008",  // Blood Red Podcast
                    "https://feeds.acast.com/public/shows/52fa29b2-4f7d-4d5c-8d36-d1cb2a782d0e"  // The Redmen TV Podcast
                ]
            )
        case "Manchester City":
            return TeamSources(
                youtubeChannelIds: [
                    "UCkzCjdRMrW2vXLx8mvPVLdQ",  // Manchester City official channel
                    "UCMxNPuhwTVMFkVoRjlARtaQ",  // Esteemed Kompany
                ],
                podcastFeeds: [
                    "https://feeds.megaphone.fm/tamc5449073018",      // Why Always Us?
                ]
            )
        case "Manchester United":
            return TeamSources(
                youtubeChannelIds: [
                    "UC6yW44UGJJBvYTlfC7CRg2Q",  // Man Utd official channel
                    "UCMmVPVb0BwSIOWVeDwlPocQ",  // The United Stand
                    "UC7w8GnTF2Sp3wldDMtCCtVw",  // Stretford Paddock
                    "UCWK5ujYgH7q3cA1Pt4ngvUw"   // Mark Goldbridge
                ],
                podcastFeeds: [
                    "https://audioboom.com/channels/5150866.rss",       // The United Stand
                    "https://feeds.megaphone.fm/tamc5259999126",        // Talk of the Devils
                    "https://podcasts.files.bbci.co.uk/p00500pg.rss",   // BBC Devils' Advocate
                    "https://audioboom.com/channels/504284.rss"         // United We Stand
                ]
            )
        case "Newcastle United":
            return TeamSources(
                youtubeChannelIds: [
                    "UCFY2YvZqchOf9fUEqpJPYoA",  // Newcastle United official channel
                    "UCVL-RKmrCOe6VQV9clwzYDg",  // The True Geordie
                    "UC6MrV2f3-EZHBKfv_hBy9Pw",  // The Magpie Channel TV
                    "UCNzCbX5Jir1MJUvj2TEzwOQ"   // NUFC TV
                ],
                podcastFeeds: [
                    "https://audioboom.com/channels/4940183.rss",                         // The Everything is Black and White Podcast
                    "https://feeds.megaphone.fm/TAMC4911418870",                          // The Athletic's Newcastle podcast
                    "https://feeds.acast.com/public/shows/the-magpie-channel",            // The Magpie Channel
                    "https://feeds.megaphone.fm/nufc-matters"                             // NUFC Matters
                ]
            )
        case "Nottingham Forest":
            return TeamSources(
                youtubeChannelIds: [
                    "UCT8fYzEYCO-7vMMNZR2pdlg",  // Nottingham Forest official channel
                    "UCDwuKWoWCZMIrP3gML7KRBw",  // Nottingham Forest News
                    "UC3r24w_37ZN2TOYSoQUNAoA",  // Forza Garibaldi
                    "UCEZZ6fvx_nofyuL-bKPGl2A"   // Nottingham Forest Fan Channel
                ],
                podcastFeeds: [
                    "https://feeds.acast.com/public/shows/garibaldi-red",                 // Garibaldi Red
                    "https://feeds.soundcloud.com/users/soundcloud:users:275864151/sounds.rss",  // Dore On Tour
                    "https://feeds.buzzsprout.com/1976528.rss",                           // Forests Are Fireproof
                    "https://feeds.megaphone.fm/TAMC1249159518"                           // The Athletic's Forest coverage
                ]
            )
        case "Southampton":
            return TeamSources(
                youtubeChannelIds: [
                    "UCH4H-h8IKRiVr-wy9FdHBGg",  // Southampton FC official channel
                    "UCKnAk_5d159Xd-nBJNNKjGg",  // The Ugly Inside TV
                    "UC2iFRV5jEF5XfVMB58ow-LA",  // Southampton Dellivery
                    "UCj8R-nCKy-VFBtbVK8SZnJw"   // Total Saints Podcast
                ],
                podcastFeeds: [
                    "https://audioboom.com/channels/5023799.rss",                         // The Total Saints Podcast
                    "https://feeds.acast.com/public/shows/61c0cc0a76f9e600143bcd1e",      // The Ugly Inside
                    "https://feeds.buzzsprout.com/1027929.rss",                           // Southampton Dellivery
                    "https://feeds.megaphone.fm/TAMC1249159518"                           // The Athletic's Southampton coverage
                ]
            )
        case "Tottenham Hotspur":
            return TeamSources(
                youtubeChannelIds: [
                    "UCEg25rdRZXg32iwai6N6l0w",  // Tottenham Hotspur official channel
                    "UCWUCWx2Kw6TD-5eSvJbVPCg",  // SpursWeb
                    "UCt4vqkiIeYZ4KSAc7Sd-8zQ",  // WeAreTottenhamTV
                    "UC_Jc_kLX7QJlmox_yb3IkXw"   // The Spurs Web
                ],
                podcastFeeds: [
                    "https://feeds.acast.com/public/shows/the-fighting-cock",             // The Fighting Cock
                    "https://feeds.megaphone.fm/TAMC7824438163",                          // The Athletic's Spurs podcast (View from the Lane)
                    "https://feeds.acast.com/public/shows/the-extra-inch",                // The Extra Inch
                    "https://rss.acast.com/lastwordontottenham"                           // Last Word On Spurs
                ]
            )
        case "West Ham United":
            return TeamSources(
                youtubeChannelIds: [
                    "UC6KUZPXoZlUwxgJj5ufxI8A",  // West Ham United official channel
                    "UCVpELdHX0iOYsC2xzWB6VSg",  // West Ham Fan TV
                    "UCcEPUqv5hGGRrIL0_rNw0vg",  // Hammers Chat
                    "UCmDnEwjYGFub22fPGbDwH4A"   // We Are West Ham
                ],
                podcastFeeds: [
                    "https://feeds.buzzsprout.com/746680.rss",                            // We Are West Ham
                    "https://feeds.acast.com/public/shows/5e7a06bf6b8e25a09d9d29d8",      // The West Ham Way
                    "https://rss.acast.com/thehammerschat",                               // Hammers Chat Podcast
                    "https://feeds.megaphone.fm/TAMC5610892596"                           // The Athletic's West Ham coverage
                ]
            )
        case "Wolverhampton":
            return TeamSources(
                youtubeChannelIds: [
                    "UCeYF0AYKh4txiKJdJh2OD6g",  // Wolves official channel
                    "UC_kwxowXj-WZq_5bnuuu3_g",  // Talking Wolves
                    "UCF-Ww-RqDAq2Hul8qmPrPKw",  // Wolves Fancast
                    "UCaRzR8BHlUw9xCo7qWgGObw"   // The Wolf Pack Podcast
                ],
                podcastFeeds: [
                    "https://feeds.acast.com/public/shows/62bc2ab09fb8ac001277ebb9",      // Talking Wolves
                    "https://audioboom.com/channels/4950577.rss",                         // E&S Wolves Podcast
                    "https://feeds.captivate.fm/the-molineux-view/",                      // The Molineux View
                    "https://feeds.buzzsprout.com/919120.rss"                             // Wolves Fancast
                ]
            )
        default:
            return nil
        }
    }
}
