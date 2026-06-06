//
//  LeagueDetailsPresenterTests.swift
//  Sportify
//
//  Created by Mina_Wagdy on 06/06/2026.
//
//  LeagueDetailsPresenterTests.swift
//  SportifyTests
//

import XCTest
@testable import Sportify

// MARK: - View Spy
final class LeagueDetailsViewSpy: LeagueDetailsViewProtocol {
    var reloadDataCallCount = 0
    var isFavoriteIconState: Bool?
    var navigatedTeam: Team?
    var isShowUnfavoriteConfirmationAlertCalled = false
    
    var expectation: XCTestExpectation?

    func reloadData() {
        reloadDataCallCount += 1
        expectation?.fulfill()
    }

    func updateFavoriteIcon(isFavorite: Bool) {
        isFavoriteIconState = isFavorite
    }

    func navigateToTeamDetails(with team: Team) {
        navigatedTeam = team
    }

    func showUnfavoriteConfirmationAlert() {
        isShowUnfavoriteConfirmationAlertCalled = true
    }
}

// MARK: - Test Suite
final class LeagueDetailsPresenterTests: XCTestCase {

    private var sut: LeagueDetailsPresenter!
    private var viewSpy: LeagueDetailsViewSpy!

    override func setUp() {
        super.setUp()
        viewSpy = LeagueDetailsViewSpy()
        sut = LeagueDetailsPresenter(view: viewSpy)
        
        // Setup initial dummy data for the Presenter to use
        sut.selectedLeague = League(leagueKey: 999, leagueName: "Test League", leagueLogo: nil, sportName: "football")
        sut.selectedSport = Sport(sportName: "football", sportThumb: nil)
        
        URLProtocol.registerClass(MockURLProtocol.self)
        clearCoreDataFavorites()
    }

    override func tearDown() {
        clearCoreDataFavorites()
        URLProtocol.unregisterClass(MockURLProtocol.self)
        MockURLProtocol.requestHandler = nil
        sut = nil
        viewSpy = nil
        super.tearDown()
    }
    
    // MARK: - Helpers
    private func clearCoreDataFavorites() {
        let existingLeagues = CoreDataManager.shared.fetchFavoriteLeagues()
        for league in existingLeagues {
            if let key = league.leagueKey {
                CoreDataManager.shared.deleteLeagueFromFavorites(leagueKey: key)
            }
        }
    }
    
    // MARK: - Case 1: Fetching Data
    func test_viewDidLoad_fetchesData_andReloadsView() {
        // Given
        let exp = expectation(description: "Wait for initial and network reloadData calls")
        exp.expectedFulfillmentCount = 2 // 1 for loading state, 1 for network completion
        viewSpy.expectation = exp
        
        // Mock a successful JSON response for the network calls
        let mockJSON = """
        { "success": 1, "result": [] }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://mock.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockJSON)
        }
        
        // When
        sut.viewDidLoad()
        
        // Then
        wait(for: [exp], timeout: 2.0)
        XCTAssertFalse(sut.isLoading, "Loading state should be false after network fetch completes.")
        XCTAssertEqual(viewSpy.reloadDataCallCount, 2, "View should reload twice during fetch cycle.")
    }

    // MARK: - Case 2: Favorites Logic
    func test_viewWillAppear_whenNotFavorited_updatesIconFalse() {
        // When
        sut.viewWillAppear()
        
        // Then
        XCTAssertEqual(viewSpy.isFavoriteIconState, false)
        XCTAssertFalse(sut.isFavorite())
    }

    func test_viewWillAppear_whenFavorited_updatesIconTrue() {
        // Given
        CoreDataManager.shared.saveLeagueToFavorites(league: sut.selectedLeague!, sportName: "football")
        
        // When
        sut.viewWillAppear()
        
        // Then
        XCTAssertEqual(viewSpy.isFavoriteIconState, true)
        XCTAssertTrue(sut.isFavorite())
    }

    func test_didTapFavorite_whenNotFavorited_savesToCoreData() {
        // Given
        sut.viewWillAppear() // Initialize false state
        
        // When
        sut.didTapFavorite()
        
        // Then
        XCTAssertTrue(sut.isFavorite(), "Presenter state should update to favorited.")
        XCTAssertEqual(viewSpy.isFavoriteIconState, true, "View should be instructed to show filled heart.")
        
        let saved = CoreDataManager.shared.fetchFavoriteLeagues()
        XCTAssertEqual(saved.count, 1, "League should be saved to database.")
    }

    func test_didTapFavorite_whenAlreadyFavorited_showsAlert() {
        // Given
        CoreDataManager.shared.saveLeagueToFavorites(league: sut.selectedLeague!, sportName: "football")
        sut.viewWillAppear() // Initialize true state
        
        // When
        sut.didTapFavorite()
        
        // Then
        XCTAssertTrue(viewSpy.isShowUnfavoriteConfirmationAlertCalled, "Should ask view to show confirmation alert instead of deleting immediately.")
    }

    func test_confirmUnfavorite_deletesFromCoreData() {
        // Given
        CoreDataManager.shared.saveLeagueToFavorites(league: sut.selectedLeague!, sportName: "football")
        sut.viewWillAppear() // Initialize true state
        
        // When
        sut.confirmUnfavorite()
        
        // Then
        XCTAssertFalse(sut.isFavorite(), "Presenter state should revert to not favorited.")
        XCTAssertEqual(viewSpy.isFavoriteIconState, false, "View should be instructed to show empty heart.")
        
        let saved = CoreDataManager.shared.fetchFavoriteLeagues()
        XCTAssertTrue(saved.isEmpty, "League should be removed from database.")
    }

    // MARK: - Case 3: Tab Control Logic
    func test_didSelectTab_updatesIndex_andReloadsData() {
        // Given
        XCTAssertEqual(sut.getSelectedTabIndex(), 0, "Default tab should be 0 (Recent)")
        viewSpy.reloadDataCallCount = 0 // Reset spy counter
        
        // When
        sut.didSelectTab(index: 1)
        
        // Then
        XCTAssertEqual(sut.getSelectedTabIndex(), 1, "Tab index should update to 1 (Upcoming)")
        XCTAssertEqual(viewSpy.reloadDataCallCount, 1, "View should reload to show new tab data")
    }

    func test_didSelectTab_sameIndex_doesNotReload() {
        // Given
        sut.didSelectTab(index: 0) // Select the already selected tab
        
        // Then
        XCTAssertEqual(viewSpy.reloadDataCallCount, 0, "View should not reload if the same tab is tapped")
    }

    // MARK: - Case 4: Match State Engine
    func test_getCurrentMatchState_returnsRecentWithScoreForTab0() {
        // Given
        let exp = expectation(description: "Wait for fetch")
        exp.expectedFulfillmentCount = 2
        viewSpy.expectation = exp
        
        let mockJSON = """
        { "success": 1, "result": [{ "event_key": 1, "event_final_result": "3 - 1" }] }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { _ in (HTTPURLResponse(url: URL(string: "https://mock.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!, mockJSON) }
        
        sut.viewDidLoad()
        wait(for: [exp], timeout: 2.0)
        
        // When
        sut.didSelectTab(index: 0)
        let state = sut.getCurrentMatchState(for: 0)
        
        // Then
        if case .recent(let score) = state {
            XCTAssertEqual(score, "3 - 1")
        } else {
            XCTFail("Expected .recent state for tab 0")
        }
    }

    func test_getCurrentMatchState_returnsUpcomingForTab1() {
        // When
        sut.didSelectTab(index: 1)
        let state = sut.getCurrentMatchState(for: 0) // Index doesn't matter for this check
        
        // Then
        if case .upcoming = state {
            // Success
        } else {
            XCTFail("Expected .upcoming state for tab 1")
        }
    }

    // MARK: - Case 5: Team Selection Bounds Checking
    func test_didSelectTeam_outOfBounds_doesNothing() {
        // When
        sut.didSelectTeam(at: 99) // Array is empty right now
        
        // Then
        XCTAssertNil(viewSpy.navigatedTeam, "Should not navigate if index is out of bounds")
    }
}
