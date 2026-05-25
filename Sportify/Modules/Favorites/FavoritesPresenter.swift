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
                League(name: "Premier League", badgeImageName: "football_img"),
                League(name: "LaLiga",         badgeImageName: "football_img"),
                League(name: "Serie A",        badgeImageName: "football_img"),
            ]
            view?.showFavorites(favorites)
        } else {
            view?.showEmptyState()
        }
    }

    func didSelectLeague(at index: Int) {
        let selected = favorites[index]
        view?.navigateToLeagueDetails(with: selected ,sport: SportsHome(name: "football", imageName: ""))
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
