//
//  LeaguesTableViewCell.swift
//  Sportify
//
//  Created by Osama Hosam on 20/05/2026.
//

import UIKit

struct League{
var    name : String
var    image: UIImage
}
class LeaguesTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueImage: UIImageView!
    @IBOutlet weak var leagueName: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Dark background on cell
        backgroundColor = .clear
        contentView.backgroundColor = UIColor(red: 0.10, green: 0.13, blue: 0.25, alpha: 1)

        // Rounded card
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true

        // Circular image
        leagueImage.layer.cornerRadius = 25  // half of 50pt height
        leagueImage.layer.masksToBounds = true
        leagueImage.contentMode = .scaleAspectFill
        leagueImage.layer.borderWidth = 1.5
        leagueImage.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor

        // Label style
        leagueName.textColor = .white
        leagueName.font = UIFont.boldSystemFont(ofSize: 16)
    }

    // spacing between rows
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: 6, left: 12, bottom: 6, right: 12
        ))
    }
}
