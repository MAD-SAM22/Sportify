//
//  LeaguesPresenter.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//

//  LeaguesPresenter.swift
//  Sportify

class LeaguesPresenter: LeaguesPresenterProtocol {

    weak var view: LeaguesViewProtocol?
    var selectedSport: SportsHome?
    private var leagues: [League] = []

    init(view: LeaguesViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        leagues = [
            League(name: "Premier League",  badgeImageName: "football_img"),
            League(name: "NBA",              badgeImageName: "football_img"),
            League(name: "NFL",              badgeImageName: "football_img"),
            League(name: "La Liga",          badgeImageName: "football_img"),
            League(name: "Serie A",          badgeImageName: "football_img"),
            League(name: "Bundesliga",       badgeImageName: "football_img"),
            League(name: "Ligue 1",          badgeImageName: "football_img"),
            League(name: "MLS",              badgeImageName: "football_img"),
        ]
        view?.showLeagues(leagues)
    }

    func didSelectLeague(at index: Int) {
        let selected = leagues[index]
        view?.navigateToDetails(with: selected)
    }
}
