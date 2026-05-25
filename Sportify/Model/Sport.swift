//
//  SportsHome.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//

import Foundation

struct SportsResponse: Decodable {
    let result: [Sport]?
}

struct Sport: Decodable {
    let sportName: String?
    let sportThumb: String?
}

extension Sport {
    enum CodingKeys: String, CodingKey {
        case sportName = "strSport"
        case sportThumb = "strSportThumb"
    }
}
