//
//  LeagueDetailsPresenter.swift
//  Sportify
//
//  Created by Mina_Wagdy on 22/05/2026.
//
import Foundation

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    
    weak var view: LeagueDetailsViewProtocol?
    
    var selectedLeague: League?

    private var currentTabIndex = 0
    private var isFavoriteLeague = false
    
    // Dummy Data Counts (Later, these will be actual arrays of data fetched from Alamofire)
    private let totalTeams = 10
    private let recentGamesCount = 5
    private let upcomingGamesCount = 3
    
    // Initialization
    init(view: LeagueDetailsViewProtocol) {
        self.view = view
    }
    
    // Protocol Implementation
    func viewDidLoad() {
        // Later: Call NetworkManager here to fetch data.
        // For now: Tell the view we are ready to display our static data.
        // NetworkManager.shared.fetchLeagueDetails(id: selectedLeague?.id) { ... }

        view?.reloadData()
    }
    
    func didSelectTab(index: Int) {
        // Prevent unnecessary updates if tapping the same tab
        guard currentTabIndex != index else { return }
        
        currentTabIndex = index
        // Tell the view something changed so it can redraw
        view?.reloadData()
    }
    
    // MARK: - Data Providers for the View
    
    func getTeamsCount() -> Int {
        return totalTeams
    }
    
    func getGamesCount() -> Int {
        // Return 5 if Recent is selected, 3 if Upcoming is selected
        return currentTabIndex == 0 ? recentGamesCount : upcomingGamesCount
    }
    
    func getSelectedTabIndex() -> Int {
        return currentTabIndex
    }
    
    func getCurrentMatchState() -> MatchState {
        // If Recent (0), pass a dummy score. If Upcoming (1), pass the upcoming state.
        return currentTabIndex == 0 ? .recent(score: "3 - 1") : .upcoming
    }
    
    // MARK: - Favorite Logic
    func isFavorite() -> Bool {
        return isFavoriteLeague
    }

    func didTapFavorite() {
        // Toggle the state
        isFavoriteLeague.toggle()

        // Later: Save to or remove from CoreData here!

        // Tell the view to update its UI based on the new state
        view?.updateFavoriteIcon(isFavorite: isFavoriteLeague)
    }
}
