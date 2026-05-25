//
//  SportsProtocols.swiftSportsProtocols.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//

//(what Presenter can tell the View to do)
protocol SportsViewProtocol: AnyObject {
    func showSports(_ sports: [Sport])
    func showError(_ message: String)
    func navigateToLeagues(with sport: Sport)
}

//(what View can tell the Presenter to do)
protocol SportsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectSport(at index: Int)
}
