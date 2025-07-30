import UIKit

class LoginViewController: UIViewController {
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter email"
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
        
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(emailField)
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            emailField.widthAnchor.constraint(equalToConstant: 250),
            
            loginButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    @objc private func handleLogin() {
        guard let email = emailField.text, !email.isEmpty else { return }

        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")

        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = MainViewController()
        }
    }
}
