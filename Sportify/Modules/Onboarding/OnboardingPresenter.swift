//
//  OnboardingPresenter.swift
//  Sportify
//
//  Created by Mina_Wagdy on 24/05/2026.
//
import Foundation

class OnboardingPresenter: OnboardingPresenterProtocol {
    
    weak var view: OnboardingViewProtocol?
    
    var slides: [OnboardingSlide] = []
    
    init(view: OnboardingViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        setupSlides()
        view?.reloadData()
    }
    
    private func setupSlides() {
        slides = [
            OnboardingSlide(
                title: NSLocalizedString("onboarding_title_1", comment: ""),
                description: NSLocalizedString("onboarding_desc_1", comment: ""),
                imageName: "onboarding1"
            ),
            OnboardingSlide(
                title: NSLocalizedString("onboarding_title_2", comment: ""),
                description: NSLocalizedString("onboarding_desc_2", comment: ""),
                imageName: "onboarding2"
            ),
            OnboardingSlide(
                title: NSLocalizedString("onboarding_title_3", comment: ""),
                description: NSLocalizedString("onboarding_desc_3", comment: ""),
                imageName: "onboarding3"
            )
        ]
    }
    
    func nextButtonClicked(currentIndex: Int) {
        let nextIndex = currentIndex + 1
        if nextIndex < slides.count {
            view?.updatePageIndicator(to: nextIndex)
        } else {
            view?.navigateToMainApp()
        }
    }
    
    func skipButtonClicked() {
        view?.navigateToMainApp()
    }
}
