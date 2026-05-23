//
//  LeaguesTableViewCell.swift
//  Sportify
//
//  Created by Osama Hosam on 20/05/2026.
//

import UIKit

class LeaguesTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueImage: UIImageView!
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        // Cell background
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = UIColor(red: 0.10, green: 0.13, blue: 0.25, alpha: 1)
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true

        // Circular image
        leagueImage.layer.cornerRadius = 25
        leagueImage.layer.masksToBounds = true
        leagueImage.contentMode = .scaleAspectFill
        leagueImage.layer.borderWidth = 1.5
        leagueImage.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor

        // Label
        leagueName.textColor = .white
        leagueName.font = UIFont.boldSystemFont(ofSize: 16)
        leagueName.numberOfLines = 1

        // Chevron inside the card
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = UIColor.white.withAlphaComponent(0.4)
        chevronImageView.contentMode = .scaleAspectFit

        accessoryView = nil
        accessoryType = .none
    }

    // Card spacing between rows
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: 6, left: 12, bottom: 6, right: 12
        ))
    }
}
