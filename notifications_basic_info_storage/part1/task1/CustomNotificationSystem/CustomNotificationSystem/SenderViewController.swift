import UIKit

class SenderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let button = UIButton(type: .system)
        button.setTitle("Send Notification", for: .normal)
        button.addTarget(self, action: #selector(sendNotificatation), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func sendNotificatation() {
        NotificationCenter.default.post(
            name: .customUpdate,
            object: nil,
            userInfo: ["message": "Notification received!"]
        )
    }
}

