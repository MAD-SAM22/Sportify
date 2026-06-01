//
//  LeagueDetailsProtocols.swift
//  Sportify
//
//  Created by Mina_Wagdy on 22/05/2026.
//
import Foundation

// MARK: - View Protocol
protocol LeagueDetailsViewProtocol: AnyObject {
    func reloadData()
    func updateFavoriteIcon(isFavorite: Bool)
    func navigateToTeamDetails(with team: Team)
    func showUnfavoriteConfirmationAlert()
}

// MARK: - Presenter Protocol
protocol LeagueDetailsPresenterProtocol {
    var selectedLeague: League? { get set }
    var selectedSport: Sport? { get set } 
    func viewDidLoad()
    func viewWillAppear()
    func didSelectTab(index: Int)
    func didSelectTeam(at index: Int)
    
    // New methods for Favorite logic
    func didTapFavorite()
    func isFavorite() -> Bool
    func confirmUnfavorite()
    
    // Data source methods
    func getTeamsCount() -> Int
    func getGamesCount() -> Int
    
    // State helpers
    func getSelectedTabIndex() -> Int
    func getCurrentMatchState(for index: Int) -> MatchState
    
    func getTeam(at index: Int) -> Team?
    func getGame(at index: Int) -> Event?
    
    var isLoading: Bool { get }
}
