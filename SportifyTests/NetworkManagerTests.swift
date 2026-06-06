//
//  NetworkManagerTests.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.
//


import XCTest
import Alamofire
@testable import Sportify

// MARK: - MockURLProtocol

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

// MARK: - Fixtures

private func mockResponse(statusCode: Int = 200) -> HTTPURLResponse {
    HTTPURLResponse(url: URL(string: "https://mock.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

private let leaguesJSON = """
{ "success": 1, "result": [{ "league_key": 1, "league_name": "Premier League", "league_logo": "https://logo.png" }] }
""".data(using: .utf8)!

private let teamsJSON = """
{ "success": 1, "result": [{ "team_key": 10, "team_name": "Arsenal", "team_logo": "https://arsenal.png" }] }
""".data(using: .utf8)!

private let finishedEventJSON = """
{ "success": 1, "result": [{ "event_key": 1, "event_home_team": "Arsenal", "event_away_team": "Chelsea", "event_final_result": "2 - 1" }] }
""".data(using: .utf8)!

private let unfinishedEventJSON = """
{ "success": 1, "result": [{ "event_key": 2, "event_home_team": "Arsenal", "event_away_team": "Chelsea", "event_final_result": "? - ?" }] }
""".data(using: .utf8)!

private let emptyJSON = """
{ "success": 1, "result": [] }
""".data(using: .utf8)!

// MARK: - NetworkManagerTests

final class NetworkManagerTests: XCTestCase {

    var sut: NetworkManager!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        sut = NetworkManager(session: Session(configuration: config))
    }

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - fetchLeagues

    func test_fetchLeagues_success_returnsLeagues() {
        MockURLProtocol.requestHandler = { _ in (mockResponse(), leaguesJSON) }
        let exp = expectation(description: #function)

        sut.fetchLeagues(for: "football") { result in
            if case .success(let leagues) = result {
                XCTAssertEqual(leagues.count, 1)
                XCTAssertEqual(leagues.first?.leagueName, "Premier League")
            } else { XCTFail("Expected success") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }

    func test_fetchLeagues_emptyResult_returnsEmptyArray() {
        MockURLProtocol.requestHandler = { _ in (mockResponse(), emptyJSON) }
        let exp = expectation(description: #function)

        sut.fetchLeagues(for: "football") { result in
            if case .success(let leagues) = result { XCTAssertTrue(leagues.isEmpty) }
            else { XCTFail("Expected success") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }

    func test_fetchLeagues_networkError_returnsFailure() {
        MockURLProtocol.requestHandler = { _ in throw URLError(.notConnectedToInternet) }
        let exp = expectation(description: #function)

        sut.fetchLeagues(for: "football") { result in
            if case .failure = result { /* ✅ */ } else { XCTFail("Expected failure") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }

    func test_fetchLeagues_serverError_returnsFailure() {
        MockURLProtocol.requestHandler = { _ in (mockResponse(statusCode: 500), Data()) }
        let exp = expectation(description: #function)

        sut.fetchLeagues(for: "football") { result in
            if case .failure = result { /* ✅ */ } else { XCTFail("Expected failure") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }

    // MARK: - searchLeagues

    func test_searchLeagues_emptyQuery_fallsBackToFetchAll() {
        MockURLProtocol.requestHandler = { _ in (mockResponse(), leaguesJSON) }
        let exp = expectation(description: #function)

        sut.searchLeagues(query: "", for: "football") { result in
            if case .success(let leagues) = result { XCTAssertEqual(leagues.count, 1) }
            else { XCTFail("Expected success") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }

    func test_searchLeagues_withQuery_returnsResults() {
        MockURLProtocol.requestHandler = { _ in (mockResponse(), leaguesJSON) }
        let exp = expectation(description: #function)

        sut.searchLeagues(query: "Premier", for: "football") { result in
            if case .success(let leagues) = result { XCTAssertEqual(leagues.first?.leagueName, "Premier League") }
            else { XCTFail("Expected success") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }

    // MARK: - fetchTeams

    func test_fetchTeams_success_returnsTeams() {
        MockURLProtocol.requestHandler = { _ in (mockResponse(), teamsJSON) }
        let exp = expectation(description: #function)

        sut.fetchTeams(leagueId: 152, sport: "football") { result in
            if case .success(let teams) = result {
                XCTAssertEqual(teams.count, 1)
                XCTAssertEqual(teams.first?.teamName, "Arsenal")
            } else { XCTFail("Expected success") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }

    func test_fetchTeams_failure_returnsError() {
        MockURLProtocol.requestHandler = { _ in throw URLError(.timedOut) }
        let exp = expectation(description: #function)

        sut.fetchTeams(leagueId: 152, sport: "football") { result in
            if case .failure = result { /* ✅ */ } else { XCTFail("Expected failure") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }

    // MARK: - fetchTeamDetails

    func test_fetchTeamDetails_success_returnsTeam() {
        MockURLProtocol.requestHandler = { _ in (mockResponse(), teamsJSON) }
        let exp = expectation(description: #function)

        sut.fetchTeamDetails(teamId: 10, sport: "football") { result in
            if case .success(let team) = result { XCTAssertEqual(team.teamName, "Arsenal") }
            else { XCTFail("Expected success") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }

    func test_fetchTeamDetails_emptyResult_returnsNoDataError() {
        MockURLProtocol.requestHandler = { _ in (mockResponse(), emptyJSON) }
        let exp = expectation(description: #function)

        sut.fetchTeamDetails(teamId: 10, sport: "football") { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? NetworkError, .noData)
            } else { XCTFail("Expected noData error") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }

    // MARK: - fetchUpcomingEvents

    func test_fetchUpcomingEvents_success_returnsEvents() {
        MockURLProtocol.requestHandler = { _ in (mockResponse(), finishedEventJSON) }
        let exp = expectation(description: #function)

        sut.fetchUpcomingEvents(leagueId: 152, sport: "football") { result in
            if case .success(let events) = result { XCTAssertEqual(events.count, 1) }
            else { XCTFail("Expected success") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }

    // MARK: - fetchRecentEvents

    func test_fetchRecentEvents_finishedEvents_areReturned() {
        MockURLProtocol.requestHandler = { _ in (mockResponse(), finishedEventJSON) }
        let exp = expectation(description: #function)

        sut.fetchRecentEvents(leagueId: 152, sport: "football") { result in
            if case .success(let events) = result { XCTAssertEqual(events.count, 1) }
            else { XCTFail("Expected success") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }

    func test_fetchRecentEvents_unfinishedEvents_areFiltered() {
        MockURLProtocol.requestHandler = { _ in (mockResponse(), unfinishedEventJSON) }
        let exp = expectation(description: #function)

        sut.fetchRecentEvents(leagueId: 152, sport: "football") { result in
            if case .success(let events) = result { XCTAssertTrue(events.isEmpty) }
            else { XCTFail("Expected success with empty filtered result") }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }

    // MARK: - fetchLeagueDetails

    func test_fetchLeagueDetails_allThreeCallbacksComplete() {
        MockURLProtocol.requestHandler = { _ in (mockResponse(), emptyJSON) }
        let exp = expectation(description: #function)

        sut.fetchLeagueDetails(leagueId: 152, sport: "football") { teams, recent, upcoming in
            XCTAssertNotNil(teams)
            XCTAssertNotNil(recent)
            XCTAssertNotNil(upcoming)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
}
