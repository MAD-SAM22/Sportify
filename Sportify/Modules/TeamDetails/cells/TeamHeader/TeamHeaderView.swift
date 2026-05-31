//
//  TeamHeaderView.swift
//  Sportify
//
//  Created by Osama Hosam on 25/05/2026.
//

import Kingfisher
import SkeletonView
import UIKit

class TeamHeaderView: UIView {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!

    static func loadFromNib() -> TeamHeaderView {
        return Bundle.main.loadNibNamed("TeamHeaderView", owner: nil)![0]
            as! TeamHeaderView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupSkeleton()
    }

    private func setupUI() {
        // Banner
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        bannerImageView.layer.cornerRadius = 16

        // Logo
        teamLogoImageView.layer.cornerRadius = 30
        teamLogoImageView.clipsToBounds = true
        teamLogoImageView.layer.borderWidth = 2
        teamLogoImageView.layer.borderColor =
            UIColor.white.withAlphaComponent(0.3).cgColor

        // Name
        teamNameLabel.textColor = .white
        teamNameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        teamNameLabel.textAlignment = .center
    }
    private func setupSkeleton() {
        self.isSkeletonable = true
        bannerImageView.isSkeletonable = true
        teamLogoImageView.isSkeletonable = true
        teamNameLabel.isSkeletonable = true
        teamNameLabel.skeletonTextNumberOfLines = 1
    }
    func configure(teamName: String, bannerImage: UIImage?, logoURL: String?) {
        teamNameLabel.text = teamName
        bannerImageView.image = bannerImage ?? UIImage(named: "team_detail_bg")

        // 3. Use Kingfisher to load the URL!
        let placeholder = UIImage(systemName: "shield.fill")

        if let urlString = logoURL, let url = URL(string: urlString) {
            teamLogoImageView.kf.indicatorType = .activity
            teamLogoImageView.kf.setImage(with: url, placeholder: placeholder)
        } else {
            teamLogoImageView.image = placeholder
        }
    }
}
