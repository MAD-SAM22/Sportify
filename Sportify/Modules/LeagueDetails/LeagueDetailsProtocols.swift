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
    // New method for the View to update the icon UI
    func updateFavoriteIcon(isFavorite: Bool)
}

// MARK: - Presenter Protocol
protocol LeagueDetailsPresenterProtocol {
    func viewDidLoad()
    func didSelectTab(index: Int)
    
    // New methods for Favorite logic
    func didTapFavorite()
    func isFavorite() -> Bool
    
    // Data source methods
    func getTeamsCount() -> Int
    func getGamesCount() -> Int
    
    // State helpers
    func getSelectedTabIndex() -> Int
    func getCurrentMatchState() -> MatchState
}
