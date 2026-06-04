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
    
    init(view: SportsViewProtocol) {
        
        self.view = view
    }
    
    func viewDidLoad() {
            
            sports = [
                Sport(
                    // Using localized strings for the data models
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
