# 📻 World Radio

A beautiful iOS app to listen to radio stations from around the world. Built with SwiftUI, powered by Radio Browser API, featuring on-device AI recommendations.

![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)

## ⭐ Features

- **🌍 Worldwide Radio** - Listen to 30,000+ radio stations from 200+ countries
- **🔊 High Quality Streaming** - Support for various audio formats (MP3, AAC, OGG)
- **🎨 Beautiful UI** - Dark/Light mode support with modern SwiftUI design
- **⏰ Sleep Timer** - Auto-stop playback after a set time
- **❤️ Favorites** - Save your favorite stations
- **🔍 Search** - Find stations by name or country
- **📱 Background Audio** - Continue listening when app is in background
- **🎛️ Lock Screen Controls** - Control playback from lock screen
- **🔄 Multi-Server Support** - Reliable connection with automatic server failover

## 📸 Screenshots

<div style="display: flex; gap: 10px; flex-wrap: wrap;">
  <img src="https://via.placeholder.com/150x300/1a1a2e/ffffff?text=Home" width="150" alt="Home Screen">
  <img src="https://via.placeholder.com/150x300/1a1a2e/ffffff?text=Explore" width="150" alt="Explore Screen">
  <img src="https://via.placeholder.com/150x300/1a1a2e/ffffff?text=Player" width="150" alt="Player Screen">
  <img src="https://via.placeholder.com/150x300/1a1a2e/ffffff?text=Settings" width="150" alt="Settings Screen">
</div>

## 🏗️ Architecture

```
WorldRadio/
├── App/                    # App entry point
├── Models/                 # Data models (Station, Country, UserData)
├── ViewModels/             # MVVM ViewModels
├── Views/                  # SwiftUI Views
│   ├── Home/              # Country list
│   ├── Player/            # Mini & Full player
│   ├── Explore/           # Genre browsing
│   ├── Favorites/         # Saved stations
│   ├── Settings/          # App settings
│   └── Components/        # Reusable UI components
├── Services/              # API, Audio, ML services
├── Resources/             # Assets
└── Supporting/            # Info.plist
```

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| Framework | SwiftUI |
| Language | Swift 5.9 |
| Min iOS | iOS 17.0 |
| Architecture | MVVM |
| Audio | AVFoundation, AVPlayer |
| API | Radio Browser API |
| Storage | UserDefaults |

## 📡 API

This app uses the free, open-source [Radio Browser API](https://api.radio-browser.info):

- **Base URLs**: Multiple server endpoints for reliability
  - `https://de1.api.radio-browser.info/json`
  - `https://at1.api.radio-browser.info/json`
  - `https://nl1.api.radio-browser.info/json`
  - `https://fr1.api.radio-browser.info/json`
- **No API key required**
- **Rate limit**: Fair use policy

### Features
- Automatic server failover
- 30-second timeout
- Broken station filtering
- Sorted by popularity (votes)

## 🚀 Getting Started

### Prerequisites

- macOS with Xcode 15+
- iOS 17.0+ for development
- Apple Developer Account (for device testing/deployment)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Omerfiratgozutok/WorldRadio.git
   cd WorldRadio
   ```

2. **Generate Xcode project:**
   ```bash
   brew install xcodegen  # if not installed
   xcodegen generate
   ```

3. **Open in Xcode:**
   ```bash
   open WorldRadio.xcodeproj
   ```

4. **Run on Simulator:**
   - Select an iOS Simulator (iPhone 17 Pro recommended)
   - Press `Cmd + R` to build and run

### Building for Device

1. Select your team in Xcode:
   - Go to `WorldRadio` target → `Signing & Capabilities`
   - Select your Apple Developer Team

2. Build for device:
   - Select "Any iOS Device" in the device selector
   - Press `Cmd + B` to build

## 📱 App Store Deployment

### Required Steps

1. **Apple Developer Program** - Enroll at developer.apple.com ($99/year)

2. **App Store Connect** - Create your app listing:
   - App name: World Radio
   - Bundle ID: com.worldradio.app
   - Category: Music

3. **Screenshots** - Provide for:
   - 6.5" iPhone (iPhone 14 Pro Max)
   - 5.5" iPhone (iPhone 8 Plus)

4. **Submit for Review** - Use Xcode or Transporter app

## 🔧 Configuration

### Info.plist Settings
- Background audio mode enabled
- iOS 17+ orientation support
- Dark mode default
- Media URL permissions for streaming

### project.yml
- Minimum iOS: 17.0
- Swift Version: 5.9
- Bundle ID: com.worldradio.app

## 📄 Project Structure

| File | Description |
|------|-------------|
| `project.yml` | XcodeGen configuration |
| `Info.plist` | App configuration |
| `WorldRadioApp.swift` | App entry point |
| `RadioAPIService.swift` | Multi-server API client |
| `AudioPlayerService.swift` | Audio playback with background support |
| `MLRecommendationService.swift` | User preference learning |
| `Station.swift` | Radio station model |
| `Country.swift` | Country model with flags |
| `HomeView.swift` | Country list view |
| `PlayerViewModel.swift` | Audio playback state management |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [Radio Browser API](https://www.radio-browser.info) - Free radio station data
- [Apple Developer](https://developer.apple.com) - SwiftUI frameworks
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) - Project generation
- All contributors and testers

---

Made with ❤️ for radio lovers worldwide

**World Radio** - Listen to the world 🎵
