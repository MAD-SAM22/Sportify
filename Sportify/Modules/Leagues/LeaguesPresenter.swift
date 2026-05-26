//
//  LeaguesPresenter.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//

class LeaguesPresenter: LeaguesPresenterProtocol {

    weak var view: LeaguesViewProtocol?

    var selectedSport: Sport?

    private var leagues: [League] = []

    init(view: LeaguesViewProtocol) {

        self.view = view
    }

    func viewDidLoad() {

        leagues = [

            League(
                leagueKey: 1,
                leagueName: "Premier League",
                leagueLogo: "football_img"
            ),

            League(
                leagueKey: 2,
                leagueName: "NBA",
                leagueLogo: "football_img"
            ),

            League(
                leagueKey: 3,
                leagueName: "NFL",
                leagueLogo: "football_img"
            ),

            League(
                leagueKey: 4,
                leagueName: "La Liga",
                leagueLogo: "football_img"
            ),

            League(
                leagueKey: 5,
                leagueName: "Serie A",
                leagueLogo: "football_img"
            ),

            League(
                leagueKey: 6,
                leagueName: "Bundesliga",
                leagueLogo: "football_img"
            ),

            League(
                leagueKey: 7,
                leagueName: "Ligue 1",
                leagueLogo: "football_img"
            ),

            League(
                leagueKey: 8,
                leagueName: "MLS",
                leagueLogo: "football_img"
            )
        ]

        view?.showLeagues(leagues)
    }

    func didSelectLeague(at index: Int) {

        let selected = leagues[index]

        view?.navigateToLeagueDetails(with: selected, sport: selectedSport ?? Sport(sportName: "football", sportThumb: ""))
    }
}
