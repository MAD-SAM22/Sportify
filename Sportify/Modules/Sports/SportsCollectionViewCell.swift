//
//  SportsCollectionViewCell.swift
//  Sportify
//
//  Created by Osama Hosam on 20/05/2026.
//

import UIKit


class SportsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var sportLabel: UILabel!

    override func awakeFromNib() {
            super.awakeFromNib()

            // Bind the cell's background to your dynamic asset catalog color
            backgroundColor = UIColor(named: "Card_Background")
            
            // Round the entire cell
            layer.cornerRadius = 14
            layer.masksToBounds = false

            
            layer.shadowColor = UIColor.black.cgColor
            
            
            layer.shadowOpacity = 0.12 // Kept lower and subtle for a premium, clean look
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowRadius = 8

            // Image fills the cell completely
            sportImageView.layer.cornerRadius = 14
            sportImageView.layer.masksToBounds = true
            sportImageView.contentMode = .scaleAspectFill

            // Style the label dynamically to adapt to light and dark
            sportLabel.textColor = UIColor(named: "Text_Color")
            sportLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            sportLabel.textAlignment = .center

            // Clear any old static clip configs
            sportLabel.backgroundColor = .clear
            sportLabel.layer.cornerRadius = 0
            sportLabel.clipsToBounds = false
        }
}
