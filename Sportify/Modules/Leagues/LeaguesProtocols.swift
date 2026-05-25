//
//  LeaguesProtocols.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//

protocol LeaguesViewProtocol: AnyObject {
    func showLeagues(_ leagues: [League])
    func showError(_ message: String)
    func navigateToLeagueDetails(with league: League , sport : Sport)
}

protocol LeaguesPresenterProtocol: AnyObject {
    var selectedSport: Sport? { get set }
    func viewDidLoad()
    func didSelectLeague(at index: Int)
}
