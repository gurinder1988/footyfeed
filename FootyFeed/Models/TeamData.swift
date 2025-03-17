import SwiftUI

struct TeamData: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let shortName: String
    let primaryColor: Color
    let channelIds: [String]
    let podcastFeeds: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TeamData, rhs: TeamData) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Premier League teams with their data
    static let allTeams: [TeamData] = [
        TeamData(name: "Arsenal", shortName: "ARS", 
                primaryColor: Color(hex: "EF0107"),
                channelIds: ["UCpryVRk_VDudG8SHXgWcG0w"], 
                podcastFeeds: ["https://feeds.acast.com/public/shows/arseblog"]),
        TeamData(name: "Aston Villa", shortName: "AVL",
                primaryColor: Color(hex: "95BFE5"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Bournemouth", shortName: "BOU",
                primaryColor: Color(hex: "DA291C"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Brentford", shortName: "BRE",
                primaryColor: Color(hex: "e30613"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Brighton & Hove Albion", shortName: "BHA",
                primaryColor: Color(hex: "0057B8"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Chelsea", shortName: "CHE",
                primaryColor: Color(hex: "034694"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Crystal Palace", shortName: "CRY",
                primaryColor: Color(hex: "1B458F"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Everton", shortName: "EVE",
                primaryColor: Color(hex: "003399"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Fulham", shortName: "FUL",
                primaryColor: Color(hex: "000000"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Ipswich Town", shortName: "IPS",
                primaryColor: Color(hex: "003399"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Leicester City", shortName: "LEI",
                primaryColor: Color(hex: "003090"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Liverpool", shortName: "LIV",
                primaryColor: Color(hex: "C8102E"),
                channelIds: ["UC9LQwHZoucFT94I2h6JOcjw", "UCLZtjftZXtKY3eyCQFQG1vQ", "UC-OlILEMxKqJ9nsEBUOD9Xw"], 
                podcastFeeds: ["https://feeds.megaphone.fm/TAMC1249159518"]),
        TeamData(name: "Manchester City", shortName: "MCI",
                primaryColor: Color(hex: "6CABDD"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Manchester United", shortName: "MUN",
                primaryColor: Color(hex: "DA291C"),
                channelIds: ["UC6yW44UGJJBvYTlfC7CRg2Q", "UCMmVPVb0BwSIOWVeDwlPocQ"], 
                podcastFeeds: ["https://audioboom.com/channels/5150866.rss"]),
        TeamData(name: "Newcastle United", shortName: "NEW",
                primaryColor: Color(hex: "241F20"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Nottingham Forest", shortName: "NFO",
                primaryColor: Color(hex: "DD0000"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Southampton", shortName: "SOU",
                primaryColor: Color(hex: "D71920"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Tottenham Hotspur", shortName: "TOT",
                primaryColor: Color(hex: "132257"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "West Ham United", shortName: "WHU",
                primaryColor: Color(hex: "7A263A"),
                channelIds: [], podcastFeeds: []),
        TeamData(name: "Wolverhampton", shortName: "WOL",
                primaryColor: Color(hex: "FDB913"),
                channelIds: [], podcastFeeds: [])
    ]
} 