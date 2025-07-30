import UIKit

class ReceiverViewController: UIViewController {
    
    private let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        label.text = "Waiting for notification ..."
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // adding observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification(_:)),
            name: .customUpdate,
            object: nil
        )
    }
    
    @objc func handleNotification(_ notification: Notification) {
        if let message = notification.userInfo?["message"] as? String {
            label.text = message
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .customUpdate, object: nil)
    }
}
