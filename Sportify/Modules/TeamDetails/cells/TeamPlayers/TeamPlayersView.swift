import Kingfisher
import SkeletonView
import UIKit

class TeamPlayersView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playersStackView: UIStackView!

    static func loadFromNib() -> TeamPlayersView {
        return Bundle.main.loadNibNamed("TeamPlayersView", owner: nil)![0]
            as! TeamPlayersView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "Players"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        scrollView.showsHorizontalScrollIndicator = false
        setupSkeleton()
    }

    func configure(players: [(name: String, image: UIImage?)]) {
        // Clear existing players
        playersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for player in players {
            let playerView = createPlayerView(
                name: player.name, image: player.image)
            playersStackView.addArrangedSubview(playerView)
        }
    }
    private func setupSkeleton() {
        playersStackView.isSkeletonable = true
    }
    func setupDummySkeletonViews() {
        playersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Create 5 dummy skeleton views
        for _ in 0..<5 {
            let playerView = createPlayerView(name: "Loading", image: nil)
            playerView.isSkeletonable = true
            playerView.subviews.forEach {
                $0.isSkeletonable = true
                if let label = $0 as? UILabel {
                    label.skeletonTextNumberOfLines = 1
                }
            }
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
            imageView.centerXAnchor.constraint(
                equalTo: container.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),

            // Label
            label.topAnchor.constraint(
                equalTo: imageView.bottomAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            container.widthAnchor.constraint(equalToConstant: 60),
        ])

        return container
    }

    func configureWithURLs(_ urls: [String]) {
        // Find all imageViews inside the stack and load URLs
        for (index, subview) in playersStackView.arrangedSubviews.enumerated() {
            guard index < urls.count else { break }
            if let imageView = subview.subviews.first(where: {
                $0 is UIImageView
            }) as? UIImageView {
                guard let url = URL(string: urls[index]) else { continue }
                imageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "person.circle.fill")
                )
            }
        }
    }
}
