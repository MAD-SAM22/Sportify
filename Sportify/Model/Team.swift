//
//  Team.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//
import Foundation

//  To populate the top horizontal carousel
struct TeamsResponse: Decodable {
    let result: [Team]?
}

struct Team: Decodable {

    let teamKey: Int?
    let teamName: String?
    let teamLogo: String?

    let teamCountry: String?
    let teamFounded: String?

    let venueName: String?
    let players: [Player]?
}

extension Team {
    enum CodingKeys: String, CodingKey {

        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"

        case teamCountry = "team_country"
        case teamFounded = "team_founded"

        case venueName = "venue_name"
        case players     = "players"

    }
}

struct Player: Decodable {
    let playerKey: Int?
    let playerName: String?
    let playerImage: String?
    let playerNumber: String?
    let playerPosition: String?

    enum CodingKeys: String, CodingKey {
        case playerKey      = "player_key"
        case playerName     = "player_name"
        case playerImage    = "player_image"
        case playerNumber   = "player_number"
        case playerPosition = "player_type"
    }
}
