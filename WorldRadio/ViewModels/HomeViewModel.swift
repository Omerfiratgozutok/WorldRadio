import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var filteredCountries: [Country] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var searchText = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.filterCountries(text)
            }
            .store(in: &cancellables)
    }
    
    func loadCountries() async {
        isLoading = true
        error = nil
        
        do {
            countries = try await RadioAPIService.shared.fetchCountries()
            filteredCountries = countries
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func filterCountries(_ text: String) {
        if text.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter {
                $0.name.localizedCaseInsensitiveContains(text)
            }
        }
    }
}
