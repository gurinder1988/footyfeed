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
                    "UCywGl_BPp9QhD0uAcP2HsJw",  // Newcastle United official channel
                    "UCWaZLW7Bfa83J_h587dH1WQ",  // The True Geordie
                ],
                podcastFeeds: [
                    "https://feeds.megaphone.fm/RPSL8043727527",                         // The Everything is Black and White Podcast
                    "https://feeds.megaphone.fm/tamc8329829902",                          // The Athletic's Newcastle podcast
                ]
            )
        case "Nottingham Forest":
            return TeamSources(
                youtubeChannelIds: [
                    "UCyAxjuAr8f_BFDGCO3Htbxw",  // Nottingham Forest official channel
                ],
                podcastFeeds: [
                    "https://feeds.megaphone.fm/RPSL4344406766",                 // Garibaldi Red
                ]
            )
        case "Southampton":
            return TeamSources(
                youtubeChannelIds: [
                    "UCxvXjfiIHQ2O6saVx_ZFqnw",  // Southampton FC official channel
                ],
                podcastFeeds: [
                    "https://feeds.acast.com/public/shows/632d9f5d0b0d520016eaaaf1",                         // The Total Saints Podcast
                ]
            )
        case "Tottenham Hotspur":
            return TeamSources(
                youtubeChannelIds: [
                    "UCEg25rdRZXg32iwai6N6l0w",  // Tottenham Hotspur official channel
                    "UCUz_XIKFQOrliSqPZWJBq2g",  // WeAreTottenhamTV
                ],
                podcastFeeds: [
                    "https://feeds.megaphone.fm/COMG2620229365",             // The Fighting Cock
                    "https://feeds.megaphone.fm/tamc9359270914",                          // The Athletic's Spurs podcast (View from the Lane)
                    "https://feeds.megaphone.fm/COMG6410538070",                          // Last 
                ]
            )
        case "West Ham United":
            return TeamSources(
                youtubeChannelIds: [
                    "UCCNOsmurvpEit9paBOzWtUg",  // West Ham United official channel
                    "UC_tt4cYHIHNQAFQj2V2Wi-w",  // West Ham Fan TV
                ],
                podcastFeeds: [
                    "https://feeds.megaphone.fm/COMG8966246610",                            // We Are West Ham
                    "https://feeds.acast.com/public/shows/6310d339133a210012e8af38",      // The West Ham Way
                    "https://feeds.megaphone.fm/COMG7120718439",                               // STOP! Hammer Time - the West Ham United Podcast
                ]
            )
        case "Wolverhampton":
            return TeamSources(
                youtubeChannelIds: [
                    "UCQ7Lqg5Czh5djGK6iOG53KQ",  // Wolves official channel
                ],
                podcastFeeds: [
                    "https://feeds.megaphone.fm/AUDD2191021141",                         // E&S Wolves Podcast
                    "https://feeds.megaphone.fm/AUDD2191021141"                             // Wolves Fancast
                ]
            )
        default:
            return nil
        }
    }
}
