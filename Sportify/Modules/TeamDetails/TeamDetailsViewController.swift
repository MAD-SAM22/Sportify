//
//  TeamDetailsViewController.swift
//  Sportify
//
//  Created by Osama Hosam on 25/05/2026.
//
//  TeamDetailsViewController.swift
//  Sportify

import Kingfisher
import SkeletonView
import UIKit

class TeamDetailsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentStackView: UIStackView!

    // MARK: - Properties
    var selectedTeam: Team?
    var sport: String = "soccer"
    var presenter: TeamDetailsPresenterProtocol!

    // NIB Views
    private var headerView: TeamHeaderView!
    private var infoCardsView: TeamInfoCardsView!
    private var aboutView: TeamAboutView!
    private var playersView: TeamPlayersView!
    private var lineupView: TeamLineupView?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Inject presenter
        presenter = TeamDetailsPresenter(view: self)
        presenter.selectedTeam = selectedTeam
        presenter.sport = sport

        setupUI()
        setupAppNavigationBar(withTitle: "Team Details")
        buildStaticSections()

        // Tell presenter view is ready
        presenter.viewDidLoad()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor =
            UIColor(named: "Background")
            ?? UIColor(red: 0.08, green: 0.10, blue: 0.18, alpha: 1)
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
    }

    // MARK: - Build Static Sections
    // These sections are always shown — data filled in by presenter callbacks
    private func buildStaticSections() {
        addHeaderView()
        addInfoCardsView()
        addAboutView()
        addPlayersView()
    }

    // MARK: - NIB Sections
    private func addHeaderView() {
        headerView = TeamHeaderView.loadFromNib()
        contentStackView.addArrangedSubview(headerView)
    }

    private func addInfoCardsView() {
        infoCardsView = TeamInfoCardsView.loadFromNib()
        contentStackView.addArrangedSubview(infoCardsView)
    }

    private func addAboutView() {
        aboutView = TeamAboutView.loadFromNib()
        aboutView.configure(description: "Loading team info...")
        contentStackView.addArrangedSubview(aboutView)
    }

    private func addPlayersView() {
        playersView = TeamPlayersView.loadFromNib()
        contentStackView.addArrangedSubview(playersView)
    }

    private func addLineupView() {
        guard lineupView == nil else { return }
        let lineup = TeamLineupView.loadFromNib()
        lineup.translatesAutoresizingMaskIntoConstraints = false
        lineup.configure(formation: presenter.getFormation())
        contentStackView.addArrangedSubview(lineup)
        lineup.heightAnchor.constraint(equalToConstant: 500).isActive = true
        lineupView = lineup
    }
    // MARK: - Loading States
    func showLoadingState() {
        // Prep the empty stack view before triggering the animation
        playersView?.setupDummySkeletonViews()

        let viewsToAnimate: [UIView?] = [
            headerView, infoCardsView, aboutView, playersView, lineupView,
        ]

        viewsToAnimate.forEach { view in
            view?.showAnimatedGradientSkeleton()
        }
    }

    func hideLoadingState() {
        let viewsToAnimate: [UIView?] = [
            headerView, infoCardsView, aboutView, playersView, lineupView,
        ]

        viewsToAnimate.forEach { view in
            view?.hideSkeleton()
        }
    }

}

// MARK: - TeamDetailsViewProtocol
extension TeamDetailsViewController: TeamDetailsViewProtocol {

    func updateLineup(formation: [[(name: String, imageURL: String?)]]) {
        lineupView?.configure(formation: formation)
    }

    func showTeamDetails(_ team: Team) {
        // Update title (Use a localized default if name is missing)
        title =
            team.teamName
            ?? NSLocalizedString("team_details_title", comment: "")

        // Header - Now passing the URL string directly!
        headerView.configure(
            teamName: team.teamName
                ?? NSLocalizedString("unknown_team", comment: ""),
            bannerImage: UIImage(named: "team_banner"),
            logoURL: team.teamLogo
        )

        // Info cards - passing our "N/A" localization if data is missing
        let notAvailable = NSLocalizedString("not_available", comment: "")
        infoCardsView.configure(
            country: team.teamCountry ?? notAvailable,
            stadium: team.venueName ?? notAvailable,
            founded: team.teamFounded ?? notAvailable
        )

        // About - localized string formatting
        let country =
            team.teamCountry ?? NSLocalizedString("unknown_team", comment: "")
        let founded = team.teamFounded ?? notAvailable
        let stadium = team.venueName ?? notAvailable

        let descFormat = NSLocalizedString("team_desc_placeholder", comment: "")

        // Use String(format:) if your localized string has %@ placeholders, OR
        // since we just have a static string in the localizations from Step 7:
        if descFormat.contains("%@") {
            // If you updated the strings file to use formatting
            aboutView.configure(
                description: String(
                    format: descFormat, country, founded, stadium))
        } else {
            // If using the simple string we added in Step 7
            aboutView.configure(
                description:
                    "A historic team from \(country), founded in \(founded), playing at \(stadium)."
            )
        }
    }

    func showPlayers(_ players: [Player]) {
        // Map Player model to (name, image) tuples for the view
        let playerTuples: [(name: String, image: UIImage?)] = players.map {
            player in
            (
                name: player.playerName ?? "Player",
                image: nil  // Kingfisher loads async — handle inside TeamPlayersView
            )
        }

        // Pass URL strings separately for Kingfisher loading
        playersView.configure(players: playerTuples)
        playersView.configureWithURLs(players.map { $0.playerImage ?? "" })
    }

    func showLineup(show: Bool) {
        if show {
            addLineupView()
        } else {
            lineupView?.removeFromSuperview()
            lineupView = nil
        }
    }

    func showError(_ message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("error_title", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("ok_button", comment: ""),
                style: .default
            ))
        present(alert, animated: true)
    }
}
