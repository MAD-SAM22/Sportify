//
//  TeamInfoCardsView.swift
//  Sportify
//
//  Created by Osama Hosam on 25/05/2026.
//


import UIKit

class TeamInfoCardsView: UIView {

    @IBOutlet weak var countryIconLabel: UILabel!
    @IBOutlet weak var countryValueLabel: UILabel!
    @IBOutlet weak var stadiumIconLabel: UILabel!
    @IBOutlet weak var stadiumValueLabel: UILabel!
    @IBOutlet weak var foundedIconLabel: UILabel!
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
        [countryCard, stadiumCard, foundedCard].forEach { card in
            card?.backgroundColor = UIColor(red: 0.12, green: 0.15, blue: 0.25, alpha: 1)
            card?.layer.cornerRadius = 12
            card?.layer.masksToBounds = true
        }

        [countryValueLabel, stadiumValueLabel, foundedValueLabel].forEach { label in
            label?.textColor = .white
            label?.font = UIFont.boldSystemFont(ofSize: 14)
            label?.textAlignment = .center
            label?.numberOfLines = 2
        }

        [countryIconLabel, stadiumIconLabel, foundedIconLabel].forEach { label in
            label?.textColor = UIColor.white.withAlphaComponent(0.6)
            label?.font = UIFont.systemFont(ofSize: 12)
            label?.textAlignment = .center
        }

        // Set icon emojis
        countryIconLabel.text = "🌐\nCountry:"
        stadiumIconLabel.text = "🏟️\nStadium:"
        foundedIconLabel.text = "📅\nFounded:"
    }

    func configure(country: String, stadium: String, founded: String) {
        countryValueLabel.text = country
        stadiumValueLabel.text = stadium
        foundedValueLabel.text = founded
    }
}