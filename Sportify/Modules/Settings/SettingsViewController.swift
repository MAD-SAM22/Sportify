//
//  SettingsViewController.swift
//  Sportify
//
//  Created by Osama Hosam on 03/06/2026.
//

//  SettingsViewController.swift
//  Sportify

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var englishCheckmark: UIButton!
    @IBOutlet weak var arabicCheckmark: UIButton!

    var presenter: SettingsPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = SettingsPresenter(view: self)
        setupNavigationBar()
        setupUI()
        presenter.viewDidLoad()
    }

    // MARK: - Setup
    private func setupNavigationBar() {
        title = NSLocalizedString("Settings", comment: "")
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "Nav_Background")
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "Background")
        darkModeSwitch.onTintColor = UIColor(named: "Accent_Blue")
    }

    // MARK: - IBActions
    @IBAction func englishTapped(_ sender: UIButton) {
        presenter.didSelectLanguage(.english)
    }

    @IBAction func arabicTapped(_ sender: UIButton) {
        presenter.didSelectLanguage(.arabic)
    }

    @IBAction func darkModeSwitchToggled(_ sender: UISwitch) {
        presenter.didToggleDarkMode(isOn: sender.isOn)
    }

    // MARK: - Checkmark Helper
    private func updateCheckmarks(selected: AppLanguage) {
        let checkImage    = UIImage(systemName: "checkmark.circle.fill")
        let noImage: UIImage? = nil

        // Set tint and image based on selection
        englishCheckmark.setImage(
            selected == .english ? checkImage : noImage,
            for: .normal
        )
        arabicCheckmark.setImage(
            selected == .arabic ? checkImage : noImage,
            for: .normal
        )

        englishCheckmark.tintColor = UIColor(named: "Accent_Blue")
        arabicCheckmark.tintColor  = UIColor(named: "Accent_Blue")

        // Semantic layout for Arabic
        if selected == .arabic {
            view.semanticContentAttribute = .forceRightToLeft
            navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
        } else {
            view.semanticContentAttribute = .forceLeftToRight
            navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
        }
    }
}

// MARK: - SettingsViewProtocol
extension SettingsViewController: SettingsViewProtocol {

    func updateLanguage(selected: AppLanguage) {
        updateCheckmarks(selected: selected)
    }

    func updateDarkMode(isOn: Bool) {
        darkModeSwitch.setOn(isOn, animated: true)
    }
}
