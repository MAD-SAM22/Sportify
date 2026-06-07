//
//  SportsPresenter.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//

import Foundation

class SportsPresenter: SportsPresenterProtocol {
    
    weak var view: SportsViewProtocol?
    
    private var sports: [Sport] = []
    private let reachability: ReachabilityManager

    init(view: SportsViewProtocol, reachability: ReachabilityManager = .shared) {
        self.view = view
        self.reachability = reachability
    }
    
    func viewDidLoad() {
            
            sports = [
                Sport(
                    sportName: NSLocalizedString("basketball", comment: ""),
                    sportThumb: "basketball_img"
                ),
                Sport(
                    sportName: NSLocalizedString("soccer", comment: ""),
                    sportThumb: "soccer_img"
                ),
                Sport(
                    sportName: NSLocalizedString("tennis", comment: ""),
                    sportThumb: "tennis_img"
                ),
                Sport(
                    sportName: NSLocalizedString("cricket", comment: ""),
                    sportThumb: "cricket_img"
                )
            ]
            
            view?.showSports(sports)
        }
    
    func didSelectSport(at index: Int) {
        if ReachabilityManager.shared.isConnectedToInternet{
            let selected = sports[index]
            
            view?.navigateToLeagues(with: selected)
        }else{
            view?.showNoInternetAlert()
        }
    }
}
