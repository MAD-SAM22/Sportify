//
//  UIViewController+Navigation.swift
//  Sportify
//
//  Created by Osama Hosam on 02/06/2026.
//

import UIKit

extension UIViewController {

     func setupSettingsButton() {
            let settingsImage = UIImage(systemName: "gearshape.fill")
            let settingsButton = UIBarButtonItem(
                image: settingsImage,
                style: .plain,
                target: self,
                action: #selector(settingsButtonTapped)
            )
            
         settingsButton.tintColor = UIColor(named: "Text_Color") ?? .white
         
            navigationItem.rightBarButtonItem = settingsButton
        }
        
        @objc  func settingsButtonTapped() {
            
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let setttingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
                    navigationController?.pushViewController(setttingsVC, animated: true)
                }
            
        }
    func setupAppNavigationBar(withTitle title: String, prefersLargeTitles: Bool = false) {
            self.title = title
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            
            appearance.backgroundColor = UIColor(named: "Nav_Background") ?? UIColor(red: 0.08, green: 0.10, blue: 0.18, alpha: 1)
            
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor(named: "Text_Color") ?? .label,
                .font: UIFont.boldSystemFont(ofSize: 20)
            ]
            
            if prefersLargeTitles {
                appearance.largeTitleTextAttributes = [
                    .foregroundColor: UIColor(named: "Text_Color") ?? .label,
                    .font: UIFont.boldSystemFont(ofSize: 34)
                ]
                navigationController?.navigationBar.prefersLargeTitles = true
            } else {
                navigationController?.navigationBar.prefersLargeTitles = false
            }
            
            // Apply the appearance configurations to the navigation controller
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            
            // Dynamic back button / bar items tint
            navigationController?.navigationBar.tintColor = UIColor(named: "Accent_Blue") ?? .systemBlue
        }
}
