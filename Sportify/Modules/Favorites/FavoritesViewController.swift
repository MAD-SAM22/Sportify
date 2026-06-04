//
//  FavoritesViewController.swift
//  Sportify
//
//  Created by Osama Hosam on 23/05/2026.
//

import Kingfisher
import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyTitleLabel: UILabel!
    @IBOutlet weak var emptySubtitleLabel: UILabel!

    var presenter: FavoritesPresenterProtocol!
    private var favorites: [League] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FavoritesPresenter(view: self)
        setupUI()
        // 1. Localize the Navigation Bar Title
        let localizedFavoriteTitle = NSLocalizedString(
            "favorites_title", comment: "Title for favorites screen")
        setupAppNavigationBar(withTitle: localizedFavoriteTitle)

        // 2. Localize the Tab Bar Item Title
        self.tabBarItem.title = localizedFavoriteTitle
        setupTableView()
        presenter.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    // MARK: - Setup
    private func setupUI() {
        title = NSLocalizedString("favorites_title", comment: "")
        emptySubtitleLabel.text = NSLocalizedString(
            "favorites_empty_msg", comment: "")
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
    }
}

// MARK: - FavoritesViewProtocol
extension FavoritesViewController: FavoritesViewProtocol {

    func showEmptyState() {
        tableView.isHidden = true
        emptyStateView.isHidden = false
    }

    func showFavorites(_ leagues: [League]) {
        self.favorites = leagues
        emptyStateView.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }

    func deleteRow(at index: Int) {
        favorites.remove(at: index)
        tableView.deleteRows(
            at: [IndexPath(row: index, section: 0)], with: .automatic)

        if favorites.isEmpty {
            showEmptyState()
        }
    }

    func navigateToLeagueDetails(with league: League, sport: Sport) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(
            withIdentifier: "LeagueDetailsViewController")
            as? LeagueDetailsViewController
        {
            detailsVC.selectedLeague = league
            detailsVC.selectedSport = sport
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "LeaguesCell", for: indexPath)
            as! LeaguesTableViewCell
        let league = favorites[indexPath.row]

        cell.leagueName.text = league.leagueName

        // Safely unwrap the URL string and create a URL object
        if let logoString = league.leagueLogo, let url = URL(string: logoString)
        {

            // 2. Show a loading spinner while fetching
            cell.leagueImage.kf.indicatorType = .activity

            // 3. Fetch and cache the image
            cell.leagueImage.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo.circle.fill"),  // Fallback if offline and uncached
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage,  // Ensures it saves to disk for offline persistence
                ]
            )
        } else {
            // Fallback if the URL is completely missing
            cell.leagueImage.image = UIImage(systemName: "photo.circle.fill")
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectLeague(at: indexPath.row)
    }

    // Swipe to delete with Reusable Confirmation Alert
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: NSLocalizedString("remove", comment: "")  // Localized "Remove"
        ) { [weak self] _, _, completion in

            self?.showDestructiveAlert(
                title: NSLocalizedString("remove_league_title", comment: ""),
                message: NSLocalizedString("remove_league_msg", comment: ""),
                confirmTitleKey: "remove",  // Passing the key for our updated alert function
                confirmAction: {
                    // Triggered if user taps "Remove"
                    self?.presenter.didDeleteLeague(at: indexPath.row)
                    completion(true)
                },
                cancelAction: {
                    // Triggered if user taps "Cancel"
                    completion(false)
                }
            )
        }

        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
