import Alamofire
//
//  ReachabilityManager.swift
//  Sportify
//
//  Created by Mina_Wagdy on 01/06/2026.
//
import UIKit

class ReachabilityManager {

    static let shared = ReachabilityManager()

    // Alamofire's reachability manager
    private let reachability = NetworkReachabilityManager()

    private init() {}

    // A simple computed property we can check anywhere
    var isConnectedToInternet: Bool {
        return reachability?.isReachable ?? false
    }

    // Optional: Call this in AppDelegate didFinishLaunchingWithOptions if you want to listen to live changes
    func startMonitoring() {
        reachability?.startListening { status in
            print("Network Status Changed: \(status)")
        }
    }
}

// MARK: - Reusable Alert Extension
extension UIViewController {

    /// Call this from any UIViewController to show a standard No Internet alert
    func showNoInternetAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your network connection and try again.",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)

        // Ensure this is presented on the main thread
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    /// A reusable confirmation alert for destructive actions (like deleting/removing).
    func showDestructiveAlert(
        title: String,
        message: String,
        confirmTitle: String = "Remove",
        confirmAction: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title, message: message, preferredStyle: .alert)

        // Cancel Action triggers the optional cancel closure if provided
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelAction?()
        }

        // Confirm Action triggers the required confirm closure
        let confirm = UIAlertAction(title: confirmTitle, style: .destructive) {
            _ in
            confirmAction()
        }

        alert.addAction(cancel)
        alert.addAction(confirm)

        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
