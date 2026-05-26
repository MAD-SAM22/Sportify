//
//  League.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//

import Foundation

struct LeaguesResponse: Decodable {
    let result: [League]?
}

struct League: Decodable {
    let leagueKey: Int?
    let leagueName: String?
    let leagueLogo: String?
}

extension League {
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
    }
}
