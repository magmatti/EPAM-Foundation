import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
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
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        clearCacheButton.setTitle("Clear Cache", for: .normal)
        clearCacheButton.addTarget(self, action: #selector(clearCache), for: .touchUpInside)
        clearCacheButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearCacheButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ImageCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 200
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            clearCacheButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            clearCacheButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: clearCacheButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageURLs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let url = imageURLs[indexPath.row]
        let fileName = "cached_image_\(indexPath.row).jpg"
        let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.setImage(nil)

        if FileManager.default.fileExists(atPath: filePath.path),
           let data = try? Data(contentsOf: filePath),
           let image = UIImage(data: data) {
            cell.setImage(image)
        } else {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, let image = UIImage(data: data) else {
                    print("Failed to load image \(indexPath.row): \(error?.localizedDescription ?? "unknown error")")
                    return
                }

                try? data.write(to: filePath)

                DispatchQueue.main.async {
                    if let currentCell = tableView.cellForRow(at: indexPath) as? ImageCell {
                        currentCell.setImage(image)
                    }
                }
            }
            task.resume()
        }

        return cell
    }

    @objc private func clearCache() {
        for index in 0..<imageURLs.count {
            let fileName = "cached_image_\(index).jpg"
            let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

            if FileManager.default.fileExists(atPath: filePath.path) {
                try? FileManager.default.removeItem(at: filePath)
                print("Deleted \(fileName)")
            }
        }

        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning received, clearing image cache")
        clearCache()
    }
}
