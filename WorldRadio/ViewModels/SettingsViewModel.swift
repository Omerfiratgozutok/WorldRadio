import Foundation

enum AppTheme: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
}

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var theme: AppTheme = .dark
    @Published var sleepTimerMinutes: Int = 30
    
    init() {
        loadSettings()
    }
    
    func loadSettings() {
        if let themeRaw = UserDefaults.standard.string(forKey: "theme"),
           let theme = AppTheme(rawValue: themeRaw) {
            self.theme = theme
        }
    }
    
    func setTheme(_ theme: AppTheme) {
        self.theme = theme
        UserDefaults.standard.set(theme.rawValue, forKey: "theme")
    }
}
