import UIKit

struct User: Codable {
    let email: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsers()
    }

    func fetchUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data recived")
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                for user in users {
                    print(user.email)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
}
