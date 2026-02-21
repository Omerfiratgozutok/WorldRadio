import Foundation

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Station] = []
    @Published var history: [Station] = []
    
    init() {
        loadFavorites()
        loadHistory()
    }
    
    func loadFavorites() {
        let favoriteIds = Set(UserData.loadFavorites())
        let allHistory = UserData.loadHistory()
        favorites = allHistory.filter { favoriteIds.contains($0.id) }
    }
    
    func loadHistory() {
        history = UserData.loadHistory()
    }
    
    func addToFavorites(_ station: Station) {
        var current = UserData.loadFavorites()
        if !current.contains(station.id) {
            current.append(station.id)
            UserData.saveFavorites(current)
            MLRecommendationService.shared.recordFavorite(station: station)
        }
    }
    
    func removeFromFavorites(_ station: Station) {
        var current = UserData.loadFavorites()
        current.removeAll { $0 == station.id }
        UserData.saveFavorites(current)
    }
    
    func isFavorite(_ station: Station) -> Bool {
        UserData.loadFavorites().contains(station.id)
    }
    
    func addToHistory(_ station: Station) {
        var current = UserData.loadHistory()
        current.removeAll { $0.id == station.id }
        current.insert(station, at: 0)
        if current.count > 50 {
            current = Array(current.prefix(50))
        }
        UserData.saveHistory(current)
        history = current
    }
}
