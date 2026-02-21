import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.countries.isEmpty {
                    ProgressView("Loading countries...")
                } else if let error = viewModel.error {
                    ErrorView(message: error) {
                        Task { await viewModel.loadCountries() }
                    }
                } else {
                    List(viewModel.filteredCountries) { country in
                        NavigationLink(destination: CountryDetailView(country: country)) {
                            CountryRowView(country: country)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.loadCountries()
                    }
                }
            }
            .navigationTitle("World Radio")
            .searchable(text: $viewModel.searchText, prompt: "Search countries")
        }
        .task {
            if viewModel.countries.isEmpty {
                await viewModel.loadCountries()
            }
        }
    }
}
