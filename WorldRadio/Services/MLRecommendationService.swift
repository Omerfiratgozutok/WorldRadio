import Foundation
import CoreML

@MainActor
class MLRecommendationService: ObservableObject {
    static let shared = MLRecommendationService()
    
    @Published var recommendedGenres: [String] = []
    @Published var recommendedCountries: [String] = []
    @Published var isTraining = false
    
    private var userPreferences: UserPreferences = UserPreferences()
    private var saveTask: Task<Void, Never>?
    private let saveQueue = DispatchQueue(label: "com.worldradio.ml.save", qos: .utility)
    
    private init() {
        loadPreferences()
    }
    
    func recordListen(station: Station) {
        userPreferences.recordListen(station: station)
        debouncedSave()
    }
    
    func recordFavorite(station: Station) {
        userPreferences.recordFavorite(station: station)
        debouncedSave()
    }
    
    func recordSkip(station: Station) {
        userPreferences.recordSkip(station: station)
        debouncedSave()
    }
    
    func getRecommendations() -> [String] {
        return userPreferences.getRecommendedGenres()
    }
    
    func getCountryRecommendations() -> [String] {
        return userPreferences.getRecommendedCountries()
    }
    
    private func debouncedSave() {
        saveTask?.cancel()
        saveTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            guard !Task.isCancelled else { return }
            savePreferences()
        }
    }
    
    private func savePreferences() {
        do {
            let data = try JSONEncoder().encode(userPreferences)
            UserDefaults.standard.set(data, forKey: "userPreferences")
        } catch {
            print("Failed to save preferences: \(error)")
        }
    }
    
    private func loadPreferences() {
        guard let data = UserDefaults.standard.data(forKey: "userPreferences") else { return }
        
        do {
            userPreferences = try JSONDecoder().decode(UserPreferences.self, from: data)
        } catch {
            print("Failed to load preferences: \(error)")
            userPreferences = UserPreferences()
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
        for tag in station.tagsArray where !tag.isEmpty {
            genreCounts[tag, default: 0] += 1
        }
        let countryCode = station.countryCode
        if !countryCode.isEmpty {
            countryCounts[countryCode, default: 0] += 1
        }
    }
    
    mutating func recordFavorite(station: Station) {
        for tag in station.tagsArray where !tag.isEmpty {
            genreCounts[tag, default: 0] += 5
        }
        let countryCode = station.countryCode
        if !countryCode.isEmpty {
            countryCounts[countryCode, default: 0] += 5
        }
    }
    
    mutating func recordSkip(station: Station) {
        for tag in station.tagsArray where !tag.isEmpty {
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
