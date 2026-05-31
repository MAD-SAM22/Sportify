//
//  LeagueDetailsPresenter.swift
//  Sportify
//
//  Created by Mina_Wagdy on 22/05/2026.
//

import Foundation

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {

    // Weak reference to the view to prevent memory leaks
    private weak var view: LeagueDetailsViewProtocol?

    // Properties passed in from the ViewController
    var selectedLeague: League?
    var selectedSport: Sport?

    // Data arrays to hold the fetched results
    private var teams: [Team] = []
    private var recentEvents: [Event] = []
    private var upcomingEvents: [Event] = []

    // We'll use this to track which tab is active (0 for Recent, 1 for Upcoming)
    private var selectedTabIndex = 0
    private var isFavoriteLeague = false
    var isLoading: Bool = true

    init(view: LeagueDetailsViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        fetchLeagueData()
    }

    private func fetchLeagueData() {
        // Safely unwrap the IDs/names needed for the API call
        // (Assuming your League model has a leagueKey or similar integer property)
        guard let leagueId = selectedLeague?.leagueKey,
            let sportName = selectedSport?.sportName
        else {
            print("❌ Missing league or sport details")
            return
        }
        self.isLoading = true
        self.view?.reloadData()
        // Call the NetworkManager's parallel fetch method
        NetworkManager.shared.fetchLeagueDetails(
            leagueId: leagueId, sport: sportName
        ) { [weak self] fetchedTeams, fetchedRecent, fetchedUpcoming in

            guard let self = self else { return }

            // 1. Store the fetched data locally in the Presenter
            self.teams = fetchedTeams
            self.recentEvents = fetchedRecent
            self.upcomingEvents = fetchedUpcoming

            // 2. Notify the View on the main thread to refresh the UI
            self.isLoading = false
            self.view?.reloadData()
        }
    }

    // MARK: - Team Selection & Navigation
    func didSelectTeam(at index: Int) {
        // 1. Ensure the index is within bounds to prevent runtime crashes
        guard index >= 0 && index < teams.count else {
            print("⚠️ Selected index out of range for teams array")
            return
        }

        // 2. Retrieve the specific team model object
        let clickedTeam = teams[index]

        // 3. Instruct the view to perform the route, passing the model along
        view?.navigateToTeamDetails(with: clickedTeam)
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
    // MARK: - Data Source Counts
    func getTeamsCount() -> Int {
        return teams.count
    }

    func getGamesCount() -> Int {
        // Tab 0 is Recent, Tab 1 is Upcoming
        if selectedTabIndex == 0 {
            return recentEvents.count
        } else {
            return upcomingEvents.count
        }
    }

    // MARK: - Tab Selection Logic
    func didSelectTab(index: Int) {
        // Only update and reload if the user tapped a *different* tab
        if selectedTabIndex != index {
            selectedTabIndex = index
            view?.reloadData()  // This forces the CollectionView to refresh the Games section
        }
    }

    func getSelectedTabIndex() -> Int {
        return selectedTabIndex
    }

    // MARK: - Match State
    func getCurrentMatchState(for index: Int) -> MatchState {
        if selectedTabIndex == 0 {
            // It's a recent match, so let's extract the score safely
            let game = recentEvents[index]
            let score = game.eventFinalResult ?? "? - ?"
            return .recent(score: score)
        } else {
            // It's an upcoming match, no score needed
            return .upcoming
        }
    }

    // MARK: - Data Getters for the View
    func getTeam(at index: Int) -> Team? {
        guard index >= 0 && index < teams.count else { return nil }
        return teams[index]
    }

    func getGame(at index: Int) -> Event? {
        // Return from recent or upcoming based on the selected tab
        if selectedTabIndex == 0 {
            guard index >= 0 && index < recentEvents.count else { return nil }
            return recentEvents[index]
        } else {
            guard index >= 0 && index < upcomingEvents.count else { return nil }
            return upcomingEvents[index]
        }
    }
}
