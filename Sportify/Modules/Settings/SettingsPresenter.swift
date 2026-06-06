//
//  SettingsPresenter.swift
//  Sportify
//
//  Created by Osama Hosam on 03/06/2026.
//

import Foundation
import UIKit

class SettingsPresenter: SettingsPresenterProtocol {

    weak var view: SettingsViewProtocol?

    private let languageKey  = "app_language"
    private let darkModeKey  = "app_dark_mode"

    init(view: SettingsViewProtocol) {
        self.view = view
    }

    // MARK: - Lifecycle
    func viewDidLoad() {
        view?.updateLanguage(selected: getCurrentLanguage())
        view?.updateDarkMode(isOn: isDarkModeOn())
    }

    // MARK: - Language
    func didSelectLanguage(_ language: AppLanguage) {
        UserDefaults.standard.set(language.rawValue, forKey: languageKey)
        view?.updateLanguage(selected: language)
        applyLanguage(language)
    }

    func getCurrentLanguage() -> AppLanguage {
        let saved = UserDefaults.standard.string(forKey: languageKey) ?? "en"
        return AppLanguage(rawValue: saved) ?? .english
    }

    private func applyLanguage(_ language: AppLanguage) {
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        Bundle.setLanguage(language.rawValue)

        guard let windowScene = UIApplication.shared.connectedScenes
            .first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        //change direction 
        let semanticAttribute: UISemanticContentAttribute = language == .arabic ? .forceRightToLeft : .forceLeftToRight
            UIView.appearance().semanticContentAttribute = semanticAttribute
            UINavigationBar.appearance().semanticContentAttribute = semanticAttribute
            UITabBar.appearance().semanticContentAttribute = semanticAttribute

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
//        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")

        UIView.transition(with: window, duration: 0.4, options: .transitionFlipFromLeft) {
            window.rootViewController = homeVC
        }
    }

    // MARK: - Dark Mode
    func didToggleDarkMode(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: darkModeKey)
        view?.updateDarkMode(isOn: isOn)
        applyDarkMode(isOn: isOn)
    }

    func isDarkModeOn() -> Bool {
        // Default follows system if not set
        if UserDefaults.standard.object(forKey: darkModeKey) == nil {
            return UITraitCollection.current.userInterfaceStyle == .dark
        }
        return UserDefaults.standard.bool(forKey: darkModeKey)
    }

    private func applyDarkMode(isOn: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first as? UIWindowScene else { return }

        windowScene.windows.forEach { window in
            UIView.animate(withDuration: 0.3) {
                window.overrideUserInterfaceStyle = isOn ? .dark : .light
            }
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
    static let darkModeChanged = Notification.Name("darkModeChanged")
}
