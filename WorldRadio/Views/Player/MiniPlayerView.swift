import SwiftUI

struct MiniPlayerView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var showFullPlayer = false
    
    var body: some View {
        if let station = playerViewModel.currentStation {
            VStack(spacing: 0) {
                Button {
                    showFullPlayer = true
                } label: {
                    HStack(spacing: 12) {
                        AsyncImage(url: station.faviconURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "radio")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        }
                        .frame(width: 44, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(station.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .lineLimit(1)
                            Text(station.country)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        Button {
                            playerViewModel.togglePlayPause()
                        } label: {
                            Image(systemName: playerViewModel.isPlaying ? "pause.fill" : "play.fill")
                                .font(.title2)
                                .foregroundStyle(.primary)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
            }
            .frame(height: 60)
            .background(.ultraThinMaterial)
            .sheet(isPresented: $showFullPlayer) {
                FullPlayerView()
                                    }
        }
    }
}
