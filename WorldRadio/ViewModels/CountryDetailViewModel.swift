import Foundation

@MainActor
class CountryDetailViewModel: ObservableObject {
    @Published var stations: [Station] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var searchText = ""
    
    let country: Country
    
    init(country: Country) {
        self.country = country
    }
    
    var filteredStations: [Station] {
        if searchText.isEmpty {
            return stations
        }
        return stations.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            ($0.tags?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    func loadStations() async {
        isLoading = true
        error = nil
        
        do {
            stations = try await RadioAPIService.shared.fetchStations(byCountry: country.id, limit: 200)
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
}
