//
//  LeaguesViewController.swift
//  Sportify
//
//  Created by Osama Hosam on 20/05/2026.
//

import UIKit
import SkeletonView
class LeaguesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var presenter: LeaguesPresenterProtocol!
    var selectedSport: Sport?
    private var leagues: [League] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = LeaguesPresenter(view: self)
        presenter.selectedSport = selectedSport

        setupTableView()
        setupNavigationBar()

        presenter.viewDidLoad()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        view.backgroundColor = UIColor(red: 0.08, green: 0.10, blue: 0.18, alpha: 1)
    }

    private func setupNavigationBar() {
        title = selectedSport?.sportName ?? "Leagues"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.08, green: 0.10, blue: 0.18, alpha: 1)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
}

extension LeaguesViewController: LeaguesViewProtocol {

    func showLeagues(_ leagues: [League]) {
        self.leagues = leagues
        tableView.reloadData()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func navigateToLeagueDetails(with league: League , sport:Sport ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as? LeagueDetailsViewController {
            detailsVC.selectedLeague = league
            detailsVC.selectedSport = sport
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

extension LeaguesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Show 6 dummy cells while loading, otherwise real count
        return presenter.isLoading ? 6 : leagues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaguesCell", for: indexPath) as! LeaguesTableViewCell
        
        if presenter.isLoading {
            // 1. Trigger the official library animation
            cell.showAnimatedGradientSkeleton()
        } else {
            // 2. Hide the skeleton layer and push the real data
            cell.hideSkeleton()
            cell.configure(with: leagues[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Prevent crashes by ignoring taps on skeleton cells
        guard !presenter.isLoading else { return }
        
        presenter.didSelectLeague(at: indexPath.row)
    }
}
