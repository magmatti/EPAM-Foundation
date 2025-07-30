import UIKit

class ViewController: UIViewController {
    
    private let themeSegmentedControl = UISegmentedControl(items: ["Light", "Dark"])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupUI()
        loadThemeSelection()
        
        overrideUserInterfaceStyle = ThemeManager.currentTheme() == .light ? .light : .dark
    }

    private func setupUI() {
        themeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        themeSegmentedControl.selectedSegmentIndex = ThemeManager.currentTheme() == .light ? 0 : 1
        themeSegmentedControl.addTarget(self, action: #selector(themeChanged(_:)), for: .valueChanged)
        
        view.addSubview(themeSegmentedControl)
        
        NSLayoutConstraint.activate([
            themeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            themeSegmentedControl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            themeSegmentedControl.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func loadThemeSelection() {
        themeSegmentedControl.selectedSegmentIndex = ThemeManager.currentTheme() == .light ? 0 : 1
    }
    
    @objc private func themeChanged(_ sender: UISegmentedControl) {
        let selectedTheme: ThemeMode = sender.selectedSegmentIndex == 0 ? .light : .dark
        ThemeManager.applyTheme(selectedTheme)

        overrideUserInterfaceStyle = selectedTheme == .light ? .light : .dark
    }
}
