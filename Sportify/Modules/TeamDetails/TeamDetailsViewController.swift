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
        view.backgroundColor = UIColor(named: "Background") ?? UIColor(red: 0.08, green: 0.10, blue: 0.18, alpha: 1)
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
        guard lineupView == nil else { return }  // prevent adding twice
        let lineup = TeamLineupView.loadFromNib()
        lineup.translatesAutoresizingMaskIntoConstraints = false
        lineup.configure(
            formation: presenter.getFormation(),
            playerImages: []
        )
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

    func showTeamDetails(_ team: Team) {
        // Update title
        title = team.teamName ?? "Team Details"

        // Header - Now passing the URL string directly!
        headerView.configure(
            teamName: team.teamName ?? "Team Name",
            bannerImage: UIImage(named: "team_banner"),
            logoURL: team.teamLogo
        )

        // Info cards
        infoCardsView.configure(
            country: team.teamCountry ?? "N/A",
            stadium: team.venueName ?? "N/A",
            founded: team.teamFounded ?? "N/A"
        )

        // About - API doesn't provide, so keeping the placeholder
        aboutView.configure(
            description:
                "A historic team from \(team.teamCountry ?? "unknown country"), founded in \(team.teamFounded ?? "N/A"), playing at \(team.venueName ?? "N/A")."
        )
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
            title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
