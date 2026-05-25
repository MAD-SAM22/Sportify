//
//  TeamHeaderView.swift
//  Sportify
//
//  Created by Osama Hosam on 25/05/2026.
//


import UIKit

class TeamHeaderView: UIView {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!

    static func loadFromNib() -> TeamHeaderView {
        return Bundle.main.loadNibNamed("TeamHeaderView", owner: nil)![0] as! TeamHeaderView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
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
        teamLogoImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor

        // Name
        teamNameLabel.textColor = .white
        teamNameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        teamNameLabel.textAlignment = .center
    }

    func configure(teamName: String, bannerImage: UIImage?, logoImage: UIImage?) {
        teamNameLabel.text = teamName
        bannerImageView.image = bannerImage ?? UIImage(named: "team_detail_bg")
        teamLogoImageView.image = logoImage ?? UIImage(named: "bayern_logo")
    }
}
