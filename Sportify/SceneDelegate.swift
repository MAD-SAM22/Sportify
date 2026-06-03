//
//  SceneDelegate.swift
//  Sportify
//
//  Created by Osama Hosam on 19/05/2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
            _ scene: UIScene, willConnectTo session: UISceneSession,
            options connectionOptions: UIScene.ConnectionOptions
        ) {
            guard let windowScene = (scene as? UIWindowScene) else { return }

            // 1. Create a new window for the windowScene
            let window = UIWindow(windowScene: windowScene)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            // 2. Load and Enforce Saved Dark Mode Preference
            let isDark = UserDefaults.standard.bool(forKey: "app_dark_mode")
            window.overrideUserInterfaceStyle = isDark ? .dark : .light

            // 3. Load and Enforce Saved Language Semantic Alignment
            if let savedLanguage = UserDefaults.standard.string(forKey: "selected_language") {
                let attribute: UISemanticContentAttribute = (savedLanguage == "ar") ? .forceRightToLeft : .forceLeftToRight
                
                // Apply semantic alignment rules globally to all UI views, headers, and bars
                UIView.appearance().semanticContentAttribute = attribute
                UINavigationBar.appearance().semanticContentAttribute = attribute
                UITabBar.appearance().semanticContentAttribute = attribute
            }

            // 4. Check Onboarding Status in UserDefaults
            if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
                // User has already seen onboarding, bypass it and go to MainTabBar
                let mainTabBarVC =
                    storyboard.instantiateViewController(
                        withIdentifier: "MainTabBarController")
                    as! UITabBarController
                window.rootViewController = mainTabBarVC
            } else {
                // First time user, show the Onboarding flow
                let onboardingVC =
                    storyboard.instantiateViewController(
                        withIdentifier: "OnboardingViewController")
                    as! OnboardingViewController
                window.rootViewController = onboardingVC
            }

            // 5. Make this window the active one
            self.window = window
            window.makeKeyAndVisible()
        }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}
