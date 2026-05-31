//
//  LeaguesTableViewCell.swift
//  Sportify
//
//  Created by Osama Hosam on 20/05/2026.
//
//  LeaguesTableViewCell.swift
//  Sportify

import UIKit
import Kingfisher

class LeaguesTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueImage: UIImageView!
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear

        leagueName.numberOfLines = 1

        // shadow under card
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 5
    }

    // Calls from cellForRowAt
    func configure(with league: League) {
        leagueName.text = league.leagueName ?? "Unknown League"

        let placeholder = UIImage(systemName: "shield.fill")

        guard let urlString = league.leagueLogo,
              !urlString.isEmpty,
              let url = URL(string: urlString) else {
            leagueImage.image = placeholder
            return
        }

        leagueImage.kf.setImage(with: url, placeholder: placeholder)
    }
    
    //card spacing between rows
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: 0, left: 0, bottom: 10, right: 0
        ))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        leagueImage.kf.cancelDownloadTask()
        leagueImage.image = nil
    }
}
