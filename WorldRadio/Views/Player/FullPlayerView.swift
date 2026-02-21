import SwiftUI

struct FullPlayerView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.black, .gray.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Spacer()
                    
                    AsyncImage(url: playerViewModel.currentStation?.faviconURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "radio")
                            .font(.system(size: 100))
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: 250, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 20)
                    
                    VStack(spacing: 8) {
                        Text(playerViewModel.currentStation?.name ?? "")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(playerViewModel.currentStation?.country ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))
                        
                        if let tags = playerViewModel.currentStation?.tags {
                            Text(tags)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.5))
                                .lineLimit(1)
                        }
                    }
                    
                    VStack(spacing: 24) {
                        HStack(spacing: 40) {
                            Button {
                                let newVolume = max(0, playerViewModel.volume - 0.1)
                                playerViewModel.setVolume(newVolume)
                            } label: {
                                Image(systemName: "speaker.fill")
                                    .font(.title3)
                            }
                            .accessibilityLabel("Decrease volume")
                            
                            Button {
                                playerViewModel.togglePlayPause()
                            } label: {
                                Image(systemName: playerViewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 72))
                            }
                            .foregroundStyle(.white)
                            .accessibilityLabel(playerViewModel.isPlaying ? "Pause" : "Play")
                            
                            Button {
                                let newVolume = min(1, playerViewModel.volume + 0.1)
                                playerViewModel.setVolume(newVolume)
                            } label: {
                                Image(systemName: "speaker.wave.3.fill")
                                    .font(.title3)
                            }
                            .accessibilityLabel("Increase volume")
                        }
                        .foregroundStyle(.white)
                        
                        Slider(value: Binding(
                            get: { Double(playerViewModel.volume) },
                            set: { playerViewModel.setVolume(Float($0)) }
                        ), in: 0...1)
                        .tint(.white)
                        .accessibilityLabel("Volume")
                        
                        if let timerText = playerViewModel.sleepTimerRemaining {
                            HStack {
                                Image(systemName: "moon.fill")
                                Text("Sleep in \(timerText)")
                                Button("Cancel") {
                                    playerViewModel.cancelSleepTimer()
                                }
                            }
                            .font(.caption)
                            .foregroundStyle(.orange)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
}
