//
//  FavoritesPresenterTests.swift
//  Sportify
//
//  Created by Mina_Wagdy on 06/06/2026.
//
//
//  FavoritesPresenterTests.swift
//  SportifyTests
//

import XCTest
@testable import Sportify

// MARK: - View Spy
final class FavoritesViewSpy: FavoritesViewProtocol {
    var isShowEmptyStateCalled = false
    var shownFavorites: [League]?
    var deletedRowIndex: Int?
    var navigatedLeague: League?
    var navigatedSport: Sport?
    var isShowNoInternetAlertCalled = false

    func showEmptyState() {
        isShowEmptyStateCalled = true
    }

    func showFavorites(_ leagues: [League]) {
        shownFavorites = leagues
    }

    func deleteRow(at index: Int) {
        deletedRowIndex = index
    }

    func navigateToLeagueDetails(with league: League, sport: Sport) {
        navigatedLeague = league
        navigatedSport = sport
    }

    func showNoInternetAlert() {
        isShowNoInternetAlertCalled = true
    }
}

// MARK: - Test Suite
final class FavoritesPresenterTests: XCTestCase {

    private var sut: FavoritesPresenter!
    private var viewSpy: FavoritesViewSpy!

    override func setUp() {
        super.setUp()
        viewSpy = FavoritesViewSpy()
        sut = FavoritesPresenter(view: viewSpy)
        
        // Ensure we start with a clean slate in CoreData before each test
        clearCoreDataFavorites()
    }

    override func tearDown() {
        // Clean up any data we injected during the tests so we don't pollute the simulator
        clearCoreDataFavorites()
        
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
    
    private func createDummyLeague(key: Int, name: String) -> League {
        return League(leagueKey: key, leagueName: name, leagueLogo: nil, sportName: "football")
    }

    // MARK: - Case 1: View Lifecycle & CoreData Fetching
    func test_viewWillAppear_whenCoreDataIsEmpty_showsEmptyState() {
        // Given (Database is empty due to setUp)
        
        // When
        sut.viewWillAppear()
        
        // Then
        XCTAssertTrue(viewSpy.isShowEmptyStateCalled, "Presenter should tell the view to show the empty state if no favorites exist.")
        XCTAssertNil(viewSpy.shownFavorites, "Presenter should not pass any leagues to the view.")
    }

    func test_viewWillAppear_whenCoreDataHasItems_showsFavorites() {
        // Given
        let dummyLeague = createDummyLeague(key: 101, name: "Champions League")
        CoreDataManager.shared.saveLeagueToFavorites(league: dummyLeague, sportName: "football")
        
        // When
        sut.viewWillAppear()
        
        // Then
        XCTAssertFalse(viewSpy.isShowEmptyStateCalled, "Empty state should not be triggered.")
        XCTAssertEqual(viewSpy.shownFavorites?.count, 1, "Presenter should fetch and pass exactly 1 league to the view.")
        XCTAssertEqual(viewSpy.shownFavorites?.first?.leagueName, "Champions League")
    }

    // MARK: - Case 2: User Deletion Actions
    func test_didDeleteLeague_removesFromCoreData_andUpdatesView() {
        // Given
        let league1 = createDummyLeague(key: 1, name: "League A")
        let league2 = createDummyLeague(key: 2, name: "League B")
        CoreDataManager.shared.saveLeagueToFavorites(league: league1, sportName: "football")
        CoreDataManager.shared.saveLeagueToFavorites(league: league2, sportName: "football")
        
        sut.viewWillAppear() // Populate the presenter's internal array
        
        // When
        sut.didDeleteLeague(at: 0) // Delete the first league ("League A")
        
        // Then
        XCTAssertEqual(viewSpy.deletedRowIndex, 0, "Presenter should tell the view to delete the row at the specified index.")
        
        let remainingInDB = CoreDataManager.shared.fetchFavoriteLeagues()
        XCTAssertEqual(remainingInDB.count, 1, "CoreData should only have 1 item left.")
        XCTAssertEqual(remainingInDB.first?.leagueName, "League B", "The correct league should remain in the database.")
    }

    func test_didDeleteLeague_whenLastItemRemoved_showsEmptyState() {
        // Given
        let league = createDummyLeague(key: 1, name: "Lone League")
        CoreDataManager.shared.saveLeagueToFavorites(league: league, sportName: "football")
        sut.viewWillAppear() // Populate the internal array with 1 item
        
        // When
        sut.didDeleteLeague(at: 0)
        
        // Then
        XCTAssertTrue(viewSpy.isShowEmptyStateCalled, "Presenter should trigger the empty state view when the last item is deleted.")
    }

    // MARK: - Case 3: Navigation
    func test_didSelectLeague_navigatesToDetails() {
        // Given
        let league = createDummyLeague(key: 55, name: "Test Navigation League")
        CoreDataManager.shared.saveLeagueToFavorites(league: league, sportName: "basketball")
        sut.viewWillAppear() // Populate internal array
        
        // When
        sut.didSelectLeague(at: 0)
        
        // Then
        // Note: Assuming ReachabilityManager.shared.isConnectedToInternet is true on the testing machine
        XCTAssertEqual(viewSpy.navigatedLeague?.leagueName, "Test Navigation League")
        XCTAssertEqual(viewSpy.navigatedSport?.sportName, "basketball")
        XCTAssertFalse(viewSpy.isShowNoInternetAlertCalled)
    }
}
