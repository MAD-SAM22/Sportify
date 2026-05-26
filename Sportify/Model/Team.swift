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
}

extension Team {
    enum CodingKeys: String, CodingKey {

        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"

        case teamCountry = "team_country"
        case teamFounded = "team_founded"

        case venueName = "venue_name"
    }
}

//struct Team {
//    let name: String
//    let country: String
//    let stadium: String
//    let founded: String
//    let about: String
//    let bannerImage: String
//    let logoImage: String
//    let sport: String
//}
