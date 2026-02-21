import SwiftUI

struct ContentView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "globe")
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "sparkles")
                }
                .tag(1)
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .tint(.blue)
        .overlay(alignment: .bottom) {
            if playerViewModel.currentStation != nil {
                MiniPlayerView()
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: playerViewModel.currentStation != nil)
    }
}
