# BreathEasy 🍃

<p align="center">
  <strong>A world-class mindfulness and breathing app featuring the comprehensive Serenity Design System</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-18.5+-blue.svg" alt="iOS Version">
  <img src="https://img.shields.io/badge/Swift-5.9+-orange.svg" alt="Swift Version">
  <img src="https://img.shields.io/badge/Xcode-15.0+-blue.svg" alt="Xcode Version">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/Design%20System-Serenity-purple.svg" alt="Design System">
</p>

---

## ✨ What's New - Complete UI Transformation

### 🎨 Serenity Design System
A comprehensive wellness-focused design system built on psychological principles for calm:

- **🌈 Nature-Inspired Colors**: Soft sky blue, sage green, lavender mist, ocean teal
- **✍️ SF Pro Typography**: Zen-inspired spacing with breath-like hierarchy  
- **🌊 Fluid Animations**: Breath-synchronized transitions (4s inhale, 6s exhale, 2s pause)
- **💫 Neumorphic Components**: Floating cards with gentle shadows for organic feel
- **🧘‍♀️ Particle Effects**: Ambient floating particles for zen atmosphere

### 🎯 Enhanced Features

#### 🫁 Advanced Breathing Experience
- **Interactive Breathing Orb**: Fluid particle-enhanced animations guide your breath
- **Real-time Phase Indicators**: Visual and textual cues for each breathing phase
- **Custom Pattern Creator**: Interactive timing sliders with live preview
- **6 Beautiful Themes**: Adaptive, Ocean, Forest, Sunset, Lavender, Minimal

#### 📊 Comprehensive Analytics
- **Streak Visualization**: Beautiful progress rings showing daily consistency
- **Mood Correlation**: Pre/post session emotional tracking with trend analysis
- **Weekly Insights**: Detailed stats with improvement indicators
- **Session History**: Complete log with pattern usage and mood progression

#### 🎭 Personalization & Accessibility
- **Theme Customization**: 6 carefully crafted color schemes for different moods
- **Haptic Feedback**: Gentle vibrations synchronized with breathing rhythm
- **Adaptive Interface**: Responds to system dark mode and accessibility settings
- **Enhanced Navigation**: Tab-based structure with smooth transitions

### 🏗️ Technical Excellence

#### Modern iOS Architecture
- **SwiftUI**: Complete declarative UI with state management
- **Observation Framework**: Reactive data binding for smooth performance
- **Design Tokens**: Consistent spacing, typography, and color system
- **Component Library**: Reusable SerenityButton, BreathingOrb, ProgressRing

#### Enhanced Data Management
- **Session Analytics**: Comprehensive tracking with mood correlation
- **Custom Pattern Storage**: User-created patterns with full persistence
- **Progress Calculation**: Advanced streak and improvement algorithms
- **Data Visualization**: Beautiful charts and progress indicators

## 🌟 Core Features

### Breathing Patterns & Techniques
1. **4-7-8 Breathing** - Anxiety relief and sleep preparation
2. **Box Breathing** - Focus enhancement and stress reduction  
3. **Diaphragmatic** - Deep relaxation and nervous system reset
4. **Resonant Breathing** - Heart rate variability optimization
5. **Custom Patterns** - Design your own breathing rhythms

### Session Experience
- **Guided Sessions**: 1-60 minute customizable durations
- **Visual Guidance**: Animated breathing orb with particle effects
- **Phase Tracking**: Real-time progress through inhale/hold/exhale/pause
- **Completion Celebration**: Beautiful animations and mood comparison

### Privacy & Security
- **100% Offline**: No internet required, all data stays on device
- **Privacy-First**: Zero data collection, no analytics, no tracking
- **Local Storage**: UserDefaults for lightweight, secure data persistence

## 🏗️ Architecture & Technical Details

### Project Structure
```
BreathEasy/
├── App/
│   ├── BreathEasyApp.swift          # App entry with Serenity launch screen
│   └── ContentView.swift            # Legacy compatibility view
├── Models/
│   ├── BreathingPattern.swift       # Core breathing pattern definitions
│   ├── BreathingSession.swift       # Session data model with mood tracking
│   ├── DataManager.swift            # Enhanced data persistence layer
│   └── ModelCompatibility.swift     # Bridge for enhanced UI components
├── Views/
│   ├── Design/                      # 🎨 Serenity Design System
│   │   ├── SerenityDesignSystem.swift     # Core design tokens
│   │   ├── SerenityComponents.swift       # Button, Card, Orb components
│   │   ├── SerenityLaunchScreen.swift     # Lotus animation launch
│   │   ├── SerenityHomeView.swift         # Pattern carousel home
│   │   └── SerenityContentView.swift      # Tab navigation system
│   ├── Components/                  # Enhanced UI Components
│   │   ├── EnhancedBreathingOrbView.swift # Particle-enhanced orb
│   │   ├── EnhancedColorScheme.swift      # 6-theme color system
│   │   └── ModernCard.swift               # Neumorphic card design
│   ├── Session/                     # Session Management
│   │   ├── SessionView.swift              # Immersive session experience
│   │   └── SessionCompleteView.swift      # Completion celebration
│   └── Settings/                    # Preferences & Customization
│       └── ColorSchemeSettingsView.swift # Theme selection interface
└── Assets.xcassets/                 # App icons and visual assets
```

### Design System Components

#### 🎨 Serenity Color Palette
```swift
// Nature-inspired colors for psychological calm
static let softSkyBlue = Color(hex: "#A7C7E7")     // Trust, clarity
static let sageGreen = Color(hex: "#B2D8B2")       // Growth, harmony  
static let lavenderMist = Color(hex: "#D7BDE2")    // Relaxation, healing
static let oceanTeal = Color(hex: "#87CEEB")       // Stability, depth
static let warmOffWhite = Color(hex: "#F8F9FA")    # Light backgrounds
static let deepCharcoal = Color(hex: "#2C3E50")    # Dark mode support
```

#### ✍️ Typography System
```swift
// SF Pro with zen-inspired spacing
hero:        48pt, thin     # App launch moments
largeTitle:  32pt, thin     # Major section headers
title2:      24pt, light    # Card titles and emphasis
body:        17pt, regular  # Primary readable content
callout:     16pt, regular  # Secondary information
caption:     12pt, regular  # Supporting details
```

#### 🌊 Animation Durations
```swift
// Breath-synchronized timing
inhale:      4.0s    # Calming inward breath
hold:        1.0s    # Gentle pause
exhale:      6.0s    # Relaxing outward breath  
pause:       1.0s    # Natural rest
quick:       0.2s    # UI micro-interactions
smooth:      0.3s    # Component transitions
```

## 🚀 Getting Started

### Prerequisites
- **iOS 18.5+** (Uses latest SwiftUI features)
- **Xcode 15.0+** (Swift 5.9+ with Observation framework)
- **macOS Sonoma+** (For development environment)

### Installation

#### Clone and Build
```bash
# Clone the repository
git clone https://github.com/rajkumar-natarajan/BreathEasy.git
cd BreathEasy

# Open in Xcode
open BreathEasy.xcodeproj

# Build and run
# Select your target device/simulator and press ⌘+R
```

### Quick Start
1. **Launch**: Beautiful lotus animation welcomes you to serenity
2. **Explore**: Browse breathing patterns with visual previews  
3. **Practice**: Start your first session with guided breathing orb
4. **Track**: Monitor progress with mood correlation and streaks
5. **Customize**: Choose themes and create custom patterns

## 📖 User Guide

### 🏠 Home Experience
- **Pattern Carousel**: Swipe through breathing techniques with animated previews
- **Quick Start**: One-tap access to immediate breathing session
- **Progress Rings**: Visual streak tracking with completion celebration  
- **Mood Check-in**: Emotional state logging for session personalization

### 🫁 Session Flow  
1. **Pre-Session Mood**: Select current emotional state with emoji interface
2. **Pattern Visualization**: Preview breathing rhythm with timing breakdown
3. **Guided Practice**: Follow animated breathing orb with particle effects
4. **Real-time Guidance**: Phase indicators with breath timing
5. **Completion**: Mood comparison and session achievement celebration

### 📊 Analytics & Insights
- **Daily Dashboard**: Sessions, minutes, and streak visualization
- **Weekly Trends**: Progress charts with improvement indicators
- **Session History**: Complete log with pattern and mood correlation  
- **Mood Analytics**: Emotional improvement tracking over time

### 🎨 Personalization
- **6 Theme Options**: Adaptive, Ocean, Forest, Sunset, Lavender, Minimal
- **Custom Patterns**: Interactive timing sliders with live preview
- **Notification Settings**: Gentle reminders for daily practice
- **Accessibility**: VoiceOver, reduced motion, and contrast options

## 🧪 Testing & Quality

### Validated Features ✅
- **Complete UI Integration**: All components working seamlessly
- **Compilation Success**: Zero errors with `BUILD SUCCEEDED`
- **Cross-Platform**: Tested on iOS simulator and device
- **Performance**: Smooth 60fps animations with optimized memory usage
- **Accessibility**: VoiceOver compatible with semantic labels

### Design System Validation
- **Color Contrast**: WCAG AA compliant contrast ratios
- **Typography Scale**: Readable hierarchy across all screen sizes  
- **Animation Performance**: Smooth on devices back to iOS 18.5
- **Component Consistency**: Unified spacing and styling throughout

## � Future Roadmap

### Planned Features
- **🍎 Health Integration**: Sync with Apple Health for comprehensive wellness tracking
- **⌚ Apple Watch**: Native watchOS app with haptic breathing guidance
- **☁️ CloudKit Sync**: Cross-device session synchronization  
- **🤖 ML Insights**: Personalized breathing recommendations based on usage patterns
- **🔊 Sound Library**: Expanded breathing sounds and nature audio collection
- **🧘‍♀️ Guided Meditations**: Integrated mindfulness content with expert guidance

### Technical Enhancements
- **🎛️ Widget Support**: Home screen breathing reminders and quick stats
- **🗣️ Siri Integration**: Voice commands for hands-free session starting
- **📱 Dynamic Island**: Live breathing session progress on iPhone 14 Pro+
- **🌐 Localization**: Multi-language support with cultural breathing practices

## 🤝 Contributing

We welcome contributions that enhance the mindfulness experience! Here's how to get involved:

### 🎨 Design Contributions
- **New Themes**: Create color schemes following Serenity principles
- **Enhanced Animations**: Improve breathing orb and transition effects
- **Accessibility**: Better support for users with different abilities
- **Iconography**: Custom SF Symbols and breathing pattern illustrations

### 💻 Development Contributions  
- **Performance**: Optimize animations and memory usage
- **Features**: New breathing patterns and wellness techniques
- **Bug Fixes**: Improve stability and user experience
- **Testing**: Expand unit tests and UI automation

### 🔄 Contribution Process
1. **Fork** the repository and create a feature branch
2. **Follow** Serenity Design System guidelines for consistency
3. **Test** thoroughly on multiple devices and accessibility settings
4. **Document** changes with clear commit messages and PR descriptions
5. **Submit** pull request with screenshots/videos of changes

## 📄 License & Acknowledgments

### License
This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

### Design Inspiration  
- **Headspace**: Meditation app UI patterns and user flows
- **Calm**: Color psychology and breathing exercise techniques
- **Apple Human Interface Guidelines**: iOS design principles and accessibility
- **Material Design**: Component architecture and motion principles

### Technical Acknowledgments
- **SF Pro Typography**: Apple's system font for optimal readability
- **SwiftUI Framework**: Declarative UI enabling smooth animations
- **Breathing Research**: Scientific studies on stress reduction and mindfulness
- **Color Theory**: Psychological research on colors for mental health

### Special Thanks
- **Beta Testers**: Early users who provided valuable feedback
- **Mental Health Advocates**: Experts who validated breathing techniques  
- **Design Community**: Inspiration from wellness and mindfulness design
- **Open Source**: Contributors who make this project better

## 📞 Support & Community

### Get Help
- **📧 Email**: [support@breatheasy.app](mailto:support@breatheasy.app)
- **🐛 Issues**: [GitHub Issues](https://github.com/rajkumar-natarajan/BreathEasy/issues) for bugs and feature requests
- **📖 Documentation**: [Wiki](https://github.com/rajkumar-natarajan/BreathEasy/wiki) for detailed guides
- **💬 Discussions**: [GitHub Discussions](https://github.com/rajkumar-natarajan/BreathEasy/discussions) for community support

### Connect With Us
- **🐦 Twitter**: [@BreathEasyApp](https://twitter.com/BreathEasyApp) for updates and tips
- **📷 Instagram**: [@breatheasy.app](https://instagram.com/breatheasy.app) for mindfulness content
- **🎥 YouTube**: [BreathEasy Channel](https://youtube.com/breatheasy) for guided sessions

---

<p align="center">
  <strong>Made with 💚 for mindfulness and mental well-being</strong>
  <br>
  <em>Find your calm, one breath at a time</em> 🍃
</p>

<p align="center">
  <img src="https://img.shields.io/github/stars/rajkumar-natarajan/BreathEasy?style=social" alt="GitHub Stars">
  <img src="https://img.shields.io/github/forks/rajkumar-natarajan/BreathEasy?style=social" alt="GitHub Forks">
  <img src="https://img.shields.io/github/watchers/rajkumar-natarajan/BreathEasy?style=social" alt="GitHub Watchers">
</p>
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
