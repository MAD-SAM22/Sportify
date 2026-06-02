//
//  UIViewController+Navigation.swift
//  Sportify
//
//  Created by Osama Hosam on 02/06/2026.
//

import UIKit

extension UIViewController {

    func setupAppNavigationBar(withTitle title: String, prefersLargeTitles: Bool = false) {
        self.title = title
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Dynamically applies your Asset Catalog colors
        appearance.backgroundColor = UIColor(named: "Nav_Background")
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
