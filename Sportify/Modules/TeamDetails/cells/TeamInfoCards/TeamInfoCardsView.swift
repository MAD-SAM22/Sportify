//
//  TeamInfoCardsView.swift
//  Sportify
//
//  Created by Osama Hosam on 25/05/2026.
//

import UIKit

class TeamInfoCardsView: UIView {

    @IBOutlet weak var countryIconLabel: UIImageView!
    @IBOutlet weak var countryValueLabel: UILabel!
    @IBOutlet weak var stadiumIconLabel: UIImageView!
    @IBOutlet weak var stadiumValueLabel: UILabel!
    @IBOutlet weak var foundedIconLabel: UIImageView!
    @IBOutlet weak var foundedValueLabel: UILabel!
    @IBOutlet weak var countryCard: UIView!
    @IBOutlet weak var stadiumCard: UIView!
    @IBOutlet weak var foundedCard: UIView!

    static func loadFromNib() -> TeamInfoCardsView {
        return Bundle.main.loadNibNamed("TeamInfoCardsView", owner: nil)![0] as! TeamInfoCardsView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        // Matches the premium #1F1F1F background look from your reference mockup
        [countryCard, stadiumCard, foundedCard].forEach { card in
            card?.backgroundColor = UIColor(red: 0.12, green: 0.15, blue: 0.25, alpha: 1)
            card?.layer.cornerRadius = 16
            card?.layer.masksToBounds = true
        }

        [countryValueLabel, stadiumValueLabel, foundedValueLabel].forEach { label in
            label?.textColor = .white
            label?.font = UIFont.boldSystemFont(ofSize: 16)
            label?.textAlignment = .center
            label?.numberOfLines = 2
        }

        // Configures system SF Symbol tinting uniformly
        [countryIconLabel, stadiumIconLabel, foundedIconLabel].forEach { iconView in
            iconView?.tintColor = .white
            iconView?.contentMode = .scaleAspectFit
        }
    }

    func configure(country: String, stadium: String, founded: String) {
        countryValueLabel.text = country
        stadiumValueLabel.text = stadium
        foundedValueLabel.text = founded
    }
}
