//
//  MockSportsView.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.
//


import XCTest
@testable import Sportify

// MARK: - Mock View

final class MockSportsView: SportsViewProtocol {
    func showError(_ message: String) {
        print("error msg is : \(message)")
    }
    
    var showSportsCalled = false
    var navigateToLeaguesCalled = false
    var showNoInternetAlertCalled = false
    var receivedSports: [Sport] = []
    var navigatedSport: Sport?

    func showSports(_ sports: [Sport]) {
        showSportsCalled = true
        receivedSports = sports
    }
    func navigateToLeagues(with sport: Sport) {
        navigateToLeaguesCalled = true
        navigatedSport = sport
    }
    func showNoInternetAlert() {
        showNoInternetAlertCalled = true
    }
}

// MARK: - Mock ReachabilityManager

final class MockReachabilityManager: ReachabilityManager {
    var stubbedIsConnected = true
    override var isConnectedToInternet: Bool { stubbedIsConnected }
}

// MARK: - SportsPresenterTests

final class SportsPresenterTests: XCTestCase {

    var view: MockSportsView!
    var reachability: MockReachabilityManager!
    var sut: SportsPresenter!

    override func setUp() {
        super.setUp()
        view = MockSportsView()
        reachability = MockReachabilityManager()
        sut = SportsPresenter(view: view, reachability: reachability)
    }

    override func tearDown() {
        sut = nil; view = nil; reachability = nil
        super.tearDown()
    }

    // MARK: - viewDidLoad

    func test_viewDidLoad_callsShowSports() {
        sut.viewDidLoad()
        XCTAssertTrue(view.showSportsCalled)
    }

    func test_viewDidLoad_loadsFourSports() {
        sut.viewDidLoad()
        XCTAssertEqual(view.receivedSports.count, 4)
    }

    func test_viewDidLoad_sportsHaveCorrectThumbs() {
        sut.viewDidLoad()
        let thumbs = view.receivedSports.compactMap { $0.sportThumb }
        XCTAssertTrue(thumbs.contains("basketball_img"))
        XCTAssertTrue(thumbs.contains("soccer_img"))
        XCTAssertTrue(thumbs.contains("tennis_img"))
        XCTAssertTrue(thumbs.contains("cricket_img"))
    }

    func test_viewDidLoad_allSportsHaveNonNilNames() {
        sut.viewDidLoad()
        XCTAssertFalse(view.receivedSports.contains { $0.sportName == nil })
    }

    // MARK: - didSelectSport

    func test_didSelectSport_whenOnline_navigatesToLeagues() {
        reachability.stubbedIsConnected = true
        sut.viewDidLoad()

        sut.didSelectSport(at: 0)

        XCTAssertTrue(view.navigateToLeaguesCalled)
        XCTAssertFalse(view.showNoInternetAlertCalled)
    }

    func test_didSelectSport_whenOnline_passesCorrectSport() {
        reachability.stubbedIsConnected = true
        sut.viewDidLoad()

        sut.didSelectSport(at: 1)

        XCTAssertEqual(view.navigatedSport?.sportThumb, "soccer_img")
    }

    func test_didSelectSport_whenOffline_showsNoInternetAlert() {
        reachability.stubbedIsConnected = false
        sut.viewDidLoad()

        sut.didSelectSport(at: 0)

        XCTAssertTrue(view.showNoInternetAlertCalled)
        XCTAssertFalse(view.navigateToLeaguesCalled)
    }

    func test_didSelectSport_eachIndex_passesCorrectSport() {
        reachability.stubbedIsConnected = true
        sut.viewDidLoad()

        let expectedThumbs = ["basketball_img", "soccer_img", "tennis_img", "cricket_img"]
        for (index, expectedThumb) in expectedThumbs.enumerated() {
            view.navigatedSport = nil
            sut.didSelectSport(at: index)
            XCTAssertEqual(view.navigatedSport?.sportThumb, expectedThumb)
        }
    }
}
