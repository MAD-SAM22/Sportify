//
//  LeaguesViewController.swift
//  Sportify
//
//  Created by Osama Hosam on 20/05/2026.
//

import UIKit

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
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

extension LeaguesViewController: UITableViewDataSource , UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaguesCell", for: indexPath) as! LeaguesTableViewCell
        let league = leagues[indexPath.row]
        cell.leagueName.text = league.leagueName
        cell.leagueImage.image = UIImage(named: league.leagueLogo ?? "")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectLeague(at: indexPath.row)
    }
}
