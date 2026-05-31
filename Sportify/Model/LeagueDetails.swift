//
//  LeagueDetails.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//
import Foundation

// To fetch both Recent and Upcoming games
struct EventsResponse: Decodable {
    let success: Int?
    let result: [Event]?
}

struct Event: Decodable {
    let eventKey: Int?
    let eventDate: String?
    let eventTime: String?

    // Home Team Data
    let eventHomeTeam: String?
    let homeTeamKey: Int?
    let homeTeamLogo: String?

    // Away Team Data
    let eventAwayTeam: String?
    let awayTeamKey: Int?
    let awayTeamLogo: String?

    // Match Details
    let eventFinalResult: String?
    let eventHalftimeResult: String?
    let eventFtResult: String?
    let eventStatus: String?

}

// Just to map between Swift camelCase and api's snake_case
extension Event {
    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"

        case eventHomeTeam = "event_home_team"
        case homeTeamKey = "home_team_key"
        case homeTeamLogo = "home_team_logo"

        case eventAwayTeam = "event_away_team"
        case awayTeamKey = "away_team_key"
        case awayTeamLogo = "away_team_logo"

        case eventFinalResult = "event_final_result"
        case eventHalftimeResult = "event_halftime_result"
        case eventFtResult       = "event_ft_result"
        case eventStatus = "event_status"
    }
}
