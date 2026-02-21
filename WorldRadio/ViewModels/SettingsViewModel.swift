import Foundation

enum AppTheme: String, CaseIterable, Codable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
}

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var theme: AppTheme = .dark {
        didSet {
            saveSettings()
        }
    }
    @Published var sleepTimerMinutes: Int = 30 {
        didSet {
            saveSettings()
        }
    }
    
    private enum Keys {
        static let theme = "theme"
        static let sleepTimerMinutes = "sleepTimerMinutes"
    }
    
    init() {
        loadSettings()
    }
    
    func loadSettings() {
        if let themeRaw = UserDefaults.standard.string(forKey: Keys.theme),
           let theme = AppTheme(rawValue: themeRaw) {
            self.theme = theme
        }
        
        let savedTimer = UserDefaults.standard.integer(forKey: Keys.sleepTimerMinutes)
        if savedTimer > 0 {
            self.sleepTimerMinutes = savedTimer
        }
    }
    
    func setTheme(_ theme: AppTheme) {
        self.theme = theme
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(theme.rawValue, forKey: Keys.theme)
        UserDefaults.standard.set(sleepTimerMinutes, forKey: Keys.sleepTimerMinutes)
    }
}
