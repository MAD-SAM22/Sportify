//
//  TeamCollectionViewCell.swift
//  Sportify
//
//  Created by Mina_Wagdy on 22/05/2026.
//

import SkeletonView
import UIKit

class TeamCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupSkeleton()

        // Optional: Add a placeholder background color so you can see it before data loads
        teamLogoImageView.backgroundColor = .systemGray6
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        teamLogoImageView.layer.cornerRadius = teamLogoImageView.frame.width / 2
        teamLogoImageView.clipsToBounds = true
    }
    private func setupSkeleton() {
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true

        teamLogoImageView.isSkeletonable = true
        teamNameLabel.isSkeletonable = true

        teamNameLabel.skeletonTextNumberOfLines = 1
    }
    
    // We will call this from the View Controller later to inject static data
    func configure(teamName: String) {
        teamNameLabel.text = teamName
        teamLogoImageView.image = UIImage(named: "placeholder")
    }
}
