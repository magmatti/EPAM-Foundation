import UIKit

class ImageCell: UITableViewCell {
    
    private let imageCellView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        imageCellView.translatesAutoresizingMaskIntoConstraints = false
        imageCellView.contentMode = .scaleAspectFill
        imageCellView.clipsToBounds = true
        contentView.addSubview(imageCellView)

        NSLayoutConstraint.activate([
            imageCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageCellView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setImage(_ image: UIImage?) {
        imageCellView.image = image
    }
}
