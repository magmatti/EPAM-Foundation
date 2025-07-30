import UIKit

class ViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let downloadButton = UIButton(type: .system)
    private let clearCacheButton = UIButton(type: .system)
    
    private let imageURLs: [URL] = [
        URL(string: "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d")!,
        URL(string: "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e")!,
        URL(string: "https://images.unsplash.com/photo-1550439062-609e1531270e")!,
        URL(string: "https://images.unsplash.com/photo-1481349518771-20055b2a7b24")!
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadCachedImages()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        downloadButton.setTitle("Download Images", for: .normal)
        downloadButton.addTarget(self, action: #selector(downloadImages), for: .touchUpInside)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(downloadButton)

        clearCacheButton.setTitle("Clear Cache", for: .normal)
        clearCacheButton.addTarget(self, action: #selector(clearCache), for: .touchUpInside)
        clearCacheButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearCacheButton)

        NSLayoutConstraint.activate([
            downloadButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            clearCacheButton.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 10),
            clearCacheButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            scrollView.topAnchor.constraint(equalTo: clearCacheButton.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    @objc private func downloadImages() {
        for (index, url) in imageURLs.enumerated() {
            let fileName = "cached_image_\(index).jpg"
            let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            if FileManager.default.fileExists(atPath: filePath.path) {
                print("Image \(index) already cached.")
                continue
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self else { return }

                if let data = data, let image = UIImage(data: data) {
                    try? data.write(to: filePath)
                    print("Image \(index) saved to \(filePath.lastPathComponent)")

                    DispatchQueue.main.async {
                        self.addImageToStack(image)
                    }
                } else {
                    print("Error downloading image \(index): \(error?.localizedDescription ?? "unknown error")")
                }
            }

            task.resume()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning received, clearing image cache")
        clearCache()
    }
    
    @objc private func clearCache() {
        for index in 0..<imageURLs.count {
            let fileName = "cached_image_\(index).jpg"
            let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

            do {
                if FileManager.default.fileExists(atPath: filePath.path) {
                    try FileManager.default.removeItem(at: filePath)
                    print("Deleted \(fileName)")
                }
            } catch {
                print("Failed to delete \(fileName): \(error)")
            }
        }

        DispatchQueue.main.async {
            self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        }
    }
    
    private func addImageToStack(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.addArrangedSubview(imageView)
    }

    private func loadCachedImages() {
        for index in 0..<imageURLs.count {
            let fileName = "cached_image_\(index).jpg"
            let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

            if let data = try? Data(contentsOf: filePath),
               let image = UIImage(data: data) {
                addImageToStack(image)
                print("Loaded cached image \(index)")
            }
        }
    }
}

