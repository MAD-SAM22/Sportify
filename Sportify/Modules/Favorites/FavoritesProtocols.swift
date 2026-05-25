//
//  FavoritesProtocols.swift
//  Sportify
//
//  Created by Osama Hosam on 23/05/2026.
//

protocol FavoritesViewProtocol: AnyObject {
    func showEmptyState()
    func showFavorites(_ leagues: [League])
    func deleteRow(at index: Int)
    func navigateToLeagueDetails(with league: League , sport:Sport)
}

protocol FavoritesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectLeague(at index: Int)
    func didDeleteLeague(at index: Int)
    
}
