import AVFoundation
import MediaPlayer
import Combine

@MainActor
class AudioPlayerService: ObservableObject {
    static let shared = AudioPlayerService()
    
    @Published var isPlaying = false
    @Published var currentStation: Station?
    @Published var isLoading = false
    @Published var sleepTimerDate: Date?
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserver: Any?
    private var sleepTimer: Timer?
    private var playerItemObserver: NSKeyValueObservation?
    private var cancellables = Set<AnyCancellable>()
    private var artworkTask: Task<Void, Never>?
    
    private init() {
        setupAudioSession()
        setupRemoteCommands()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }
    
    private func setupRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.play()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }
    }
    
    private func cleanupPlayer() {
        playerItemObserver?.invalidate()
        playerItemObserver = nil
        
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        
        player?.pause()
        player = nil
        playerItem = nil
    }
    
    func play(station: Station) {
        guard let url = station.streamURL else { return }
        
        cancelSleepTimer()
        
        cleanupPlayer()
        
        currentStation = station
        isLoading = true
        
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        playerItemObserver = playerItem?.observe(\.status) { [weak self] item, _ in
            Task { @MainActor in
                if item.status == .readyToPlay {
                    self?.isLoading = false
                } else if item.status == .failed {
                    self?.isLoading = false
                    self?.isPlaying = false
                }
            }
        }
        
        player?.play()
        isPlaying = true
        
        updateNowPlayingInfo()
        
        Task {
            try? await RadioAPIService.shared.recordStationClick(stationUUID: station.id)
        }
    }
    
    func play() {
        player?.play()
        isPlaying = true
        updateNowPlayingInfo()
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
        updateNowPlayingInfo()
    }
    
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func stop() {
        cancelSleepTimer()
        cleanupPlayer()
        isPlaying = false
        currentStation = nil
        clearNowPlayingInfo()
    }
    
    func setVolume(_ volume: Float) {
        player?.volume = volume
    }
    
    func setSleepTimer(minutes: Int) {
        cancelSleepTimer()
        
        guard minutes > 0 else { return }
        
        sleepTimerDate = Date().addingTimeInterval(TimeInterval(minutes * 60))
        
        sleepTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(minutes * 60), repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.stop()
                self?.sleepTimerDate = nil
            }
        }
    }
    
    func cancelSleepTimer() {
        sleepTimer?.invalidate()
        sleepTimer = nil
        sleepTimerDate = nil
    }
    
    private func updateNowPlayingInfo() {
        guard let station = currentStation else { return }
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = station.name
        nowPlayingInfo[MPMediaItemPropertyArtist] = station.country
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true
        
        artworkTask?.cancel()
        if let faviconURL = station.faviconURL {
            artworkTask = Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: faviconURL)
                    guard !Task.isCancelled else { return }
                    if let image = UIImage(data: data) {
                        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
                        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                    }
                } catch {
                    // Ignore artwork loading errors
                }
            }
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func clearNowPlayingInfo() {
        artworkTask?.cancel()
        artworkTask = nil
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
}
