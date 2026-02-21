import SwiftUI

@main
struct WorldRadioApp: App {
    @StateObject private var playerViewModel = PlayerViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(playerViewModel)
                .preferredColorScheme(playerViewModel.theme == .dark ? .dark : (playerViewModel.theme == .light ? .light : nil))
        }
    }
}
