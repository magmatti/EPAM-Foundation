import Foundation
import UIKit

class TVShowCell: UITableViewCell {
    static let identifier = "TVShowCell"
    
    private let posterImageView = UIImageView()
    private let nameLabel = UILabel()
    private let detailsLabel = UILabel()
    private let overviewLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        detailsLabel.font = UIFont.systemFont(ofSize: 14)
        detailsLabel.numberOfLines = 0
        overviewLabel.font = UIFont.systemFont(ofSize: 12)
        overviewLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [nameLabel, detailsLabel, overviewLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(posterImageView)
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),

            stack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with tvShow: TVShow) {
        nameLabel.text = tvShow.name
        detailsLabel.text = """
        First Air Date: \(tvShow.firstAirDate)
        Rating: \(tvShow.voteAverage)
        Countries: \(tvShow.originCountry.joined(separator: ", "))
        Popularity: \(tvShow.popularity)
        """
        overviewLabel.text = tvShow.overview

        if let path = tvShow.posterPath {
            let urlString = "https://image.tmdb.org/t/p/w500\(path)"
            posterImageView.loadImage(from: urlString)
        }
    }
}

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}
