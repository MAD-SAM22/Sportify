//
//  FavoritesPresenter.swift
//  Sportify
//
//  Created by Osama Hosam on 23/05/2026.
//

class FavoritesPresenter: FavoritesPresenterProtocol {

    weak var view: FavoritesViewProtocol?
    private var favorites: [League] = []

    // Toggle this to test both states
    private let hasFavorites: Bool = true

    init(view: FavoritesViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
    }
    func viewWillAppear() {
        favorites = CoreDataManager.shared.fetchFavoriteLeagues()

        if favorites.isEmpty {
            view?.showEmptyState()
        } else {
            view?.showFavorites(favorites)
        }
    }

    func didSelectLeague(at index: Int) {
        // Check Internet Connection before navigating
        if ReachabilityManager.shared.isConnectedToInternet {
            let selected = favorites[index]
            let sportName = selected.sportName ?? "football"
            view?.navigateToLeagueDetails(
                with: selected,
                sport: Sport(sportName: sportName, sportThumb: "")
            )
        } else {
            // Show alert if offline
            view?.showNoInternetAlert()
        }
    }

    func didDeleteLeague(at index: Int) {
        let leagueToDelete = favorites[index]

        // Delete from CoreData using the leagueKey
        if let key = leagueToDelete.leagueKey {
            CoreDataManager.shared.deleteLeagueFromFavorites(leagueKey: key)
        }

        // Update local array and View
        favorites.remove(at: index)
        view?.deleteRow(at: index)

        // If no more favorites, show empty state
        if favorites.isEmpty {
            view?.showEmptyState()
        }
    }
}
