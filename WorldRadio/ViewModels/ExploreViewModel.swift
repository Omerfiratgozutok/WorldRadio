import Foundation

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var topStations: [Station] = []
    @Published var recommendedStations: [Station] = []
    @Published var selectedGenre: Genre?
    @Published var genreStations: [Station] = []
    @Published var isLoading = false
    
    private let mlService = MLRecommendationService.shared
    
    func loadExplore() async {
        isLoading = true
        
        async let top = RadioAPIService.shared.fetchTopStations(limit: 50)
        
        do {
            topStations = try await top
        } catch {
            print("Error loading: \(error)")
        }
        
        isLoading = false
    }
    
    func selectGenre(_ genre: Genre) async {
        selectedGenre = genre
        isLoading = true
        
        do {
            genreStations = try await RadioAPIService.shared.fetchStations(byTag: genre.id, limit: 50)
        } catch {
            print("Error: \(error)")
        }
        
        isLoading = false
    }
    
    func getRecommendedStations() -> [Station] {
        let genres = mlService.getRecommendations()
        let countries = mlService.getCountryRecommendations()
        
        return topStations.filter { station in
            let genreMatch = genres.contains { genre in
                station.tags?.lowercased().contains(genre.lowercased()) ?? false
            }
            let countryMatch = countries.contains(station.countryCode)
            return genreMatch || countryMatch
        }
    }
}
