import UIKit

struct AppConfig: Decodable {
    let maxImagesToShow: Int
    let imageNames: [String]
}

class ViewController: UIViewController {

    private let stackView = UIStackView()
    private let headerLabel = UILabel()
    private var config: AppConfig?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupStackView()
        loadConfigAndDisplayImages()
    }

    private func setupStackView() {
        headerLabel.font = .boldSystemFont(ofSize: 18)
        headerLabel.textColor = .darkGray
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerLabel)

        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerLabel.heightAnchor.constraint(equalToConstant: 30),

            stackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func loadConfigAndDisplayImages() {
        guard let config = loadConfigFromBundle() else {
            print("Failed to load config")
            return
        }

        self.config = config

        let imagesToShow = Array(config.imageNames.prefix(config.maxImagesToShow))
        headerLabel.text = "Configured to show: \(config.maxImagesToShow) images"

        for imageName in imagesToShow {
            if let image = UIImage(named: imageName) {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview(imageView)

                NSLayoutConstraint.activate([
                    imageView.heightAnchor.constraint(equalToConstant: 150),
                    imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
                ])
            } else {
                print("Image not found: \(imageName)")
            }
        }
    }

    private func loadConfigFromBundle() -> AppConfig? {
        guard let url = Bundle.main.url(forResource: "config", withExtension: "json") else {
            print("config.json not found in bundle")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let config = try JSONDecoder().decode(AppConfig.self, from: data)
            return config
        } catch {
            print("Failed to parse config.json: \(error)")
            return nil
        }
    }
}
