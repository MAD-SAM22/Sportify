//
//  APIConstants.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//
//  APIConstants.swift
//  Sportify

import Foundation

struct APIConstants {

    struct Method {
        static let leagues = "Leagues"
        static let fixtures = "Fixtures"
        static let teams = "Teams"
    }

    struct Sport {
        static let football = "football"
        static let basketball = "basketball"
        static let cricket = "cricket"
        static let tennis = "tennis"
        static let hockey = "hockey"
        static let baseball = "baseball"
        static let rugby = "rugby"
        static let americanFootball = "AmericanFootball"
    }

    static func endpoint(for sport: String) -> String {
        switch sport.lowercased() {
        case "soccer", "football", "كرة القدم":
            return Sport.football
        case "basketball", "كرة السلة":
            return Sport.basketball
        case "cricket", "الكريكيت":
            return Sport.cricket
        case "tennis", "التنس":
            return Sport.tennis
        case "hockey":
            return Sport.hockey
        case "baseball":
            return Sport.baseball
        case "rugby":
            return Sport.rugby
        case "american football":
            return Sport.americanFootball
        default:
            return Sport.football
        }
    }
}

// MARK: - Network Errors
enum NetworkError: LocalizedError {
    case noInternet
    case noData
    case invalidURL
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .noInternet:
                    return NSLocalizedString("no_internet_message", comment: "")
        case .noData: return "No data returned from server."
        case .invalidURL: return "Invalid URL."
        case .decodingFailed: return "Failed to decode response."
        }
    }
}
