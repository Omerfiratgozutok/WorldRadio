import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Picker("Theme", selection: $viewModel.theme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .onChange(of: viewModel.theme) { _, newValue in
                        playerViewModel.theme = newValue
                    }
                }
                
                Section("Sleep Timer") {
                    ForEach([15, 30, 45, 60], id: \.self) { minutes in
                        Button {
                            playerViewModel.setSleepTimer(minutes: minutes)
                        } label: {
                            Text("\(minutes) minutes")
                        }
                    }
                    
                    if playerViewModel.sleepTimerDate != nil {
                        Button("Cancel Timer", role: .destructive) {
                            playerViewModel.cancelSleepTimer()
                        }
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                    Link("Send Feedback", destination: URL(string: "mailto:feedback@worldradio.app")!)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
