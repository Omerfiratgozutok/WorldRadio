import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Genres")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Genre.all) { genre in
                                    GenreChipView(genre: genre, isSelected: viewModel.selectedGenre?.id == genre.id) {
                                        Task { await viewModel.selectGenre(genre) }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    if !viewModel.genreStations.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(viewModel.selectedGenre?.name ?? "")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.genreStations) { station in
                                        StationCardView(station: station) {
                                            playerViewModel.play(station: station)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Popular Stations")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.topStations.prefix(10)) { station in
                                StationRowView(station: station) {
                                    playerViewModel.play(station: station)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Explore")
            .refreshable {
                await viewModel.loadExplore()
            }
        }
        .task {
            await viewModel.loadExplore()
        }
    }
}
