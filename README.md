# BreathEasy - Your Personal Breathing Companion

<p align="center">
  <img src="./docs/assets/app-icon.png" alt="BreathEasy Logo" width="120" height="120">
</p>

<p align="center">
  <strong>Practice mindful breathing anywhere, anytime. 100% offline and private.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-18.5+-blue.svg" alt="iOS Version">
  <img src="https://img.shields.io/badge/Swift-5.9+-orange.svg" alt="Swift Version">
  <img src="https://img.shields.io/badge/Xcode-16.0+-blue.svg" alt="Xcode Version">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
</p>

## 🌟 Features

### Core Functionality
- **Guided Breathing Exercises** - Multiple scientifically-backed breathing patterns
- **Visual Animations** - Smooth, calming animations to guide your breathing rhythm
- **Haptic Feedback** - Gentle vibrations synchronized with breathing phases
- **Audio Guidance** - Optional voice cues and breathing sounds
- **Progress Tracking** - Monitor your sessions, streaks, and improvements
- **Achievement System** - Unlock badges as you build consistent practice
- **Custom Patterns** - Create your own personalized breathing rhythms
- **Mood Tracking** - Log your emotional state before and after sessions

### Privacy & Accessibility
- **100% Offline** - No internet connection required, all data stays on your device
- **Privacy-First** - Zero data collection, no analytics, no tracking
- **Accessibility Support** - High contrast, reduced motion, and other accessibility features
- **Multi-language** - Support for English and Spanish
- **Dark Mode** - Full support for system appearance preferences

### Breathing Patterns Included
1. **4-7-8 Breathing** - Perfect for sleep and anxiety relief
2. **Box Breathing** - Great for focus and concentration
3. **Diaphragmatic Breathing** - Deep relaxation and stress relief
4. **Resonant Breathing** - Heart rate variability optimization
5. **Custom Patterns** - Create your own breathing rhythms

## 📱 Screenshots

| Home Screen | Breathing Session | Progress Tracking | Settings |
|-------------|-------------------|-------------------|----------|
| ![Home](./docs/screenshots/home.png) | ![Session](./docs/screenshots/session.png) | ![History](./docs/screenshots/history.png) | ![Settings](./docs/screenshots/settings.png) |

## 🚀 Getting Started

### Prerequisites
- **iOS 18.5** or later
- **Xcode 16.0** or later
- **macOS Sonoma** or later (for development)

### Installation

#### Option 1: Clone and Build
```bash
# Clone the repository
git clone https://github.com/rajkumar-natarajan/BreathEasy.git

# Navigate to the project directory
cd BreathEasy

# Open in Xcode
open BreathEasy.xcodeproj

# Build and run on your device or simulator
# Select your target device and press Cmd+R
```

#### Option 2: Direct Download
1. Download the latest release from the [Releases](https://github.com/rajkumar-natarajan/BreathEasy/releases) page
2. Extract the archive
3. Open `BreathEasy.xcodeproj` in Xcode
4. Build and run

### First Launch
1. **Onboarding** - Complete the welcome tutorial to learn the basics
2. **Permissions** - Grant optional permissions for notifications and haptic feedback
3. **Profile Setup** - Choose your preferred settings and breathing patterns
4. **First Session** - Try your first breathing exercise!

## 📖 Usage Guide

### Starting a Breathing Session
1. **Choose a Pattern** - Select from 4-7-8, Box, Diaphragmatic, Resonant, or Custom
2. **Set Duration** - Pick session length (1-30 minutes)
3. **Log Pre-Session Mood** - Rate how you're feeling before starting
4. **Follow the Guide** - Watch the visual animations and feel the haptic feedback
5. **Complete Session** - Log your post-session mood and see improvement

### Tracking Progress
- **Daily Stats** - View sessions completed today
- **Weekly Overview** - See your practice consistency
- **Mood Trends** - Track emotional improvements over time
- **Streak Counter** - Build and maintain daily practice streaks
- **Achievement Badges** - Unlock rewards for milestones

### Customization
- **Breathing Patterns** - Create custom timing configurations
- **Visual Themes** - Choose from multiple color schemes
- **Audio Settings** - Enable/disable voice guidance and sounds
- **Haptic Intensity** - Adjust vibration strength
- **Accessibility** - Enable high contrast, reduced motion, and other features

## 🏗️ Architecture

### Project Structure
```
BreathEasy/
├── Models/                 # Data models and business logic
│   ├── BreathingSession.swift
│   ├── BreathingPattern.swift
│   └── AppSettings.swift
├── Views/                  # SwiftUI views and UI components
│   ├── HomeView.swift
│   ├── SessionView.swift
│   ├── HistoryView.swift
│   └── SettingsView.swift
├── ViewModels/            # Observable view models
│   ├── HomeViewModel.swift
│   └── SessionViewModel.swift
├── Utilities/             # Helper classes and managers
│   ├── DataManager.swift
│   ├── HapticManager.swift
│   └── SpeechManager.swift
└── Assets.xcassets/       # Images, colors, and other assets
```

### Key Technologies
- **SwiftUI** - Modern declarative UI framework
- **Observation Framework** - Reactive state management
- **UserDefaults** - Local data persistence
- **AVFoundation** - Audio and speech synthesis
- **CoreHaptics** - Haptic feedback
- **UserNotifications** - Daily reminder notifications

### Design Patterns
- **MVVM Architecture** - Model-View-ViewModel pattern
- **Observable Pattern** - Reactive programming with @Observable
- **Singleton Pattern** - Shared managers for data, haptics, and speech
- **Factory Pattern** - Breathing pattern creation
- **Strategy Pattern** - Different breathing techniques

## 🔧 Configuration

### App Settings
The app provides extensive customization options:

#### Audio & Haptics
- **Sound Cues** - Enable/disable breathing sounds
- **Voice Guidance** - Toggle spoken instructions
- **Haptic Feedback** - Vibration during breathing phases
- **Haptic Intensity** - Light, Medium, Strong, or Off

#### Visual & Accessibility
- **Color Scheme** - Multiple theme options
- **Reduce Motion** - Simplified animations
- **High Contrast** - Enhanced visibility
- **Dark Mode** - System appearance support

#### Notifications
- **Daily Reminders** - Customizable reminder times
- **Notification Content** - Motivational messages
- **Quiet Hours** - Automatic do-not-disturb periods

#### Health Integration
- **HealthKit Export** - Export session data to Apple Health
- **Mindfulness Minutes** - Track in Health app
- **Heart Rate Variability** - Optional HRV monitoring

## 📊 Data & Privacy

### Data Storage
- **Local Storage** - All data stored locally using UserDefaults
- **No Cloud Sync** - Data remains on your device only
- **Export Options** - Export your data in JSON format
- **Data Portability** - Easy backup and transfer

### Privacy Commitment
- **No Data Collection** - Zero user data is collected or transmitted
- **No Analytics** - No usage tracking or analytics
- **No Third-Party Services** - Completely self-contained
- **Open Source** - Full transparency of data handling

### What Data is Stored
- **Session History** - Breathing session records and durations
- **Mood Logs** - Pre and post-session mood ratings
- **Settings** - Your app preferences and customizations
- **Achievements** - Earned badges and progress milestones
- **Custom Patterns** - User-created breathing patterns

## 🧪 Testing

### Running Tests
```bash
# Run unit tests
xcodebuild test -scheme BreathEasy -destination 'platform=iOS Simulator,name=iPhone 16'

# Run UI tests
xcodebuild test -scheme BreathEasyUITests -destination 'platform=iOS Simulator,name=iPhone 16'

# Generate test coverage report
xcodebuild test -scheme BreathEasy -destination 'platform=iOS Simulator,name=iPhone 16' -enableCodeCoverage YES
```

### Test Coverage
- **Unit Tests** - Core business logic and data models
- **Integration Tests** - Manager classes and data persistence
- **UI Tests** - Critical user flows and accessibility
- **Performance Tests** - Memory usage and battery efficiency

## 🚀 Deployment

### Building for Release
```bash
# Archive for App Store
xcodebuild archive -scheme BreathEasy -configuration Release -archivePath ./build/BreathEasy.xcarchive

# Export IPA
xcodebuild -exportArchive -archivePath ./build/BreathEasy.xcarchive -exportPath ./build -exportOptionsPlist ExportOptions.plist
```

### App Store Guidelines
- **Privacy Nutrition Labels** - No data collection to report
- **Accessibility Compliance** - Full VoiceOver and accessibility support
- **Content Guidelines** - Health and wellness app category
- **Performance Standards** - Optimized for battery life and memory usage

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](./docs/CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and add tests
4. Ensure all tests pass: `xcodebuild test -scheme BreathEasy`
5. Commit your changes: `git commit -m 'Add amazing feature'`
6. Push to the branch: `git push origin feature/amazing-feature`
7. Open a Pull Request

### Code Style
- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use SwiftLint for code formatting
- Include unit tests for new features
- Document public APIs with documentation comments

## 🛠️ Troubleshooting

### Common Issues

#### Build Errors
```bash
# Clean build folder
rm -rf ~/Library/Developer/Xcode/DerivedData/BreathEasy-*

# Clean project
xcodebuild clean -scheme BreathEasy

# Rebuild
xcodebuild build -scheme BreathEasy
```

#### Simulator Issues
- **Audio not working** - Check simulator audio settings
- **Haptics not working** - Haptics don't work in simulator, test on device
- **Notifications not appearing** - Grant notification permissions in Settings

#### Data Issues
- **Settings not saving** - Check UserDefaults permissions
- **Sessions not recording** - Verify DataManager initialization
- **Badges not unlocking** - Check badge criteria in DataManager

### Getting Help
- **Documentation** - Check the [docs](./docs/) folder for detailed guides
- **Issues** - Report bugs on [GitHub Issues](https://github.com/rajkumar-natarajan/BreathEasy/issues)
- **Discussions** - Ask questions in [GitHub Discussions](https://github.com/rajkumar-natarajan/BreathEasy/discussions)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Scientific Research** - Based on proven breathing techniques from research institutions
- **Design Inspiration** - Influenced by mindfulness and meditation apps
- **Community Feedback** - Improved through user testing and feedback
- **Open Source Libraries** - Built with Swift and SwiftUI

## 🔗 Links

- **App Store** - [Coming Soon]
- **Website** - [breatheasy-app.com](https://breatheasy-app.com)
- **Privacy Policy** - [Privacy](./docs/PRIVACY.md)
- **Terms of Service** - [Terms](./docs/TERMS.md)
- **Support** - [support@breatheasy-app.com](mailto:support@breatheasy-app.com)

---

<p align="center">
  Made with ❤️ for mindful breathing and inner peace
</p>

<p align="center">
  <strong>Take a deep breath. You've got this.</strong>
</p>
