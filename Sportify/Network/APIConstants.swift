//
//  APIConstants.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//
import Foundation

enum APIConstants {

    static let apiKey: String = {

        guard let key = Bundle.main.object(
            forInfoDictionaryKey: "API_KEY"
        ) as? String else {

            fatalError("API_KEY not found")
        }

        return key
    }()

    static let baseURL: String = {

        guard let url = Bundle.main.object(
            forInfoDictionaryKey: "BASE_URL"
        ) as? String else {

            fatalError("BASE_URL not found")
        }

        return url
    }()
}
