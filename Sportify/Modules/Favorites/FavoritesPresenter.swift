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
        if hasFavorites {
            // Hardcoded for now — replace with CoreData fetch later
            favorites = [

                League(
                    leagueKey: 1,
                    leagueName: "Premier League",
                    leagueLogo: "football_img"
                ),

                League(
                    leagueKey: 2,
                    leagueName: "LaLiga",
                    leagueLogo: "football_img"
                ),

                League(
                    leagueKey: 3,
                    leagueName: "Serie A",
                    leagueLogo: "football_img"
                )
            ]
            view?.showFavorites(favorites)
        } else {
            view?.showEmptyState()
        }
    }

    func didSelectLeague(at index: Int) {
        let selected = favorites[index]
        view?
            .navigateToLeagueDetails(
                with: selected ,
                sport: Sport(sportName: "football", sportThumb: "")
            )
    }

    func didDeleteLeague(at index: Int) {
        favorites.remove(at: index)
        view?.deleteRow(at: index)

        // If no more favorites show empty state
        if favorites.isEmpty {
            view?.showEmptyState()
        }
    }
}
