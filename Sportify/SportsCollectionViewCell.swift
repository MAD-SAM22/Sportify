//
//  SportsCollectionViewCell.swift
//  Sportify
//
//  Created by Osama Hosam on 20/05/2026.
//

import UIKit

struct SportsHome {
    let name: String
    let imageName: String
}

class SportsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var sportLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Round the entire cell
        layer.cornerRadius = 14
        layer.masksToBounds = false

        // Shadow on the cell layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6

        // Image fills the cell completely
        sportImageView.layer.cornerRadius = 14
        sportImageView.layer.masksToBounds = true
        sportImageView.contentMode = .scaleAspectFill
//        sportImageView.clipsToBounds = true

        // Style the label to sit as an overlay at the bottom
        sportLabel.textColor = .white
        sportLabel.font = UIFont.boldSystemFont(ofSize: 17)
        sportLabel.textAlignment = .center

        // Dark gradient-like background behind the label
//        sportLabel.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        sportLabel.layer.cornerRadius = 0  // flush with cell bottom
        sportLabel.clipsToBounds = true
    }
}
