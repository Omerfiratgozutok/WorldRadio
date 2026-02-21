import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    var body: some View {
        NavigationStack {
            List {
                if !viewModel.favorites.isEmpty {
                    Section("Favorites") {
                        ForEach(viewModel.favorites) { station in
                            StationRowView(station: station) {
                                playerViewModel.play(station: station)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                viewModel.removeFromFavorites(viewModel.favorites[index])
                            }
                        }
                    }
                }
                
                if !viewModel.history.isEmpty {
                    Section("Recent") {
                        ForEach(viewModel.history) { station in
                            StationRowView(station: station) {
                                playerViewModel.play(station: station)
                            }
                        }
                    }
                }
                
                if viewModel.favorites.isEmpty && viewModel.history.isEmpty {
                    ContentUnavailableView(
                        "No Favorites Yet",
                        systemImage: "heart",
                        description: Text("Tap the heart on any station to add it to favorites")
                    )
                }
            }
            .navigationTitle("Library")
            .onAppear {
                viewModel.loadHistory()
            }
        }
    }
}
