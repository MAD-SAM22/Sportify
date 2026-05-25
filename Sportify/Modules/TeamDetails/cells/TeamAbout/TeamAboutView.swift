//
//  TeamAboutView.swift
//  Sportify
//
//  Created by Osama Hosam on 25/05/2026.
//


import UIKit

class TeamAboutView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerCard: UIView!

    static func loadFromNib() -> TeamAboutView {
        return Bundle.main.loadNibNamed("TeamAboutView", owner: nil)![0] as! TeamAboutView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        containerCard.backgroundColor = UIColor(red: 0.10, green: 0.13, blue: 0.22, alpha: 1)
        containerCard.layer.cornerRadius = 16
        containerCard.layer.masksToBounds = true

        titleLabel.text = "About the Team"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)

        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
    }

    func configure(description: String) {
        descriptionLabel.text = description
    }
}