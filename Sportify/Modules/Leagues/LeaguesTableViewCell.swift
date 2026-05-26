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
        backgroundColor = .clear

 
        // Label
        leagueName.numberOfLines = 1



        // Configure the shadow on the contentView
        contentView.layer.masksToBounds = false // Crucial: Allows the shadow to bleed outside the view
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.4 // The darkness of the shadow (0.0 to 1.0)
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4) // Pushes the shadow 4 points down
        contentView.layer.shadowRadius = 5 // The blur amount
        
 
    }

    // Card spacing between rows
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: 0, left: 0, bottom: 10, right: 0
        ))
    }
}
