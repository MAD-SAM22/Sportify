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
            OnboardingSlide(title: "Join tournaments, academies\n& book your coach!",
                            description: "Our ultimate app streamlines joining multiple tournaments at your convenience. Easily join academies and book coaches within your budget with just one click to unlock your full potential.",
                            imageName: "onboarding1"),
            
            OnboardingSlide(title: "Empower Athletes by creating\na diverse sports academy!",
                            description: "Through our app, you can create and expand athletic academies and empower potential athletes. Easily create multiple classes under one academy to grow and improve business performance.",
                            imageName: "onboarding2"),
            
            OnboardingSlide(title: "Register as a Coach today\nto Train Athletes!",
                            description: "Register as a coach via our app to enhance athlete skills. Also, you can directly connect with athletes and access their contact details.",
                            imageName: "onboarding3")
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
