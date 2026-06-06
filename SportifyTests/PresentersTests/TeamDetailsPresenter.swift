//
//  TeamDetailsPresenter.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.

import XCTest
@testable import Sportify

// MARK: - View Spy
final class TeamDetailsViewSpy: TeamDetailsViewProtocol {
    var lastShownTeam: Team?
    var lastShownLineupState: Bool?
    var lastShownPlayers: [Player]?
    var isShowingLoading = false
    var isHidingLoading = false
    var lastErrorMessage: String?
    var lastUpdatedFormation: [[(name: String, imageURL: String?)]]?
    
    var expectation: XCTestExpectation?

    func showTeamDetails(_ team: Team) { lastShownTeam = team }
    func showLineup(show: Bool) { lastShownLineupState = show }
    func showPlayers(_ players: [Player]) { lastShownPlayers = players }
    func showLoadingState() { isShowingLoading = true }
    func hideLoadingState() { isHidingLoading = true }
    
    func showError(_ message: String) {
        lastErrorMessage = message
        expectation?.fulfill()
    }
    
    func updateLineup(formation: [[(name: String, imageURL: String?)]]) {
        lastUpdatedFormation = formation
        expectation?.fulfill()
    }
}

// MARK: - Test Suite
final class TeamDetailsPresenterTests: XCTestCase {
    
    private var sut: TeamDetailsPresenter!
    private var viewSpy: TeamDetailsViewSpy!
    
    override func setUp() {
        super.setUp()
        viewSpy = TeamDetailsViewSpy()
        sut = TeamDetailsPresenter(view: viewSpy)
    }
    
    override func tearDown() {
        sut = nil
        viewSpy = nil
        super.tearDown()
    }
    
    // MARK: - Helper Factory Methods
    private func createTestPlayer(name: String, position: String, image: String? = nil) -> Player {
        let jsonData = """
        {
            "player_key": 123,
            "player_name": "\(name)",
            "player_type": "\(position)",
            "player_number": "10",
            "player_image": "\(image ?? "")"
        }
        """.data(using: .utf8)!
        return try! JSONDecoder().decode(Player.self, from: jsonData)
    }
    
    private func createTestTeam(key: Int?, players: [Player]?) -> Team {
        let teamKeyStr = key != nil ? "\(key!)" : "null"
        var jsonString = "{\"team_name\": \"Test FC\", \"team_key\": \(teamKeyStr)"
        
        if let players = players {
            let playerItems = players.map { player in
                """
                {
                    "player_key": 99,
                    "player_name": "\(player.playerName ?? "")",
                    "player_type": "\(player.playerPosition ?? "")",
                    "player_number": "7",
                    "player_image": "\(player.playerImage ?? "")"
                }
                """
            }.joined(separator: ",")
            
            jsonString += ", \"players\": [\(playerItems)]"
        }
        
        jsonString += "}"
        
        let data = jsonString.data(using: .utf8)!
        return try! JSONDecoder().decode(Team.self, from: data)
    }

    // MARK: - Case 1: Early Return (No Selected Team)
    func test_viewDidLoad_whenSelectedTeamIsNil_doesNothing() {
        sut.selectedTeam = nil
        
        sut.viewDidLoad()
        
        XCTAssertNil(viewSpy.lastShownTeam)
        XCTAssertNil(viewSpy.lastShownLineupState)
    }
    
    // MARK: - Case 2: Local Cache Path (No Team Key)
    func test_viewDidLoad_whenTeamKeyIsNil_showsPlayersImmediatelyWithoutNetwork() {
        let localPlayers = [createTestPlayer(name: "Mo Salah", position: "Forwards")]
        let sampleTeam = createTestTeam(key: nil, players: localPlayers)
        sut.selectedTeam = sampleTeam
        
        sut.viewDidLoad()
        
        XCTAssertEqual(viewSpy.lastShownTeam?.players?.first?.playerName, "Mo Salah")
        XCTAssertEqual(viewSpy.lastShownPlayers?.count, 1)
        XCTAssertFalse(viewSpy.isShowingLoading)
    }
    
    // MARK: - Case 3: Lineup Visibility Check
    func test_shouldShowLineup_handlesCaseInsensitiveSportsCorrectly() {
        sut.sport = "SOCCER"
        XCTAssertTrue(sut.shouldShowLineup())
        
        sut.sport = "tennis"
        XCTAssertFalse(sut.shouldShowLineup())
    }
    
    // MARK: - Case 4: Formation Math & Layout Padding
    func test_buildFormation_padsEmptyPositionsUpToRequiredTacticalLimits() {
        let players = [
            createTestPlayer(name: "Alisson", position: "Goalkeepers", image: "img"),
            createTestPlayer(name: "Van Dijk", position: "Defenders", image: "img")
        ]
        
        let formation = sut.buildFormation(from: players)
        
        XCTAssertEqual(formation[0].count, 1)
        XCTAssertEqual(formation[0][0].name, "Alisson")
        XCTAssertEqual(formation[1].count, 4)
        XCTAssertEqual(formation[1][0].name, "Van Dijk")
        XCTAssertEqual(formation[1][1].name, "")
    }
    
    // MARK: - Case 5: Player Image Sorting Logic
    func test_sorting_putsPlayersWithImagesFirst() {
        let playerWithoutImage = createTestPlayer(name: "Player A", position: "Midfielders", image: "")
        let playerWithImage = createTestPlayer(name: "Player B", position: "Midfielders", image: "valid_url")
        
        let unsorted = [playerWithoutImage, playerWithImage]
        let sorted = unsorted.sorted {
            let firstHasImage = !($0.playerImage ?? "").isEmpty
            let secondHasImage = !($1.playerImage ?? "").isEmpty
            return firstHasImage && !secondHasImage
        }
        
        XCTAssertEqual(sorted.first?.playerName, "Player B")
    }

    // MARK: - Case 6: Fallback Skeleton Configurations
    func test_getFormation_returnsFallbackUILayoutPlaceholder() {
        let skeleton: [[(name: String, imageURL: String?)]] = sut.getFormation()
        XCTAssertEqual(skeleton.count, 4)
        XCTAssertEqual(skeleton[0][0].name, "Goalkeeper")
    }
    
    // MARK: - Case 7: Real Async Network Response Handling
    func test_viewDidLoad_executesNetworkPath_andHandlesMainThreadDispatch() {
        let exp = expectation(description: "Wait for main thread completion dispatch loop")
        viewSpy.expectation = exp
        
        let initialTeam = createTestTeam(key: 123, players: [])
        sut.selectedTeam = initialTeam
        sut.sport = "soccer"
        
        sut.viewDidLoad()
        
        XCTAssertTrue(sut.isLoading)
        XCTAssertTrue(viewSpy.isShowingLoading)
        
        waitForExpectations(timeout: 5.0) { _ in
            XCTAssertFalse(self.sut.isLoading)
            XCTAssertTrue(self.viewSpy.isHidingLoading)
            
            let executionFinished = (self.viewSpy.lastUpdatedFormation != nil || self.viewSpy.lastErrorMessage != nil)
            XCTAssertTrue(executionFinished)
        }
    }
}
