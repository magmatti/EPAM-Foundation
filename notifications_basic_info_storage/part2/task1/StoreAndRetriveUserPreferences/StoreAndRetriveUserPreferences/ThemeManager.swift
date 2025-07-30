import UIKit

enum ThemeMode: String {
    case light
    case dark
}

let themeKey = "selectedTheme"

final class ThemeManager {
    
    static func currentTheme() -> ThemeMode {
        let saved = UserDefaults.standard.string(forKey: themeKey)
        return ThemeMode(rawValue: saved ?? ThemeMode.light.rawValue) ?? .light
    }
    
    static func applyTheme(_ theme: ThemeMode) {
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.forEach {
                $0.overrideUserInterfaceStyle = (theme == .light) ? .light : .dark
            }
        }
    }
}
