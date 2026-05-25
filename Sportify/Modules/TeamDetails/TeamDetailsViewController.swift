//
//  TeamDetailsViewController.swift
//  Sportify
//
//  Created by Osama Hosam on 25/05/2026.
//

import UIKit

class TeamDetailsViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentStackView: UIStackView!

    // MARK: - Properties
    
    var selectedTeam: Team?
    
    var sport: String = "Soccer"

    // NIB Views
    
    private var headerView: TeamHeaderView!
    
    private var infoCardsView: TeamInfoCardsView!
    
    private var aboutView: TeamAboutView!
    
    private var playersView: TeamPlayersView!
    
    private var lineupView: TeamLineupView!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Dummy Data
        selectedTeam = Team(
            
            teamKey: 1,
            
            teamName: "London Lions FC",
            
            teamLogo: "team_logo",
            
            teamCountry: "England",
            
            teamFounded: "1905",
            
            venueName: "Stamford Bridge"
        )

        setupUI()
        
        setupNavigationBar()
        
        buildUI()
    }

    // MARK: - Setup
    
    private func setupUI() {
        
        view.backgroundColor = UIColor(
            red: 0.08,
            green: 0.10,
            blue: 0.18,
            alpha: 1
        )
        
        scrollView.backgroundColor = .clear
        
        scrollView.showsVerticalScrollIndicator = false

        contentStackView.axis = .vertical
        
        contentStackView.spacing = 16
        
        contentStackView.alignment = .fill
        
        contentStackView.distribution = .fill
    }

    private func setupNavigationBar() {
        
        title = selectedTeam?.teamName ?? "Team Details"

        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor(
            red: 0.08,
            green: 0.10,
            blue: 0.18,
            alpha: 1
        )
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .white
    }

    // MARK: - Build UI from NIBs
    
    private func buildUI() {
        
        addHeaderView()
        
        addInfoCardsView()
        
        addAboutView()
        
        addPlayersView()

        // ✅ Only show lineup for team sports
        if shouldShowLineup(for: sport) {
            
            addLineupView()
        }
    }

    // MARK: - Add Each NIB Section

    private func addHeaderView() {
        
        headerView = TeamHeaderView.loadFromNib()
        
        headerView.configure(
            teamName: selectedTeam?.teamName ?? "Team Name",
            
            bannerImage: UIImage(named: "team_banner"),
            
            logoImage: UIImage(
                named: selectedTeam?.teamLogo ?? ""
            )
        )
        
        contentStackView.addArrangedSubview(headerView)
    }

    private func addInfoCardsView() {
        
        infoCardsView = TeamInfoCardsView.loadFromNib()
        
        infoCardsView.configure(
            country: selectedTeam?.teamCountry ?? "N/A",
            
            stadium: selectedTeam?.venueName ?? "N/A",
            
            founded: selectedTeam?.teamFounded ?? "N/A"
        )
        
        contentStackView.addArrangedSubview(infoCardsView)
    }

    private func addAboutView() {
        
        aboutView = TeamAboutView.loadFromNib()
        
        aboutView.configure(
            description:
            "A historic powerhouse in professional sports with a rich legacy of championships and legendary players."
        )
        
        contentStackView.addArrangedSubview(aboutView)
    }

    private func addPlayersView() {
        
        playersView = TeamPlayersView.loadFromNib()
        
        playersView.configure(players: [
            
            (
                name: "John Smith",
                image: UIImage(named: "player1")
            ),
            
            (
                name: "Emily Jones",
                image: UIImage(named: "player2")
            ),
            
            (
                name: "David Lee",
                image: UIImage(named: "player3")
            ),
            
            (
                name: "Chris Green",
                image: UIImage(named: "player4")
            ),
            
            (
                name: "Anna White",
                image: UIImage(named: "player5")
            )
        ])
        
        contentStackView.addArrangedSubview(playersView)
    }

    private func addLineupView() {
        
        lineupView = TeamLineupView.loadFromNib()
        
        lineupView.configure(
            formation: [
                
                ["Goalkeeper"],
                
                [
                    "Defender",
                    "Defender",
                    "Defender",
                    "Defender"
                ],
                
                [
                    "Midfielder",
                    "Midfielder",
                    "Midfielder"
                ],
                
                [
                    "Forward",
                    "Forward",
                    "Forward"
                ]
            ],
            
            playerImages: []
        )
        
        contentStackView.addArrangedSubview(lineupView)
    }

    // MARK: - Lineup Visibility Logic
    
    private func shouldShowLineup(
        for sport: String
    ) -> Bool {
        
        let teamSports = [
            "Soccer",
            "Football",
            "Basketball",
            "Baseball",
            "Hockey"
        ]
        
        return teamSports.contains(sport)
    }
}
