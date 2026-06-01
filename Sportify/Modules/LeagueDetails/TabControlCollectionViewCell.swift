//
//  TabControlCollectionViewCell.swift
//  Sportify
//
//  Created by Mina_Wagdy on 22/05/2026.
//
//  TabControlCollectionViewCell.swift
//  Sportify

import UIKit

class TabControlCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // Label — default unselected
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.4)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center

        // Indicator — blue accent, starts hidden
        indicatorView.backgroundColor = UIColor(red: 0.20, green: 0.60, blue: 1.0, alpha: 1)
        indicatorView.layer.cornerRadius = 1.5
        indicatorView.isHidden = true
        indicatorView.transform = CGAffineTransform(scaleX: 0.1, y: 1.0)
    }

    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected
                ? .white
                : UIColor.white.withAlphaComponent(0.4)

            titleLabel.font = isSelected
                ? UIFont.boldSystemFont(ofSize: 15)
                : UIFont.systemFont(ofSize: 15)

            indicatorView.isHidden = !isSelected

            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: .curveEaseInOut
            ) {
                self.indicatorView.transform = self.isSelected
                    ? .identity
                    : CGAffineTransform(scaleX: 0.1, y: 1.0)
            }
        }
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
