import UIKit

class ViewController: UIViewController {
    
    private let textView = UITextView()
    private let saveButton = UIButton(type: .system)
    private let loadButton = UIButton(type: .system)
    private let fileName = "user_note.txt"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 8
        view.addSubview(textView)

        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveToFile), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)

        loadButton.setTitle("Load", for: .normal)
        loadButton.addTarget(self, action: #selector(loadFromFile), for: .touchUpInside)
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadButton)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 300),

            saveButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),

            loadButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            loadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        ])
    }
    
    @objc private func saveToFile() {
        let text = textView.text ?? ""
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(fileName) else { return }

        do {
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
            print("saved to \(fileURL.path)")
            textView.text = ""
        } catch {
            print("error saving file: \(error)")
        }
    }

    @objc private func loadFromFile() {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(fileName) else { return }

        do {
            let text = try String(contentsOf: fileURL, encoding: .utf8)
            textView.text = text
            print("loaded from \(fileURL.path)")
        } catch {
            print("error reading file: \(error)")
        }
    }

    private func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
