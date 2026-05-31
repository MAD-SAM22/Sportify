//
//  LeaguesPresenter.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//
import Foundation

class LeaguesPresenter: LeaguesPresenterProtocol {

    weak var view: LeaguesViewProtocol?

    var selectedSport: Sport?

    private var leagues: [League] = []
    var isLoading: Bool = true

    init(view: LeaguesViewProtocol) {

        self.view = view
    }

    func viewDidLoad() {
        guard let sport = selectedSport?.sportName else { return }
        self.isLoading = true
        self.view?.showLeagues([])
        NetworkManager.shared.fetchLeagues(for: sport) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let leagues):
                    self?.leagues = leagues
                    self?.view?.showLeagues(leagues)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }

    }

    func didSelectLeague(at index: Int) {

        let selected = leagues[index]

        view?.navigateToLeagueDetails(
            with: selected,
            sport: selectedSport ?? Sport(sportName: "football", sportThumb: "")
        )
    }
}
