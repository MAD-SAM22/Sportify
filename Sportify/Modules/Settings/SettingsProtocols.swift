//
//  SettingsProtocols.swift
//  Sportify
//
//  Created by Osama Hosam on 03/06/2026.
//

import Foundation

protocol SettingsViewProtocol: AnyObject {
    func updateLanguage(selected: AppLanguage)
    func updateDarkMode(isOn: Bool)
}

protocol SettingsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectLanguage(_ language: AppLanguage)
    func didToggleDarkMode(isOn: Bool)
    func getCurrentLanguage() -> AppLanguage
    func isDarkModeOn() -> Bool
}

enum AppLanguage: String {
    case english = "en"
    case arabic  = "ar"
}
