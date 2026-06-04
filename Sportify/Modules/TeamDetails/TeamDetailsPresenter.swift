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
        
        view?.showTeamDetails(team)
        view?.showLineup(show: shouldShowLineup())
        
        guard let teamKey = team.teamKey else {
            view?.showPlayers(team.players ?? [])
            return
        }
        
        self.isLoading = true
        view?.showLoadingState()
        
        NetworkManager.shared.fetchTeamDetails(
            teamId: teamKey,
            sport: sport
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                self.view?.hideLoadingState()
                
                switch result {
                case .success(let fullTeam):
                    self.selectedTeam = fullTeam
                    let players = fullTeam.players ?? []
                    
                    // Sort: players with images first
                    let sortedPlayers = players.sorted {
                        let firstHasImage = !($0.playerImage ?? "").isEmpty
                        let secondHasImage = !($1.playerImage ?? "").isEmpty
                        return firstHasImage && !secondHasImage
                    }
                    
                    self.view?.showTeamDetails(fullTeam)
                    self.view?.showPlayers(sortedPlayers)
                    
                    // Build lineup from real players
                    if self.shouldShowLineup() {
                        let formation = self.buildFormation(from: players)
                        self.view?.updateLineup(formation: formation)
                    }
                    
                case .failure(let error):
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func buildFormation(from players: [Player]) -> [[(name: String, imageURL: String?)]] {
        let goalkeepers  = players.filter { $0.playerPosition == "Goalkeepers" }
        let defenders    = players.filter { $0.playerPosition == "Defenders" }
        let midfielders  = players.filter { $0.playerPosition == "Midfielders" }
        let forwards     = players.filter { $0.playerPosition == "Forwards" }
        
        func pick(_ group: [Player], _ count: Int) -> [(name: String, imageURL: String?)] {
            let selected = Array(group.prefix(count))
            // Pad with empty slots if not enough players
            let padded = selected + Array(repeating: nil, count: max(0, count - selected.count))
            return padded.map { player in
                (
                    name: player?.playerName ?? "",
                    imageURL: player?.playerImage
                )
            }
        }
        
        return [
            pick(goalkeepers, 1),
            pick(defenders, 4),
            pick(midfielders, 3),
            pick(forwards, 3)
        ]
    }
    
    // Keep getFormation() as fallback for skeleton/loading state
    func getFormation() -> [[String]] {
        return [
            ["Goalkeeper"],
            ["Defender", "Defender", "Defender", "Defender"],
            ["Midfielder", "Midfielder", "Midfielder"],
            ["Forward", "Forward", "Forward"],
        ]
    }
    func shouldShowLineup() -> Bool {
        let teamSports = ["soccer", "football", "basketball", "baseball", "hockey"]
        return teamSports.contains(sport.lowercased())
    }

    func getFormation() -> [[(name: String, imageURL: String?)]] {
        return [
            [("Goalkeeper", nil)],
            [("Defender", nil), ("Defender", nil), ("Defender", nil), ("Defender", nil)],
            [("Midfielder", nil), ("Midfielder", nil), ("Midfielder", nil)],
            [("Forward", nil), ("Forward", nil), ("Forward", nil)],
        ]
    }

    func updateLineup(formation: [[(name: String, imageURL: String?)]]) {
        view?.updateLineup(formation: formation)
    }
}
