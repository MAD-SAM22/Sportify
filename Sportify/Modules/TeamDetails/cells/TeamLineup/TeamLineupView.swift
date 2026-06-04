//
//  TeamLineupView.swift
//  Sportify
//
//  Created by Osama Hosam on 25/05/2026.
//
import Kingfisher

import SkeletonView
import UIKit

class TeamLineupView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pitchView: UIView!
    @IBOutlet weak var stackView: UIStackView!  // rows of players on pitch
    
    static func loadFromNib() -> TeamLineupView {
        return Bundle.main.loadNibNamed("TeamLineupView", owner: nil)![0]
        as! TeamLineupView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupSkeleton()
    }
    
    private func setupUI() {
        titleLabel.text = "Team Lineup"
        titleLabel.textColor = UIColor(named: "Text_Color") ?? .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        //green bright
        pitchView.backgroundColor = UIColor(named: "Secondary_Card") ?? UIColor(red: 0.12, green: 0.16, blue: 0.28, alpha: 1)
        pitchView.layer.cornerRadius = 16
        pitchView.layer.masksToBounds = true
    }
    private func setupSkeleton() {
        self.isSkeletonable = true
        pitchView.isSkeletonable = true
    }
    
    // formations: array of rows, each row is array of player names
    func configure(formation: [[(name: String, imageURL: String?)]]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for row in formation {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .equalSpacing
            rowStack.alignment = .center
            rowStack.spacing = 8

            for player in row {
                let playerView = createPlayerDot(name: player.name, imageURL: player.imageURL)
                rowStack.addArrangedSubview(playerView)
            }

            stackView.addArrangedSubview(rowStack)
        }
    }

    private func createPlayerDot(name: String, imageURL: String?) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(named: "Card_Background") ?? UIColor(red: 0.10, green: 0.13, blue: 0.25, alpha: 1)
        imageView.tintColor = UIColor(named: "Accent_Blue") ?? UIColor(red: 0.23, green: 0.51, blue: 0.96, alpha: 1)

        // Load image via Kingfisher or fallback to placeholder
        if let urlString = imageURL, !urlString.isEmpty, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.circle.fill"))
        } else {
            imageView.image = UIImage(systemName: "person.circle.fill")
        }

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = name
        label.textColor = UIColor(named: "Text_Color") ?? .white
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true

        container.addSubview(imageView)
        container.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),            label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            container.widthAnchor.constraint(equalToConstant: 50),
        ])

        return container
    }
}
