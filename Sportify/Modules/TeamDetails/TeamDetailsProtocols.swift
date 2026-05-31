//
//  TeamDetailsProtocols.swift
//  Sportify
//
//  Created by Osama Hosam on 31/05/2026.
//
import UIKit

protocol TeamDetailsViewProtocol: AnyObject {
    func showTeamDetails(_ team: Team)
    func showPlayers(_ players: [Player])
    func showLineup(show: Bool)
    func showError(_ message: String)
}

protocol TeamDetailsPresenterProtocol: AnyObject {
    var selectedTeam: Team? { get set }
    var sport: String { get set }
    func viewDidLoad()
    func getFormation() -> [[String]]
    func shouldShowLineup() -> Bool
}
