//
//  GameCollectionViewCell.swift
//  Sportify
//
//  Created by Mina_Wagdy on 22/05/2026.
//

import UIKit
import SkeletonView
import Kingfisher
// Using an enum for state management keeps the code clean and avoids boolean toggles
enum MatchState {
    case recent(score: String)
    case upcoming
}

class GameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var scoreOrVsLabel: UILabel!
    @IBOutlet weak var matchStatusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // We register XIB cells using their nib, so this static identifier is handy
    static let identifier = "GameCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "GameCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupSkeleton()
    }

    private func setupUI() {
        cardBackgroundView.layer.cornerRadius = 20  // Gives that nice pill-like shape
        cardBackgroundView.clipsToBounds = true

        homeTeamImageView.contentMode = .scaleAspectFit
        awayTeamImageView.contentMode = .scaleAspectFit
    }

        
        func configure(homeName: String, homeImageURL: String, awayName: String, awayImageURL: String, date: String, time: String, state: MatchState) {
            
            homeTeamNameLabel.text = homeName
            awayTeamNameLabel.text = awayName
            dateLabel.text = date
            timeLabel.text = time
            
            // Setup Home Image
            if let homeUrl = URL(string: homeImageURL) {
                homeTeamImageView.kf.indicatorType = .activity
                homeTeamImageView.kf.setImage(with: homeUrl, placeholder: UIImage(systemName: "shield"))
            }
            
            // Setup Away Image
            if let awayUrl = URL(string: awayImageURL) {
                awayTeamImageView.kf.indicatorType = .activity
                awayTeamImageView.kf.setImage(with: awayUrl, placeholder: UIImage(systemName: "shield"))
            }
            
            // Handle MatchState UI (Score vs VS label, etc.)
            switch state {
            case .recent(let score):
                scoreOrVsLabel.text = score
                scoreOrVsLabel.isHidden = false
            case .upcoming:
                scoreOrVsLabel.text = "VS"
                scoreOrVsLabel.isHidden = false
            }
        }
    private func setupSkeleton() {
        self.isSkeletonable = true
        cardBackgroundView.isSkeletonable = true

        let viewsToSkeleton: [UIView] = [
            homeTeamImageView, homeTeamNameLabel, awayTeamImageView,
            awayTeamNameLabel, scoreOrVsLabel, matchStatusLabel, dateLabel,
            timeLabel,
        ]

        viewsToSkeleton.forEach { $0.isSkeletonable = true }

        // Optimize text skeleton appearance
        homeTeamNameLabel.skeletonTextNumberOfLines = 1
        awayTeamNameLabel.skeletonTextNumberOfLines = 1
        scoreOrVsLabel.skeletonTextNumberOfLines = 1
    }

}
