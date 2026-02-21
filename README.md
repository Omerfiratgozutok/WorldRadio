# 📻 World Radio

A beautiful iOS app to listen to radio stations from around the world. Built with SwiftUI, powered by Radio Browser API, featuring on-device AI recommendations.

![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ⭐ Features

- **🌍 Worldwide Radio** - Listen to 50,000+ radio stations from 200+ countries
- **🔊 High Quality Streaming** - Support for various audio formats (MP3, AAC, OGG)
- **🤖 AI Recommendations** - On-device machine learning that learns your preferences
- **🎨 Beautiful UI** - Dark/Light mode support with modern SwiftUI design
- **⏰ Sleep Timer** - Auto-stop playback after a set time
- **❤️ Favorites** - Save your favorite stations
- **📜 History** - Track your recently played stations
- **🔍 Search** - Find stations by name, country, or genre
- **📱 Background Audio** - Continue listening when app is in background
- **🎛️ Lock Screen Controls** - Control playback from lock screen

## 📸 Screenshots

<div style="display: flex; gap: 10px;">
  <img src="https://via.placeholder.com/150x300/007AFF/FFFFFF?text=Home" width="150" alt="Home Screen">
  <img src="https://via.placeholder.com/150x300/007AFF/FFFFFF?text=Explore" width="150" alt="Explore Screen">
  <img src="https://via.placeholder.com/150x300/007AFF/FFFFFF?text=Player" width="150" alt="Player Screen">
  <img src="https://via.placeholder.com/150x300/007AFF/FFFFFF?text=Settings" width="150" alt="Settings Screen">
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
│   ├── Explore/            # Genre browsing & AI recommendations
│   ├── Favorites/          # Saved stations
│   ├── Settings/           # App settings
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
| Min iOS | iOS 16.0 |
| Architecture | MVVM |
| Audio | AVFoundation, AVPlayer |
| API | Radio Browser API |
| ML | Create ML, Core ML |
| Storage | UserDefaults |

## 📡 API

This app uses the free, open-source [Radio Browser API](https://api.radio-browser.info):

- **Base URL**: `https://de1.api.radio-browser.info/json`
- **No API key required**
- **Rate limit**: Fair use policy

## 🤖 AI Recommendations

The app uses Apple's **Create ML** framework for on-device machine learning:

- **Privacy-first**: All data stays on your device
- **No internet required**: Works offline after initial data
- **Learns from**: Stations you listen to, favorites, and listening duration
- **Recommends**: Similar stations based on your taste

### How it works:

1. Records your listening behavior (genre, country, duration)
2. Builds a preference profile locally
3. Suggests stations matching your taste
4. Improves over time as you use the app

## 🚀 Getting Started

### Prerequisites

- macOS with Xcode 15+
- Apple Developer Account (for device testing/deployment)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/barancanercan/WorldRadio.git
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
   - Select an iOS Simulator (iPhone 14 Pro recommended)
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

## 📄 Files

| File | Description |
|------|-------------|
| `project.yml` | XcodeGen configuration |
| `Info.plist` | App configuration |
| `WorldRadioApp.swift` | App entry point |
| `RadioAPIService.swift` | API client |
| `AudioPlayerService.swift` | Audio playback |
| `MLRecommendationService.swift` | AI recommendations |

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
- [Apple Developer](https://developer.apple.com) - SwiftUI and Create ML frameworks
- All contributors and testers

---

Made with ❤️ for radio lovers worldwide

**World Radio** - Listen to the world 🎵
