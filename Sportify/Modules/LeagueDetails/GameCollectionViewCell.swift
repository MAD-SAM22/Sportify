//
//  GameCollectionViewCell.swift
//  Sportify
//
//  Created by Mina_Wagdy on 22/05/2026.
//

import UIKit
import SkeletonView

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
            
            // For our current static data phase:
            homeTeamImageView.image = UIImage(named: "bayern_logo")
            awayTeamImageView.image = UIImage(named: "bayern_logo")
            
            /* Later, when we hook up the API and use Alamofire/Kingfisher,
            you will swap the two lines above for something like:
            
            let homeUrl = URL(string: homeImageName)
            homeTeamImageView.kf.setImage(with: homeUrl)
            */
            
            switch state {
            case .recent(let score):
                scoreOrVsLabel.text = score
                matchStatusLabel.text = "FT"
                matchStatusLabel.isHidden = false
            case .upcoming:
                scoreOrVsLabel.text = "VS"
                matchStatusLabel.isHidden = true
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
