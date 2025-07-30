import UIKit

class MainViewController: UIViewController {

    private let emailLabel = UILabel()
    private let logoutButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        displayUserEmail()
    }

    private func setupUI() {
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.font = UIFont.systemFont(ofSize: 18)
        emailLabel.textAlignment = .center

        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)

        view.addSubview(emailLabel)
        view.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            logoutButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func displayUserEmail() {
        let email = UserDefaults.standard.string(forKey: "userEmail") ?? "No Email Found"
        emailLabel.text = "Welcome, \(email)"
    }

    @objc private func logout() {
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")

        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = LoginViewController()
        }
    }
}
