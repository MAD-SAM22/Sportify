//
//  TeamInfoCardsView.swift
//  Sportify
//
//  Created by Osama Hosam on 25/05/2026.
//

import SkeletonView
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
        return Bundle.main.loadNibNamed("TeamInfoCardsView", owner: nil)![0]
            as! TeamInfoCardsView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupSkeleton()
    }

    private func setupUI() {
        let accentColor = UIColor(named: "Accent_Blue") ?? UIColor(red: 0.23, green: 0.51, blue: 0.96, alpha: 1)
        let textThemeColor = UIColor(named: "Text_Color") ?? .white
        let cardBgColor = UIColor(named: "Card_Background") ?? UIColor(red: 0.10, green: 0.13, blue: 0.25, alpha: 1)
        
        [countryCard, stadiumCard, foundedCard].forEach { card in
                    card?.backgroundColor = cardBgColor
                    card?.layer.cornerRadius = 16
                    card?.layer.masksToBounds = true
                }

        [countryValueLabel, stadiumValueLabel, foundedValueLabel].forEach { label in
                    label?.textColor = textThemeColor
                    label?.font = UIFont.boldSystemFont(ofSize: 16)
                    label?.textAlignment = .center
                    label?.numberOfLines = 2
                }

        // Configures system SF Symbol tinting uniformly
        [countryIconLabel, stadiumIconLabel, foundedIconLabel].forEach { iconView in
                    iconView?.tintColor = accentColor
                    iconView?.contentMode = .scaleAspectFit
                }
    }
    private func setupSkeleton() {
        self.isSkeletonable = true
        let elements: [UIView?] = [
            countryCard, stadiumCard, foundedCard,
            countryIconLabel, stadiumIconLabel, foundedIconLabel,
            countryValueLabel, stadiumValueLabel, foundedValueLabel,
        ]

        elements.forEach {
            $0?.isSkeletonable = true
            if let label = $0 as? UILabel {
                label.skeletonTextNumberOfLines = 1
            }
        }
    }

    func configure(country: String, stadium: String, founded: String) {
        countryValueLabel.text = country
        stadiumValueLabel.text = stadium
        foundedValueLabel.text = founded
    }
}
