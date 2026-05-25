import UIKit

class TeamPlayersView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playersStackView: UIStackView!

    static func loadFromNib() -> TeamPlayersView {
        return Bundle.main.loadNibNamed("TeamPlayersView", owner: nil)![0] as! TeamPlayersView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "Players"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        scrollView.showsHorizontalScrollIndicator = false
    }

    func configure(players: [(name: String, image: UIImage?)]) {
        // Clear existing players
        playersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for player in players {
            let playerView = createPlayerView(name: player.name, image: player.image)
            playersStackView.addArrangedSubview(playerView)
        }
    }

    private func createPlayerView(name: String, image: UIImage?) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        // Circular image
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray4
        imageView.image = image ?? UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .white

        // Name label
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = name
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        label.numberOfLines = 2

        container.addSubview(imageView)
        container.addSubview(label)

        NSLayoutConstraint.activate([
            // Image
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),

            // Label
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            container.widthAnchor.constraint(equalToConstant: 60)
        ])

        return container
    }
}
