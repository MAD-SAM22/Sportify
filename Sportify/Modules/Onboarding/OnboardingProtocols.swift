//
//  OnboardingProtocols.swift
//  Sportify
//
//  Created by Mina_Wagdy on 24/05/2026.
//
import Foundation

protocol OnboardingViewProtocol: AnyObject {
    func reloadData()
    func updatePageIndicator(to index: Int)
    func navigateToMainApp()
}

protocol OnboardingPresenterProtocol {
    var slides: [OnboardingSlide] { get }
    func viewDidLoad()
    func nextButtonClicked(currentIndex: Int)
    func skipButtonClicked()
}
