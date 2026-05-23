//
//  FavoritesViewController.swift
//  Sportify
//
//  Created by Osama Hosam on 23/05/2026.
//

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
        setupTableView()

        presenter.viewDidLoad()
    }

    // MARK: - Setup
    private func setupUI() {
        title = "Favorites"
        view.backgroundColor = UIColor(red: 0.08, green: 0.10, blue: 0.18, alpha: 1)

        // Style empty state labels (or do this in Storyboard)
        emptyTitleLabel.text = "No favorites yet"
        emptyTitleLabel.textColor = .white
        emptyTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)

        emptySubtitleLabel.text = "Tap the heart icon on any league\nto save it here for quick access."
        emptySubtitleLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        emptySubtitleLabel.numberOfLines = 2

        emptyImageView.image = UIImage(systemName: "heart.slash.circle")
        emptyImageView.tintColor = UIColor.white.withAlphaComponent(0.3)
        emptyImageView.contentMode = .scaleAspectFit
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
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)

        if favorites.isEmpty {
            showEmptyState()
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaguesCell", for: indexPath) as! LeaguesTableViewCell
        let league = favorites[indexPath.row]
        cell.leagueName.text = league.name
        cell.leagueImage.image = UIImage(named: league.badgeImageName)



        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectLeague(at: indexPath.row)
    }

    // Swipe to delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, completion in
            self?.presenter.didDeleteLeague(at: indexPath.row)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
