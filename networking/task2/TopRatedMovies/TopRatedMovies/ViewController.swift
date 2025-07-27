import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    private var tableView = UITableView()
    private var tvShows: [TVShow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(TVShowCell.self, forCellReuseIdentifier: TVShowCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        fetchData()
    }
    
    func fetchData() {
        NetworkManager.shared.fetchTopRatedTVShows { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let shows):
                    self.tvShows = shows
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TVShowCell.identifier, for: indexPath) as! TVShowCell
        cell.configure(with: tvShows[indexPath.row])
        return cell
    }
}
