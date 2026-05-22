//
//  TabControlCollectionViewCell.swift
//  Sportify
//
//  Created by Mina_Wagdy on 22/05/2026.
//

import UIKit

class TabControlCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    override func awakeFromNib() {
            super.awakeFromNib()
            setupUI()
        }
        
    private func setupUI() {
        // Default state
        titleLabel.textColor = .secondaryLabel
        indicatorView.isHidden = true
    }
        
        // This built-in property automatically updates when the collection view changes selection
        override var isSelected: Bool {
            didSet {
                titleLabel.textColor = isSelected ? .label : .secondaryLabel
                indicatorView.isHidden = !isSelected
                
                // Optional: Add a subtle spring animation for a better UX
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.indicatorView.transform = self.isSelected ? .identity : CGAffineTransform(scaleX: 0.1, y: 1.0)
                }, completion: nil)
            }
        }
        
        func configure(title: String) {
            titleLabel.text = title
        }
}
