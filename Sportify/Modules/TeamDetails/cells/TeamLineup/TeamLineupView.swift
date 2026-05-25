//
//  TeamLineupView.swift
//  Sportify
//
//  Created by Osama Hosam on 25/05/2026.
//


import UIKit

class TeamLineupView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pitchView: UIView!
    @IBOutlet weak var stackView: UIStackView!  // rows of players on pitch

    static func loadFromNib() -> TeamLineupView {
        return Bundle.main.loadNibNamed("TeamLineupView", owner: nil)![0] as! TeamLineupView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        titleLabel.text = "Team Lineup"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)

        // Green pitch background
        pitchView.backgroundColor = UIColor(red: 0.13, green: 0.55, blue: 0.13, alpha: 1)
        pitchView.layer.cornerRadius = 16
        pitchView.layer.masksToBounds = true
    }

    // formations: array of rows, each row is array of player names
    func configure(formation: [[String]], playerImages: [UIImage?]) {
        // Clear existing rows
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        var playerIndex = 0
        for row in formation {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .equalSpacing
            rowStack.alignment = .center
            rowStack.spacing = 8

            for name in row {
                let playerView = createPlayerDot(name: name,
                    image: playerIndex < playerImages.count ? playerImages[playerIndex] : nil)
                rowStack.addArrangedSubview(playerView)
                playerIndex += 1
            }

            stackView.addArrangedSubview(rowStack)
        }
    }

    private func createPlayerDot(name: String, image: UIImage?) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray4
        imageView.image = image ?? UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .white

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = name
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .center
        label.numberOfLines = 2

        container.addSubview(imageView)
        container.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            container.widthAnchor.constraint(equalToConstant: 50)
        ])

        return container
    }
}