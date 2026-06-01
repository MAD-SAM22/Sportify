//
//  GameCollectionViewCell.swift
//  Sportify
//
//  Created by Mina_Wagdy on 22/05/2026.
//
//  GameCollectionViewCell.swift
//  Sportify

import UIKit
import SkeletonView
import Kingfisher

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

    static let identifier = "GameCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "GameCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupSkeleton()
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Circular images
        homeTeamImageView.layer.cornerRadius = 25
        homeTeamImageView.clipsToBounds = true

        awayTeamImageView.layer.cornerRadius = 25
        awayTeamImageView.clipsToBounds = true
    }

    // MARK: - Configure with Event
    func configure(with event: Event, state: MatchState) {
        homeTeamNameLabel.text = event.eventHomeTeam ?? "Home"
        awayTeamNameLabel.text = event.eventAwayTeam ?? "Away"
        dateLabel.text         = event.eventDate     ?? ""
        timeLabel.text         = event.eventTime     ?? ""

        loadImage(from: event.homeTeamLogo, into: homeTeamImageView)
        loadImage(from: event.awayTeamLogo, into: awayTeamImageView)

        switch state {
        case .recent(let score):
            scoreOrVsLabel.text       = score
            matchStatusLabel.text     = "FT"
            matchStatusLabel.isHidden = false
        case .upcoming:
            scoreOrVsLabel.text       = "VS"
            matchStatusLabel.isHidden = true
        }
    }

    // MARK: - Kingfisher
    private func loadImage(from urlString: String?, into imageView: UIImageView) {
        guard let urlString = urlString,
              !urlString.isEmpty,
              let url = URL(string: urlString) else {
            imageView.image = UIImage(systemName: "shield.fill")
            imageView.tintColor = .systemGray
            return
        }

        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "shield.fill"),
            options: [.transition(.fade(0.3)), .cacheOriginalImage]
        )
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        homeTeamImageView.kf.cancelDownloadTask()
        awayTeamImageView.kf.cancelDownloadTask()
        homeTeamImageView.image = nil
        awayTeamImageView.image = nil
        matchStatusLabel.isHidden = false
    }

    // MARK: - Skeleton
    private func setupSkeleton() {
        isSkeletonable = true
        cardBackgroundView.isSkeletonable = true

        [homeTeamImageView, homeTeamNameLabel,
         awayTeamImageView, awayTeamNameLabel,
         scoreOrVsLabel, matchStatusLabel,
         dateLabel, timeLabel].forEach {
            $0?.isSkeletonable = true
        }

        homeTeamNameLabel.skeletonTextNumberOfLines = 1
        awayTeamNameLabel.skeletonTextNumberOfLines = 1
        scoreOrVsLabel.skeletonTextNumberOfLines    = 1
    }
}
