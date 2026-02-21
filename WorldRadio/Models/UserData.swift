import Foundation

struct UserData {
    static let favoritesKey = "favorites"
    static let historyKey = "history"
    static let themeKey = "theme"
    static let sleepTimerKey = "sleepTimer"
    
    static func saveFavorites(_ ids: [String]) {
        UserDefaults.standard.set(ids, forKey: favoritesKey)
    }
    
    static func loadFavorites() -> [String] {
        UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
    }
    
    static func saveHistory(_ stations: [Station]) {
        if let data = try? JSONEncoder().encode(stations) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }
    
    static func loadHistory() -> [Station] {
        guard let data = UserDefaults.standard.data(forKey: historyKey),
              let stations = try? JSONDecoder().decode([Station].self, from: data) else {
            return []
        }
        return stations
    }
}
