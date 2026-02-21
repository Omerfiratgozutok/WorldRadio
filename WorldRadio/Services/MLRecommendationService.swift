import Foundation
import CreateML
import CoreML

@MainActor
class MLRecommendationService: ObservableObject {
    static let shared = MLRecommendationService()
    
    @Published var recommendedGenres: [String] = []
    @Published var recommendedCountries: [String] = []
    @Published var isTraining = false
    
    private var userPreferences: UserPreferences = UserPreferences()
    
    private init() {
        loadPreferences()
    }
    
    func recordListen(station: Station) {
        userPreferences.recordListen(station: station)
        savePreferences()
    }
    
    func recordFavorite(station: Station) {
        userPreferences.recordFavorite(station: station)
        savePreferences()
    }
    
    func recordSkip(station: Station) {
        userPreferences.recordSkip(station: station)
        savePreferences()
    }
    
    func getRecommendations() -> [String] {
        return userPreferences.getRecommendedGenres()
    }
    
    func getCountryRecommendations() -> [String] {
        return userPreferences.getRecommendedCountries()
    }
    
    private func savePreferences() {
        if let data = try? JSONEncoder().encode(userPreferences) {
            UserDefaults.standard.set(data, forKey: "userPreferences")
        }
    }
    
    private func loadPreferences() {
        if let data = UserDefaults.standard.data(forKey: "userPreferences"),
           let prefs = try? JSONDecoder().decode(UserPreferences.self, from: data) {
            userPreferences = prefs
        }
    }
}

struct UserPreferences: Codable {
    var genreCounts: [String: Int] = [:]
    var countryCounts: [String: Int] = [:]
    var totalListens: Int = 0
    var skipCounts: [String: Int] = [:]
    
    mutating func recordListen(station: Station) {
        totalListens += 1
        for tag in station.tagsArray {
            genreCounts[tag, default: 0] += 1
        }
        countryCounts[station.countryCode, default: 0] += 1
    }
    
    mutating func recordFavorite(station: Station) {
        for tag in station.tagsArray {
            genreCounts[tag, default: 0] += 5
        }
        countryCounts[station.countryCode, default: 0] += 5
    }
    
    mutating func recordSkip(station: Station) {
        for tag in station.tagsArray {
            skipCounts[tag, default: 0] += 1
        }
    }
    
    func getRecommendedGenres() -> [String] {
        return genreCounts
            .filter { (skipCounts[$0.key] ?? 0) < $0.value }
            .sorted { $0.value > $1.value }
            .prefix(5)
            .map { $0.key }
    }
    
    func getRecommendedCountries() -> [String] {
        return countryCounts
            .sorted { $0.value > $1.value }
            .prefix(5)
            .map { $0.key }
    }
}
