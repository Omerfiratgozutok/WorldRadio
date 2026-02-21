import SwiftUI

struct CountryDetailView: View {
    let country: Country
    @StateObject private var viewModel: CountryDetailViewModel
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    init(country: Country) {
        self.country = country
        _viewModel = StateObject(wrappedValue: CountryDetailViewModel(country: country))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.stations.isEmpty {
                ProgressView("Loading stations...")
            } else if let error = viewModel.error {
                ErrorView(message: error) {
                    Task { await viewModel.loadStations() }
                }
            } else if viewModel.filteredStations.isEmpty {
                ContentUnavailableView(
                    "No Stations",
                    systemImage: "radio",
                    description: Text("No radio stations found for \(country.name)")
                )
            } else {
                List(viewModel.filteredStations) { station in
                    StationRowView(station: station) {
                        playerViewModel.play(station: station)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(country.name)
        .searchable(text: $viewModel.searchText, prompt: "Search stations")
        .task {
            if viewModel.stations.isEmpty {
                await viewModel.loadStations()
            }
        }
    }
}
