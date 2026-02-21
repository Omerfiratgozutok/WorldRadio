import Foundation
import Combine

@MainActor
class PlayerViewModel: ObservableObject {
    @Published var currentStation: Station?
    @Published var isPlaying = false
    @Published var isLoading = false
    @Published var volume: Float = 1.0
    @Published var sleepTimerDate: Date?
    @Published var theme: AppTheme = .dark
    
    private let audioService = AudioPlayerService.shared
    private var cancellables = Set<AnyCancellable>()
    
    var sleepTimerRemaining: String? {
        guard let date = sleepTimerDate else { return nil }
        let remaining = date.timeIntervalSince(Date())
        if remaining <= 0 { return nil }
        let minutes = Int(remaining / 60)
        return "\(minutes) min"
    }
    
    init() {
        audioService.$currentStation
            .assign(to: &$currentStation)
        
        audioService.$isPlaying
            .assign(to: &$isPlaying)
        
        audioService.$isLoading
            .assign(to: &$isLoading)
        
        audioService.$sleepTimerDate
            .assign(to: &$sleepTimerDate)
    }
    
    func play(station: Station) {
        audioService.play(station: station)
        MLRecommendationService.shared.recordListen(station: station)
    }
    
    func togglePlayPause() {
        audioService.togglePlayPause()
    }
    
    func pause() {
        audioService.pause()
    }
    
    func resume() {
        audioService.play()
    }
    
    func stop() {
        audioService.stop()
    }
    
    func setVolume(_ value: Float) {
        volume = value
        audioService.setVolume(value)
    }
    
    func setSleepTimer(minutes: Int) {
        audioService.setSleepTimer(minutes: minutes)
    }
    
    func cancelSleepTimer() {
        audioService.cancelSleepTimer()
    }
}
