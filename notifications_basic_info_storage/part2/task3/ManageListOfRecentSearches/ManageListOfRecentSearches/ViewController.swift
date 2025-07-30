import UIKit

class ViewController: UIViewController {

    private let searchField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter search term"
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView = UITableView()
    
    private var recentSearches: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadSearches()
    }

    private func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        
        view.addSubview(searchField)
        view.addSubview(searchButton)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchButton.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        searchButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
    }
    
    @objc private func handleSearch() {
        guard let term = searchField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                      !term.isEmpty else { return }

        // updateing recent search list
        if let index = recentSearches.firstIndex(of: term) {
            recentSearches.remove(at: index)
        }
        recentSearches.insert(term, at: 0)

        if recentSearches.count > 5 {
            recentSearches = Array(recentSearches.prefix(5))
        }

        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
        
        tableView.reloadData()
        searchField.text = ""
    }
    
    private func loadSearches() {
        if let savedSearches = UserDefaults.standard.stringArray(forKey: "recentSearches") {
            recentSearches = savedSearches
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = recentSearches[indexPath.row]
        return cell
    }
}
