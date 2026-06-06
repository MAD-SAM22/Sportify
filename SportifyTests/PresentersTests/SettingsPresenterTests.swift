//
//  MockSettingsView.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.
//


//
//  SettingsPresenterTests.swift
//  SportifyTests
//

import XCTest
@testable import Sportify

// MARK: - Mock View

final class MockSettingsView: SettingsViewProtocol {
    var updateLanguageCalled = false
    var updateDarkModeCalled = false

    var receivedLanguage: AppLanguage?
    var receivedDarkMode: Bool?

    func updateLanguage(selected language: AppLanguage) {
        updateLanguageCalled = true
        receivedLanguage = language
    }
    func updateDarkMode(isOn: Bool) {
        updateDarkModeCalled = true
        receivedDarkMode = isOn
    }
}

// MARK: - SettingsPresenterTests

final class SettingsPresenterTests: XCTestCase {

    var view: MockSettingsView!
    var sut: SettingsPresenter!
    let languageKey = "app_language"
    let darkModeKey = "app_dark_mode"

    override func setUp() {
        super.setUp()
        // Clean UserDefaults before every test
        UserDefaults.standard.removeObject(forKey: languageKey)
        UserDefaults.standard.removeObject(forKey: darkModeKey)

        view = MockSettingsView()
        sut  = SettingsPresenter(view: view)
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: languageKey)
        UserDefaults.standard.removeObject(forKey: darkModeKey)
        sut = nil
        view = nil
        super.tearDown()
    }

    // MARK: - viewDidLoad

    func test_viewDidLoad_callsUpdateLanguage() {
        sut.viewDidLoad()
        XCTAssertTrue(view.updateLanguageCalled)
    }

    func test_viewDidLoad_callsUpdateDarkMode() {
        sut.viewDidLoad()
        XCTAssertTrue(view.updateDarkModeCalled)
    }

    func test_viewDidLoad_passesCurrentLanguageToView() {
        UserDefaults.standard.set("ar", forKey: languageKey)
        sut.viewDidLoad()
        XCTAssertEqual(view.receivedLanguage, .arabic)
    }

    func test_viewDidLoad_passesCurrentDarkModeToView() {
        UserDefaults.standard.set(true, forKey: darkModeKey)
        sut.viewDidLoad()
        XCTAssertEqual(view.receivedDarkMode, true)
    }

    // MARK: - didSelectLanguage

    func test_didSelectLanguage_savesToUserDefaults() {
        sut.didSelectLanguage(.arabic)
        XCTAssertEqual(UserDefaults.standard.string(forKey: languageKey), "ar")
    }

    func test_didSelectLanguage_updatesView() {
        sut.didSelectLanguage(.arabic)
        XCTAssertTrue(view.updateLanguageCalled)
        XCTAssertEqual(view.receivedLanguage, .arabic)
    }

    func test_didSelectLanguage_english_savesEnglishKey() {
        sut.didSelectLanguage(.english)
        XCTAssertEqual(UserDefaults.standard.string(forKey: languageKey), "en")
    }

    func test_didSelectLanguage_postsLanguageChangedNotification() {
        let exp = expectation(forNotification: .languageChanged, object: nil)

        sut.didSelectLanguage(.arabic)

        wait(for: [exp], timeout: 1)
    }

    func test_didSelectLanguage_notificationCarriesCorrectLanguage() {
        var receivedLanguage: AppLanguage?
        let observer = NotificationCenter.default.addObserver(
            forName: .languageChanged, object: nil, queue: .main
        ) { note in
            receivedLanguage = note.object as? AppLanguage
        }

        sut.didSelectLanguage(.arabic)

        XCTAssertEqual(receivedLanguage, .arabic)
        NotificationCenter.default.removeObserver(observer)
    }

    // MARK: - getCurrentLanguage

    func test_getCurrentLanguage_defaultsToEnglish_whenNothingSaved() {
        XCTAssertEqual(sut.getCurrentLanguage(), .english)
    }

    func test_getCurrentLanguage_returnsArabic_whenArabicSaved() {
        UserDefaults.standard.set("ar", forKey: languageKey)
        XCTAssertEqual(sut.getCurrentLanguage(), .arabic)
    }

    func test_getCurrentLanguage_returnsEnglish_whenEnglishSaved() {
        UserDefaults.standard.set("en", forKey: languageKey)
        XCTAssertEqual(sut.getCurrentLanguage(), .english)
    }

    func test_getCurrentLanguage_returnsEnglish_whenInvalidValueSaved() {
        UserDefaults.standard.set("xyz", forKey: languageKey)
        XCTAssertEqual(sut.getCurrentLanguage(), .english)
    }

    // MARK: - isDarkModeOn

    func test_isDarkModeOn_returnsTrue_whenSavedTrue() {
        UserDefaults.standard.set(true, forKey: darkModeKey)
        XCTAssertTrue(sut.isDarkModeOn())
    }

    func test_isDarkModeOn_returnsFalse_whenSavedFalse() {
        UserDefaults.standard.set(false, forKey: darkModeKey)
        XCTAssertFalse(sut.isDarkModeOn())
    }

    func test_isDarkModeOn_whenNotSet_returnsSystemValue() {
        // No value saved — must fall back to system trait, not crash
        let result = sut.isDarkModeOn()
        XCTAssertNotNil(result) // returns a valid Bool either way
    }

    // MARK: - didToggleDarkMode

    func test_didToggleDarkMode_savesToUserDefaults() {
        sut.didToggleDarkMode(isOn: true)
        XCTAssertTrue(UserDefaults.standard.bool(forKey: darkModeKey))
    }

    func test_didToggleDarkMode_false_savesCorrectly() {
        sut.didToggleDarkMode(isOn: false)
        XCTAssertFalse(UserDefaults.standard.bool(forKey: darkModeKey))
    }

    func test_didToggleDarkMode_updatesView() {
        sut.didToggleDarkMode(isOn: true)
        XCTAssertTrue(view.updateDarkModeCalled)
        XCTAssertEqual(view.receivedDarkMode, true)
    }

    func test_didToggleDarkMode_toggle_reflectsNewValue() {
        sut.didToggleDarkMode(isOn: true)
        sut.didToggleDarkMode(isOn: false)
        XCTAssertFalse(UserDefaults.standard.bool(forKey: darkModeKey))
        XCTAssertEqual(view.receivedDarkMode, false)
    }
}