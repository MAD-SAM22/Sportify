//
//  ViewController.swift
//  Sportify
//
//  Created by Osama Hosam on 19/05/2026.
//


import UIKit

class SportsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var presenter: SportsPresenterProtocol!
    private var sports: [SportsHome] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = SportsPresenter(view: self)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 12
            layout.minimumLineSpacing = 16
        }

        presenter.viewDidLoad()
    }
}

// MARK: - SportsViewProtocol
extension SportsViewController: SportsViewProtocol {

    func showSports(_ sports: [SportsHome]) {
        self.sports = sports
        collectionView.reloadData()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func navigateToLeagues(with sport: SportsHome) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let leaguesVC = storyboard.instantiateViewController(withIdentifier: "LeaguesViewController") as? LeaguesViewController {
            leaguesVC.selectedSport = sport
            navigationController?.pushViewController(leaguesVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SportsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSportsCell", for: indexPath) as! SportsCollectionViewCell
        let sport = sports[indexPath.item]
        cell.sportLabel.text = sport.name
        cell.sportImageView.image = UIImage(named: sport.imageName)
        return cell
    }
}

extension SportsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectSport(at: indexPath.item)
    }
}

extension SportsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideInset: CGFloat = 12
        let gap: CGFloat = 12
        let availableWidth = collectionView.frame.width - (sideInset * 2) - gap
        let side = availableWidth / 2
        return CGSize(width: side, height: side * 1.3)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
