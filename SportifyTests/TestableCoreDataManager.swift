//
//  TestableCoreDataManager.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.
//


import XCTest
import CoreData
@testable import Sportify

final class CoreDataManagerTests: XCTestCase {

    var sut: CoreDataManager!

    override func setUp() {
        super.setUp()
        let container = NSPersistentContainer(name: "Sportify")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, _ in }
        sut = CoreDataManager(context: container.viewContext)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Save

    func test_save_persistsAllFields() {
        sut.saveLeagueToFavorites(league: league(key: 1, name: "La Liga", logo: "logo.png"), sportName: "Football")

        let result = sut.fetchFavoriteLeagues().first
        XCTAssertEqual(result?.leagueKey, 1)
        XCTAssertEqual(result?.leagueName, "La Liga")
        XCTAssertEqual(result?.leagueLogo, "logo.png")
        XCTAssertEqual(result?.sportName, "Football")
    }

    func test_save_nilKey_doesNotSave() {
        sut.saveLeagueToFavorites(league: League(leagueKey: nil, leagueName: "X", leagueLogo: nil, sportName: nil), sportName: "Football")
        XCTAssertTrue(sut.fetchFavoriteLeagues().isEmpty)
    }

    func test_save_duplicate_savesOnlyOnce() {
        sut.saveLeagueToFavorites(league: league(key: 1), sportName: "Football")
        sut.saveLeagueToFavorites(league: league(key: 1), sportName: "Football")
        XCTAssertEqual(sut.fetchFavoriteLeagues().count, 1)
    }

    // MARK: - Fetch

    func test_fetch_emptyStore_returnsEmptyArray() {
        XCTAssertTrue(sut.fetchFavoriteLeagues().isEmpty)
    }

    func test_fetch_returnsAllSavedLeagues() {
        sut.saveLeagueToFavorites(league: league(key: 1), sportName: "Football")
        sut.saveLeagueToFavorites(league: league(key: 2), sportName: "Football")
        sut.saveLeagueToFavorites(league: league(key: 3), sportName: "Football")
        XCTAssertEqual(sut.fetchFavoriteLeagues().count, 3)
    }

    // MARK: - Delete

    func test_delete_removesCorrectLeague() {
        sut.saveLeagueToFavorites(league: league(key: 1, name: "Serie A"), sportName: "Football")
        sut.saveLeagueToFavorites(league: league(key: 2, name: "Bundesliga"), sportName: "Football")

        sut.deleteLeagueFromFavorites(leagueKey: 1)

        let remaining = sut.fetchFavoriteLeagues()
        XCTAssertEqual(remaining.count, 1)
        XCTAssertEqual(remaining.first?.leagueName, "Bundesliga")
    }

    func test_delete_nonExistentKey_doesNothing() {
        sut.saveLeagueToFavorites(league: league(key: 1), sportName: "Football")
        sut.deleteLeagueFromFavorites(leagueKey: 999)
        XCTAssertEqual(sut.fetchFavoriteLeagues().count, 1)
    }

    func test_delete_lastRecord_storeIsEmpty() {
        sut.saveLeagueToFavorites(league: league(key: 1), sportName: "Football")
        sut.deleteLeagueFromFavorites(leagueKey: 1)
        XCTAssertTrue(sut.fetchFavoriteLeagues().isEmpty)
    }

    // MARK: - isFavorite

    func test_isFavorite_falseWhenNotSaved() {
        XCTAssertFalse(sut.isFavorite(leagueKey: 1))
    }

    func test_isFavorite_trueAfterSave() {
        sut.saveLeagueToFavorites(league: league(key: 1), sportName: "Football")
        XCTAssertTrue(sut.isFavorite(leagueKey: 1))
    }

    func test_isFavorite_falseAfterDelete() {
        sut.saveLeagueToFavorites(league: league(key: 1), sportName: "Football")
        sut.deleteLeagueFromFavorites(leagueKey: 1)
        XCTAssertFalse(sut.isFavorite(leagueKey: 1))
    }

    // MARK: - Helper

    private func league(key: Int, name: String = "Premier League", logo: String? = nil) -> League {
        League(leagueKey: key, leagueName: name, leagueLogo: logo, sportName: nil)
    }
}
