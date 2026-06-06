//
//  ModelsTests.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.
//


import XCTest
@testable import Sportify

final class ModelsTests: XCTestCase {

    // MARK: - Helpers

    private func decode<T: Decodable>(_ type: T.Type, from json: String) throws -> T {
        let data = json.data(using: .utf8)!
        return try JSONDecoder().decode(type, from: data)
    }

    // ---------------------------------------------------------------
    // MARK: - League
    // ---------------------------------------------------------------

    func test_league_decodesAllFields() throws {
        let json = """
        { "league_key": 152, "league_name": "Premier League", "league_logo": "https://logo.png", "sportName": "Football" }
        """
        let league = try decode(League.self, from: json)
        XCTAssertEqual(league.leagueKey, 152)
        XCTAssertEqual(league.leagueName, "Premier League")
        XCTAssertEqual(league.leagueLogo, "https://logo.png")
        XCTAssertEqual(league.sportName, "Football")
    }

    func test_league_decodesWithNilFields() throws {
        let json = "{}"
        let league = try decode(League.self, from: json)
        XCTAssertNil(league.leagueKey)
        XCTAssertNil(league.leagueName)
        XCTAssertNil(league.leagueLogo)
        XCTAssertNil(league.sportName)
    }

    func test_leaguesResponse_decodesResultArray() throws {
        let json = """
        { "result": [{ "league_key": 1, "league_name": "La Liga" }] }
        """
        let response = try decode(LeaguesResponse.self, from: json)
        XCTAssertEqual(response.result?.count, 1)
        XCTAssertEqual(response.result?.first?.leagueName, "La Liga")
    }

    func test_leaguesResponse_nilResult_decodesAsNil() throws {
        let json = "{}"
        let response = try decode(LeaguesResponse.self, from: json)
        XCTAssertNil(response.result)
    }

    func test_league_sportNameIsMutable() {
        var league = League(leagueKey: 1, leagueName: "Serie A", leagueLogo: nil, sportName: nil)
        league.sportName = "Football"
        XCTAssertEqual(league.sportName, "Football")
    }

    // ---------------------------------------------------------------
    // MARK: - Sport
    // ---------------------------------------------------------------

    func test_sport_decodesAllFields() throws {
        let json = """
        { "strSport": "Football", "strSportThumb": "https://thumb.png" }
        """
        let sport = try decode(Sport.self, from: json)
        XCTAssertEqual(sport.sportName, "Football")
        XCTAssertEqual(sport.sportThumb, "https://thumb.png")
    }

    func test_sport_decodesWithNilFields() throws {
        let json = "{}"
        let sport = try decode(Sport.self, from: json)
        XCTAssertNil(sport.sportName)
        XCTAssertNil(sport.sportThumb)
    }

    func test_sportsResponse_decodesResultArray() throws {
        let json = """
        { "result": [{ "strSport": "Basketball", "strSportThumb": "https://b.png" }] }
        """
        let response = try decode(SportsResponse.self, from: json)
        XCTAssertEqual(response.result?.count, 1)
        XCTAssertEqual(response.result?.first?.sportName, "Basketball")
    }

    func test_sportsResponse_nilResult_decodesAsNil() throws {
        let json = "{}"
        let response = try decode(SportsResponse.self, from: json)
        XCTAssertNil(response.result)
    }

    // ---------------------------------------------------------------
    // MARK: - Team & Player
    // ---------------------------------------------------------------

    func test_team_decodesAllFields() throws {
        let json = """
        {
          "team_key": 33,
          "team_name": "Arsenal",
          "team_logo": "https://arsenal.png",
          "team_country": "England",
          "team_founded": "1886",
          "venue_name": "Emirates Stadium",
          "players": []
        }
        """
        let team = try decode(Team.self, from: json)
        XCTAssertEqual(team.teamKey, 33)
        XCTAssertEqual(team.teamName, "Arsenal")
        XCTAssertEqual(team.teamLogo, "https://arsenal.png")
        XCTAssertEqual(team.teamCountry, "England")
        XCTAssertEqual(team.teamFounded, "1886")
        XCTAssertEqual(team.venueName, "Emirates Stadium")
        XCTAssertEqual(team.players?.count, 0)
    }

    func test_team_decodesWithNilFields() throws {
        let json = "{}"
        let team = try decode(Team.self, from: json)
        XCTAssertNil(team.teamKey)
        XCTAssertNil(team.teamName)
        XCTAssertNil(team.players)
    }

    func test_team_decodesPlayers() throws {
        let json = """
        {
          "team_key": 1,
          "players": [
            { "player_key": 10, "player_name": "Saka", "player_image": "https://saka.png", "player_number": "7", "player_type": "Attacker" }
          ]
        }
        """
        let team = try decode(Team.self, from: json)
        let player = team.players?.first
        XCTAssertEqual(team.players?.count, 1)
        XCTAssertEqual(player?.playerKey, 10)
        XCTAssertEqual(player?.playerName, "Saka")
        XCTAssertEqual(player?.playerImage, "https://saka.png")
        XCTAssertEqual(player?.playerNumber, "7")
        XCTAssertEqual(player?.playerPosition, "Attacker")
    }

    func test_player_decodesWithNilFields() throws {
        let json = "{}"
        let player = try decode(Player.self, from: json)
        XCTAssertNil(player.playerKey)
        XCTAssertNil(player.playerName)
        XCTAssertNil(player.playerPosition)
    }

    func test_teamsResponse_decodesResultArray() throws {
        let json = """
        { "result": [{ "team_key": 1, "team_name": "Chelsea" }] }
        """
        let response = try decode(TeamsResponse.self, from: json)
        XCTAssertEqual(response.result?.count, 1)
        XCTAssertEqual(response.result?.first?.teamName, "Chelsea")
    }

    func test_teamsResponse_nilResult_decodesAsNil() throws {
        let json = "{}"
        let response = try decode(TeamsResponse.self, from: json)
        XCTAssertNil(response.result)
    }

    // ---------------------------------------------------------------
    // MARK: - Event
    // ---------------------------------------------------------------

    func test_event_decodesAllFields() throws {
        let json = """
        {
          "event_key": 999,
          "event_date": "2026-06-01",
          "event_time": "20:00",
          "event_home_team": "Arsenal",
          "home_team_key": 33,
          "home_team_logo": "https://arsenal.png",
          "event_away_team": "Chelsea",
          "away_team_key": 44,
          "away_team_logo": "https://chelsea.png",
          "event_final_result": "2 - 1",
          "event_halftime_result": "1 - 0",
          "event_ft_result": "2 - 1",
          "event_status": "Finished"
        }
        """
        let event = try decode(Event.self, from: json)
        XCTAssertEqual(event.eventKey, 999)
        XCTAssertEqual(event.eventDate, "2026-06-01")
        XCTAssertEqual(event.eventTime, "20:00")
        XCTAssertEqual(event.eventHomeTeam, "Arsenal")
        XCTAssertEqual(event.homeTeamKey, 33)
        XCTAssertEqual(event.homeTeamLogo, "https://arsenal.png")
        XCTAssertEqual(event.eventAwayTeam, "Chelsea")
        XCTAssertEqual(event.awayTeamKey, 44)
        XCTAssertEqual(event.awayTeamLogo, "https://chelsea.png")
        XCTAssertEqual(event.eventFinalResult, "2 - 1")
        XCTAssertEqual(event.eventHalftimeResult, "1 - 0")
        XCTAssertEqual(event.eventFtResult, "2 - 1")
        XCTAssertEqual(event.eventStatus, "Finished")
    }

    func test_event_decodesWithNilFields() throws {
        let json = "{}"
        let event = try decode(Event.self, from: json)
        XCTAssertNil(event.eventKey)
        XCTAssertNil(event.eventFinalResult)
        XCTAssertNil(event.eventStatus)
    }

    func test_eventsResponse_decodesSuccessAndResult() throws {
        let json = """
        { "success": 1, "result": [{ "event_key": 1, "event_home_team": "Arsenal" }] }
        """
        let response = try decode(EventsResponse.self, from: json)
        XCTAssertEqual(response.success, 1)
        XCTAssertEqual(response.result?.count, 1)
        XCTAssertEqual(response.result?.first?.eventHomeTeam, "Arsenal")
    }

    func test_eventsResponse_nilResult_decodesAsNil() throws {
        let json = "{}"
        let response = try decode(EventsResponse.self, from: json)
        XCTAssertNil(response.result)
    }

    // ---------------------------------------------------------------
    // MARK: - FavoriteLeague
    // ---------------------------------------------------------------

    func test_favoriteLeague_initStoresAllFields() {
        let fav = FavoriteLeague(leagueKey: 10, leagueName: "Ligue 1", leagueLogo: "https://ligue1.png", sportName: "Football")
        XCTAssertEqual(fav.leagueKey, 10)
        XCTAssertEqual(fav.leagueName, "Ligue 1")
        XCTAssertEqual(fav.leagueLogo, "https://ligue1.png")
        XCTAssertEqual(fav.sportName, "Football")
    }

    func test_favoriteLeague_twoInstancesWithSameValues_areEqual() {
        let a = FavoriteLeague(leagueKey: 5, leagueName: "MLS", leagueLogo: "https://mls.png", sportName: "Football")
        let b = FavoriteLeague(leagueKey: 5, leagueName: "MLS", leagueLogo: "https://mls.png", sportName: "Football")
        XCTAssertEqual(a.leagueKey, b.leagueKey)
        XCTAssertEqual(a.leagueName, b.leagueName)
        XCTAssertEqual(a.sportName, b.sportName)
    }
}
