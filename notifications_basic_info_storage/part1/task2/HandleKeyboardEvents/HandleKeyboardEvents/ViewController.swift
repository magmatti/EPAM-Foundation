import UIKit

class ViewController: UIViewController {
    
    private let textField = UITextField()
    private var bottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTextField()
        setupKeyboardObservers()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        textField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupTextField() {
        textField.borderStyle = .roundedRect
        textField.placeholder = "Tap to enter text"
        textField.backgroundColor = .white
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(textField)

        bottomConstraint = textField.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20
        )

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomConstraint!
        ])

        view.layoutIfNeeded()
    }
    
    private func setupKeyboardObservers() {
       NotificationCenter.default.addObserver(
           self,
           selector: #selector(keyboardWillShow(_:)),
           name: UIResponder.keyboardWillShowNotification,
           object: nil
       )

       NotificationCenter.default.addObserver(
           self,
           selector: #selector(keyboardWillHide(_:)),
           name: UIResponder.keyboardWillHideNotification,
           object: nil
       )
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else {
            return
        }
        
        bottomConstraint?.constant = -keyboardFrame.height - 10
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else {
            return
        }
        
        bottomConstraint?.constant = -20
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}
