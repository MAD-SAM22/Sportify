//
//  NetworkManager.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//
import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: - Read from Info.plist
    private var baseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("❌ BASE_URL not found in Info.plist")
        }
        return url
    }
    
    private var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("❌ API_KEY not found in Info.plist")
        }
        return key
    }
    
    // MARK: - Generic Request
    private func request<T: Decodable>(
        sport: String,
        parameters: [String: Any],
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var params = parameters
        params["APIkey"] = apiKey
        
        let endpoint = APIConstants.endpoint(for: sport)
        let url = baseURL + endpoint + "/"

        print("🌐 Request URL: \(url)")
        print("📦 Params: \(params)")
        
        AF.request(url, parameters: params)
            .validate()
            .responseDecodable(of: T.self) { response in
                
                // Debug
                if let data = response.data,
                   let json = String(data: data, encoding: .utf8) {
                    print("📡 Response: \(json.prefix(300))")
                }
                
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - ① Fetch Leagues
    func fetchLeagues(
        for sport: String,
        completion: @escaping (Result<[League], Error>) -> Void
    ) {
        let params: [String: Any] = ["met": APIConstants.Method.leagues]
        
        request(sport: sport, parameters: params) { (result: Result<LeaguesResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.result ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func searchLeagues(
        query: String,
        for sport: String,
        completion: @escaping (Result<[League], Error>) -> Void
    ) {
        // If query is empty, just fetch everything or return early
        guard !query.isEmpty else {
            fetchLeagues(for: sport, completion: completion)
            return
        }
        
        // Add the appropriate query key depending on your API documentation (e.g., "league_name" or "search")
        let params: [String: Any] = [
            "met": APIConstants.Method.leagues,
            "league_name": query
        ]
        
        request(sport: sport, parameters: params) { (result: Result<LeaguesResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.result ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - ② Fetch Upcoming Events
    func fetchUpcomingEvents(
        leagueId: Int,
        sport: String,
        completion: @escaping (Result<[Event], Error>) -> Void
    ) {
        let params: [String: Any] = [
            "met":      APIConstants.Method.fixtures,
            "leagueId": leagueId,
            "from":     formattedDate(offset: 0),
            "to":       formattedDate(offset: 30)
        ]
        
        request(sport: sport, parameters: params) { (result: Result<EventsResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.result ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - ③ Fetch Recent Events
    func fetchRecentEvents(
        leagueId: Int,
        sport: String,
        completion: @escaping (Result<[Event], Error>) -> Void
    ) {
        let params: [String: Any] = [
            "met":      APIConstants.Method.fixtures,
            "leagueId": leagueId,
            "from":     formattedDate(offset: -30),
            "to":       formattedDate(offset: 0)
        ]
        
        request(sport: sport, parameters: params) { (result: Result<EventsResponse, Error>) in
            switch result {
            case .success(let response):
                let finished = (response.result ?? []).filter {
                    $0.eventFinalResult != nil &&
                    $0.eventFinalResult != "" &&
                    $0.eventFinalResult != "? - ?"
                }
                completion(.success(finished))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - ④ Fetch Teams
    func fetchTeams(
        leagueId: Int,
        sport: String,
        completion: @escaping (Result<[Team], Error>) -> Void
    ) {
        let params: [String: Any] = [
            "met":      APIConstants.Method.teams,
            "leagueId": leagueId
        ]
        
        request(sport: sport, parameters: params) { (result: Result<TeamsResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.result ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - ⑤ Fetch Team Details
    func fetchTeamDetails(
        teamId: Int,
        sport: String,
        completion: @escaping (Result<Team, Error>) -> Void
    ) {
        let params: [String: Any] = [
            "met":    APIConstants.Method.teams,
            "teamId": teamId
        ]
        
        request(sport: sport, parameters: params) { (result: Result<TeamsResponse, Error>) in
            switch result {
            case .success(let response):
                if let team = response.result?.first {
                    completion(.success(team))
                } else {
                    completion(.failure(NetworkError.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - ⑥ Fetch League Details (Teams + Recent + Upcoming in parallel)
    func fetchLeagueDetails(
        leagueId: Int,
        sport: String,
        completion: @escaping (
            _ teams:    [Team],
            _ recent:   [Event],
            _ upcoming: [Event]
        ) -> Void
    ) {
        let group = DispatchGroup()
        
        var teams:    [Team]  = []
        var recent:   [Event] = []
        var upcoming: [Event] = []
        
        // Teams
        group.enter()
        fetchTeams(leagueId: leagueId, sport: sport) { result in
            if case .success(let data) = result { teams = data }
            group.leave()
        }
        
        // Recent
        group.enter()
        fetchRecentEvents(leagueId: leagueId, sport: sport) { result in
            if case .success(let data) = result { recent = data }
            group.leave()
        }
        
        // Upcoming
        group.enter()
        fetchUpcomingEvents(leagueId: leagueId, sport: sport) { result in
            if case .success(let data) = result { upcoming = data }
            group.leave()
        }
        
        // All 3 complete — return on main thread
        group.notify(queue: .main) {
            completion(teams, recent, upcoming)
        }
    }
    
    // MARK: - Date Helper
    private func formattedDate(offset days: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = Calendar.current.date(
            byAdding: .day,
            value: days,
            to: Date()
        ) ?? Date()
        return formatter.string(from: date)
    }
}


