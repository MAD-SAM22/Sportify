//
//  Bundle+Language.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.
//

import Foundation

extension Bundle {
    private static var swizzled = false

    static func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let languageBundle = Bundle(path: path) else { return }

        // Only swizzle once
        if !swizzled {
            swizzleLocalization()
            swizzled = true
        }

        // Store the active bundle
        objc_setAssociatedObject(
            Bundle.main,
            &AssociatedKeys.bundle,
            languageBundle,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }

    private static func swizzleLocalization() {
        let original = class_getInstanceMethod(
            Bundle.self,
            #selector(localizedString(forKey:value:table:))
        )
        let swizzled = class_getInstanceMethod(
            Bundle.self,
            #selector(swizzled_localizedString(forKey:value:table:))
        )
        guard let original, let swizzled else { return }
        method_exchangeImplementations(original, swizzled)
    }

    @objc private func swizzled_localizedString(
        forKey key: String,
        value: String?,
        table: String?
    ) -> String {
        // If we have a stored language bundle, use it
        if let bundle = objc_getAssociatedObject(
            self,
            &AssociatedKeys.bundle
        ) as? Bundle {
            // Call the original on the language bundle (not self, to avoid infinite loop)
            return bundle.swizzled_localizedString(forKey: key, value: value, table: table)
        }
        // Otherwise fall back to the original implementation
        return swizzled_localizedString(forKey: key, value: value, table: table)
    }

    private enum AssociatedKeys {
        static var bundle = "activeLanguageBundle"
    }
}
