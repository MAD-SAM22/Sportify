//
//  LeagueDetailsViewController.swift
//  Sportify
//
//  Created by Mina_Wagdy on 22/05/2026.
//

import Kingfisher
import SkeletonView
import UIKit

class LeagueDetailsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!
    var presenter: LeagueDetailsPresenterProtocol!
    var selectedLeague: League?
    var selectedSport: Sport?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the presenter and inject the view (self)
        presenter = LeagueDetailsPresenter(view: self)
        presenter.selectedLeague = selectedLeague
        presenter.selectedSport = selectedSport
        setupNavigationBar()
        setupCollectionView()

        // Tell the presenter the view is ready
        presenter.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Tell the presenter the screen is about to show
        presenter.viewWillAppear()
    }
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        // Immediately delegate the action to the Presenter
        presenter.didTapFavorite()
    }

    private func setupNavigationBar() {
        title = selectedLeague?.leagueName ?? "League Details"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(
            red: 0.08, green: 0.10, blue: 0.18, alpha: 1)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20),
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isHidden = false
    }
}
// MARK: - MVP View Protocol
extension LeagueDetailsViewController: LeagueDetailsViewProtocol {
    func updateFavoriteIcon(isFavorite: Bool) {
        DispatchQueue.main.async {
            let iconName = isFavorite ? "heart.fill" : "heart"
            self.favoriteBarButtonItem.image = UIImage(systemName: iconName)
        }
    }

    func reloadData() {
        // Ensure UI updates happen on the main thread
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func navigateToTeamDetails(with team: Team) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let teamVC = storyboard.instantiateViewController(
            withIdentifier: "TeamDetailsViewController"
        ) as? TeamDetailsViewController {

            // Pass real data fetched via the presenter
            teamVC.selectedTeam = team
            teamVC.sport = selectedSport?.sportName ?? "soccer"

            navigationController?.pushViewController(teamVC, animated: true)
        }
    }
    func showUnfavoriteConfirmationAlert() {
        self.showDestructiveAlert(
            title: "Remove League",
            message:
                "Are you sure you want to remove this league from your favorites?",
            confirmAction: { [weak self] in
                self?.presenter.confirmUnfavorite()
            }
        )
    }
}

// MARK: - UI Setup & Compositional Layout
extension LeagueDetailsViewController {

    private func setupCollectionView() {
        // 1. Register the XIB for the Game Cell.
        // (We do NOT register TeamCell or TabCell here because they are prototype cells in the Storyboard)
        collectionView.register(
            GameCollectionViewCell.nib(),
            forCellWithReuseIdentifier: GameCollectionViewCell.identifier)

        // 2. Assign the layout
        collectionView.collectionViewLayout = createCompositionalLayout()

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] (sectionIndex, layoutEnvironment)
                -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }

            switch sectionIndex {
            case 0:
                return self.createTeamsSection()
            case 1:
                return self.createTabsSection()
            case 2:
                return self.createGamesSection()
            default:
                return nil
            }
        }
    }

    // Section 0: Horizontal Carousel with Scaling & Center Snapping
    private func createTeamsSection() -> NSCollectionLayoutSection {
        // 1. Define the item size
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // 2. Define the group size.
        // We set absolute values here so multiple items fit on the screen at once.
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(80), heightDimension: .absolute(110))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        // 3. Center Snapping behavior
        section.orthogonalScrollingBehavior = .groupPagingCentered

        // 4. The Scaling Animation Logic
        section.visibleItemsInvalidationHandler = {
            (items, offset, environment) in
            // Get the total width of the collection view's bounds
            let containerWidth = environment.container.contentSize.width

            // Calculate the exact X-coordinate of the center of the screen
            let centerX = offset.x + (containerWidth / 2.0)

            for item in items {
                // Calculate how far the item's center is from the screen's center
                let distanceFromCenter = abs(item.frame.midX - centerX)

                // Determine our maximum expected distance (half the screen width)
                let maxDistance = containerWidth / 2.0

                // Calculate the scale.
                // When distance is 0 (dead center), scale is 1.2 (largest).
                // As distance increases, the scale shrinks down to a minimum of 0.7.
                let scale = max(
                    0.7, 1.2 - (distanceFromCenter / maxDistance) * 0.5)

                // Apply the transform to scale the cell
                item.transform = CGAffineTransform(scaleX: scale, y: scale)

                // Optional: You can also adjust opacity based on distance to fade out the side items
                // item.alpha = max(0.5, 1.0 - (distanceFromCenter / maxDistance))
            }
        }

        return section
    }
    // Section 1: Static Tabs Header
    private func createTabsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group takes full width, fixed height of 50
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 16, bottom: 16, trailing: 16)

        return section
    }

    // Section 2: Vertical Games List
    private func createGamesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group takes full width, fixed height of 100 per game card
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 16, trailing: 0)

        return section
    }
}
// MARK: - UICollectionView DataSource
extension LeagueDetailsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        // 1. If we are fetching data, return dummy counts for the skeletons
        if presenter.isLoading {
            switch section {
            case 0: return 5  // Show 5 skeleton teams
            case 1: return 2  // Tabs remain real
            case 2: return 5  // Show 5 skeleton games
            default: return 0
            }
        }

        // 2. Otherwise, return the real counts
        switch section {
        case 0: return presenter.getTeamsCount()
        case 1: return 2
        case 2: return presenter.getGamesCount()
        default: return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "TeamCell", for: indexPath)
                as! TeamCollectionViewCell

            if presenter.isLoading {
                // Show SkeletonView
                cell.showAnimatedGradientSkeleton()
            } else {
                // Hide SkeletonView before assigning real data
                cell.hideSkeleton()

                if let team = presenter.getTeam(at: indexPath.row) {
                    cell.teamNameLabel.text = team.teamName ?? "Unknown"
                    if let logoString = team.teamLogo,
                        let url = URL(string: logoString)
                    {
                        cell.teamLogoImageView.kf.indicatorType = .activity
                        cell.teamLogoImageView.kf.setImage(
                            with: url,
                            placeholder: UIImage(
                                systemName: "photo.circle.fill"))
                    } else {
                        cell.teamLogoImageView.image = UIImage(
                            systemName: "photo.circle.fill")
                    }
                }
            }
            return cell

        case 1:
            // Tabs don't need skeleton loaders
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "TabControlCell", for: indexPath)
                as! TabControlCollectionViewCell
            cell.configure(title: indexPath.row == 0 ? "Recent" : "Upcoming")

            if indexPath.row == presenter.getSelectedTabIndex() {
                collectionView.selectItem(
                    at: indexPath, animated: false, scrollPosition: [])
            }
            return cell

        case 2:
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: GameCollectionViewCell.identifier,
                    for: indexPath) as! GameCollectionViewCell

            if presenter.isLoading {
                // Show SkeletonView
                cell.showAnimatedGradientSkeleton()
            } else {
                // Hide SkeletonView before assigning real data
                cell.hideSkeleton()

                if let game = presenter.getGame(at: indexPath.row) {
                    let matchState = presenter.getCurrentMatchState(
                        for: indexPath.row)
                    cell.configure(
                        homeName: game.eventHomeTeam ?? "Home",
                        homeImageURL: game.homeTeamLogo ?? "",
                        awayName: game.eventAwayTeam ?? "Away",
                        awayImageURL: game.awayTeamLogo ?? "",
                        date: game.eventDate ?? "",
                        time: game.eventTime ?? "",
                        state: matchState
                    )
                }
            }
            return cell

        default:
            return UICollectionViewCell()
        }
    }
}
// MARK: - UICollectionView Delegate
extension LeagueDetailsViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
    ) {
        switch indexPath.section {
        case 0:
            //  1. When a team in Section 0 is tapped, notify the presenter
            presenter.didSelectTeam(at: indexPath.row)

        case 1:
            // Tell the presenter the user tapped a tab
            presenter.didSelectTab(index: indexPath.row)

        default:
            break
        }
    }
}

extension UIViewController {
    func showDestructiveAlert(title: String, message: String, confirmAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Remove", style: .destructive) { _ in
            confirmAction()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        // FIX: Changed 'bundle: nil' to 'completion: nil'
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
