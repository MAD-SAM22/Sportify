//
//  TeamDetailsPresenter.swift
//  Sportify
//
//  Created by Osama Hosam on 31/05/2026.
//

import Foundation

class TeamDetailsPresenter: TeamDetailsPresenterProtocol {

    // MARK: - Properties
    weak var view: TeamDetailsViewProtocol?
    var selectedTeam: Team?
    var sport: String = "soccer"
    var isLoading: Bool = true

    // MARK: - Init
    init(view: TeamDetailsViewProtocol) {
        self.view = view
    }

    // MARK: - Protocol
    func viewDidLoad() {
        guard let team = selectedTeam else { return }

        // Show team details immediately with what we have
        view?.showTeamDetails(team)

        // Show players from team.players if available
        let players = team.players ?? []
        view?.showPlayers(players)

        // Show or hide lineup based on sport
        view?.showLineup(show: shouldShowLineup())

        // Fetch full team details from API if we have a teamKey
        guard let teamKey = team.teamKey else { return }
        // Trigger loading state for the deep-dive data (Players, Stadium, etc.)
        self.isLoading = true
        view?.showLoadingState()

        NetworkManager.shared.fetchTeamDetails(
            teamId: teamKey,
            sport: sport
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.view?.hideLoadingState()  // Turn off skeletons

                switch result {
                case .success(let fullTeam):
                    self?.selectedTeam = fullTeam
                    self?.view?.showTeamDetails(fullTeam)
                    self?.view?.showPlayers(fullTeam.players ?? [])
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    func shouldShowLineup() -> Bool {
        let teamSports = [
            "soccer", "football", "basketball", "baseball", "hockey",
        ]
        return teamSports.contains(sport.lowercased())
    }

    func getFormation() -> [[String]] {
        return [
            ["Goalkeeper"],
            ["Defender", "Defender", "Defender", "Defender"],
            ["Midfielder", "Midfielder", "Midfielder"],
            ["Forward", "Forward", "Forward"],
        ]
    }
}
