//
//  UIViewController+Alerts.swift
//  Sportify
//

import UIKit

extension UIViewController {

    /// Call this from any UIViewController to show a standard No Internet alert
    func showNoInternetAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("no_internet_title", comment: ""),
            message: NSLocalizedString("no_internet_msg", comment: ""),
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(
            title: NSLocalizedString("ok_button", comment: ""),
            style: .default
        )
        
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
        confirmTitleKey: String = "remove", // Changed to accept a localization key
        confirmAction: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        // Cancel Action triggers the optional cancel closure if provided
        let cancel = UIAlertAction(
            title: NSLocalizedString("cancel", comment: ""),
            style: .cancel
        ) { _ in
            cancelAction?()
        }

        // Confirm Action triggers the required confirm closure
        let confirm = UIAlertAction(
            title: NSLocalizedString(confirmTitleKey, comment: ""),
            style: .destructive
        ) { _ in
            confirmAction()
        }

        alert.addAction(cancel)
        alert.addAction(confirm)

        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
