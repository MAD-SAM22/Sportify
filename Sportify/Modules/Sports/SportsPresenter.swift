//
//  SportsPresenter.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//
import Foundation

class SportsPresenter: SportsPresenterProtocol {
    
    weak var view: SportsViewProtocol?
    
    private var sports: [SportsHome] = []
    
    init(view: SportsViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        sports = [
            SportsHome(name: "Basketball", imageName: "basketball_img"),
            SportsHome(name: "Soccer",     imageName: "soccer_img"),
            SportsHome(name: "Tennis",     imageName: "tennis_img"),
            SportsHome(name: "Football",   imageName: "football_img"),
            SportsHome(name: "Swimming",   imageName: "swimming_img"),
            SportsHome(name: "Cycling",    imageName: "cycling_img")
        ]
        view?.showSports(sports)
    }
    
    func didSelectSport(at index: Int) {
        let selected = sports[index]
        view?.navigateToLeagues(with: selected)
    }
}
