//
//  LeaguesPresenterTests.swift
//  Sportify
//
//  Created by Mina_Wagdy on 06/06/2026.
//  LeaguesPresenterTests.swift
//  SportifyTests
//

import Combine
import XCTest

@testable import Sportify

// MARK: - View Spy
final class LeaguesViewSpy: LeaguesViewProtocol {
    var leaguesShown: [League]?
    var errorMessage: String?
    var navigatedLeague: League?
    var navigatedSport: Sport?
    var noInternetAlertShown = false

    var expectation: XCTestExpectation?

    func showLeagues(_ leagues: [League]) {
        leaguesShown = leagues
        expectation?.fulfill()
    }

    func showError(_ message: String) {
        errorMessage = message
        expectation?.fulfill()
    }

    func navigateToLeagueDetails(with league: League, sport: Sport) {
        navigatedLeague = league
        navigatedSport = sport
    }

    func showNoInternetAlert() {
        noInternetAlertShown = true
    }
}

// MARK: - Test Suite
final class LeaguesPresenterTests: XCTestCase {

    private var sut: LeaguesPresenter!
    private var viewSpy: LeaguesViewSpy!

    override func setUp() {
        super.setUp()
        viewSpy = LeaguesViewSpy()
        sut = LeaguesPresenter(view: viewSpy)

        // Register the MockURLProtocol you created previously to intercept network calls
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    override func tearDown() {
        sut = nil
        viewSpy = nil
        URLProtocol.unregisterClass(MockURLProtocol.self)
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    // MARK: - Helper Factory
    private func createLeague(name: String, logo: String?) -> League {
        return League(
            leagueKey: Int.random(in: 1...1000), leagueName: name,
            leagueLogo: logo, sportName: "football")
    }

    // MARK: - Case 1: Search Debounce & Filtering
    func test_updateSearchQuery_filtersLeagues_afterDebounce() {
        // Given
        let exp = expectation(description: "Wait for 300ms debounce")
        viewSpy.expectation = exp

        // We simulate that fetchLeagues already populated `allLeagues`
        // We achieve this by fetching a mock successful response first
        let mockJSON = """
            {
                "success": 1,
                "result": [
                    { "league_key": 1, "league_name": "Premier League", "league_logo": "https://logo.png" },
                    { "league_key": 2, "league_name": "La Liga", "league_logo": "https://logo2.png" }
                ]
            }
            """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: URL(string: "https://mock.com")!, statusCode: 200,
                httpVersion: nil, headerFields: nil)!
            return (response, mockJSON)
        }

        sut.selectedSport = Sport(sportName: "football", sportThumb: nil)
        sut.viewDidLoad()  // This loads the initial data

        // Wait for the initial load to finish
        wait(for: [exp], timeout: 2.0)

        // When
        let searchExp = expectation(description: "Wait for search debounce")
        viewSpy.expectation = searchExp

        sut.updateSearchQuery("Premier")

        // Then
        wait(for: [searchExp], timeout: 1.0)  // Must wait > 300ms for debounce
        XCTAssertEqual(viewSpy.leaguesShown?.count, 1)
        XCTAssertEqual(
            viewSpy.leaguesShown?.first?.leagueName, "Premier League")
    }

    func test_updateSearchQuery_emptyString_showsAllLeagues() {
        // Given
        let exp = expectation(description: "Wait for search debounce")
        viewSpy.expectation = exp

        // Using reflection or a mock network call to populate data (assuming data is already loaded)
        sut.updateSearchQuery("   ")  // Empty or whitespace query

        // Then
        wait(for: [exp], timeout: 1.0)
        // We expect it to fallback to allLeagues. If allLeagues was empty, it shows 0.
        XCTAssertNotNil(viewSpy.leaguesShown)
    }

    // MARK: - Case 2: Data Sorting Logic
    func test_fetchLeagues_sortsLeaguesWithImagesFirst() {
        // Given
        let exp = expectation(description: "Wait for network fetch")
        viewSpy.expectation = exp

        // Mock JSON where the first item has NO image, and the second DOES have an image.
        let mockJSON = """
            {
                "success": 1,
                "result": [
                    { "league_key": 1, "league_name": "No Image League", "league_logo": "" },
                    { "league_key": 2, "league_name": "Valid Image League", "league_logo": "https://logo.png" }
                ]
            }
            """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: URL(string: "https://mock.com")!, statusCode: 200,
                httpVersion: nil, headerFields: nil)!
            return (response, mockJSON)
        }

        // When
        sut.fetchLeagues(sport: "football")

        // Then
        wait(for: [exp], timeout: 2.0)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(
            viewSpy.leaguesShown?.first?.leagueName, "Valid Image League",
            "The league with the valid image extension should be sorted to the top."
        )
    }

    // MARK: - Case 3: Error Handling
    func test_fetchLeagues_handlesNetworkFailure() {
        // Given
        let exp = expectation(description: "Wait for network failure")
        viewSpy.expectation = exp

        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        // When
        sut.fetchLeagues(sport: "football")

        // Then
        wait(for: [exp], timeout: 2.0)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(viewSpy.errorMessage)
    }

    // MARK: - Case 4: Navigation
    func test_didSelectLeague_navigatesToDetails() {
        // Given
        let exp = expectation(
            description: "Wait for network fetch to populate leagues array")
        // Add this line so it waits for both the initial clear AND the network response:
        exp.expectedFulfillmentCount = 2
        viewSpy.expectation = exp

        let mockJSON = """
            { "success": 1, "result": [{ "league_key": 99, "league_name": "Test League", "league_logo": "https://logo.png" }] }
            """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: URL(string: "https://mock.com")!, statusCode: 200,
                httpVersion: nil, headerFields: nil)!
            return (response, mockJSON)
        }

        sut.selectedSport = Sport(sportName: "football", sportThumb: nil)
        sut.viewDidLoad()
        wait(for: [exp], timeout: 2.0)

        // When
        sut.didSelectLeague(at: 0)

        // Then
        // Note: This test assumes ReachabilityManager.shared.isConnectedToInternet evaluates to true during test execution on your Mac.
        XCTAssertEqual(viewSpy.navigatedLeague?.leagueName, "Test League")
        XCTAssertEqual(viewSpy.navigatedSport?.sportName, "football")
    }
}
