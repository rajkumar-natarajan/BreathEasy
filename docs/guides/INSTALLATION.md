# BreathEasy Installation Guide

This guide will help you install and set up BreathEasy on your iOS device or development environment.

## Table of Contents

1. [End User Installation](#end-user-installation)
2. [Developer Installation](#developer-installation)
3. [System Requirements](#system-requirements)
4. [Troubleshooting](#troubleshooting)
5. [First-Time Setup](#first-time-setup)

## End User Installation

### App Store Installation (Coming Soon)

BreathEasy will be available on the App Store:

1. **Search for BreathEasy**
   - Open the App Store on your iOS device
   - Search for "BreathEasy breathing"
   - Look for the app by Rajkumar Natarajan

2. **Download and Install**
   - Tap "Get" to download the app
   - Authenticate with Face ID, Touch ID, or your Apple ID password
   - Wait for the installation to complete

3. **Launch the App**
   - Tap the BreathEasy icon on your home screen
   - Complete the onboarding process
   - Grant optional permissions as desired

### TestFlight Beta Installation

Join our beta testing program:

1. **Get TestFlight**
   - Download TestFlight from the App Store (if not already installed)
   - TestFlight is Apple's official beta testing platform

2. **Join Beta Program**
   - Request beta access by emailing [beta@breatheasy-app.com](mailto:beta@breatheasy-app.com)
   - Include your Apple ID email address
   - Wait for beta invitation (usually within 24 hours)

3. **Install Beta Version**
   - Check your email for TestFlight invitation
   - Tap "View in TestFlight" link
   - Install the beta version
   - Provide feedback through TestFlight

## Developer Installation

### Prerequisites

Before installing for development:

#### Required Software
- **macOS Sonoma (14.0)** or later
- **Xcode 16.0** or later
- **iOS 18.5 SDK** or later
- **Git 2.30** or later

#### Development Account
- **Apple Developer Account** (for device testing)
- **GitHub Account** (for contributing)

### Clone from GitHub

#### Option 1: HTTPS Clone
```bash
# Clone the repository
git clone https://github.com/rajkumar-natarajan/BreathEasy.git

# Navigate to project directory
cd BreathEasy

# Verify the clone
ls -la
```

#### Option 2: SSH Clone (for contributors)
```bash
# Clone using SSH (requires SSH key setup)
git clone git@github.com:rajkumar-natarajan/BreathEasy.git

# Navigate to project directory
cd BreathEasy
```

#### Option 3: GitHub CLI
```bash
# Using GitHub CLI
gh repo clone rajkumar-natarajan/BreathEasy

# Navigate to project directory
cd BreathEasy
```

### Xcode Setup

#### 1. Open the Project
```bash
# Open in Xcode
open BreathEasy.xcodeproj

# Or use Xcode command line tools
xed .
```

#### 2. Configure Signing
1. Select "BreathEasy" project in the navigator
2. Select "BreathEasy" target
3. Go to "Signing & Capabilities" tab
4. Select your development team
5. Update bundle identifier if needed (e.g., `com.yourname.BreathEasy`)

#### 3. Select Destination
- Choose your connected iOS device or
- Select iPhone 16 Simulator (or your preferred simulator)

#### 4. Build and Run
```bash
# Clean build folder (if needed)
⌘ + Shift + K

# Build the project
⌘ + B

# Run on device/simulator
⌘ + R
```

### Development Dependencies

BreathEasy uses only Apple's native frameworks:

#### Frameworks Used
- **SwiftUI** - UI framework
- **Foundation** - Core functionality
- **AVFoundation** - Audio and speech
- **CoreHaptics** - Haptic feedback
- **UserNotifications** - Local notifications

#### No External Dependencies
- No CocoaPods or Swift Package Manager dependencies
- No third-party libraries or SDKs
- All functionality built with Apple frameworks

### Verification

#### Check Installation Success
1. **App Launches** - BreathEasy opens without crashes
2. **Onboarding Works** - Welcome flow completes successfully
3. **Basic Functionality** - Can start and complete a breathing session
4. **Settings Access** - Can navigate to and modify settings

#### Run Tests
```bash
# Run unit tests
xcodebuild test -scheme BreathEasy -destination 'platform=iOS Simulator,name=iPhone 16'

# Run UI tests
xcodebuild test -scheme BreathEasyUITests -destination 'platform=iOS Simulator,name=iPhone 16'
```

## System Requirements

### iOS Device Requirements

#### Minimum Requirements
- **iOS Version**: iOS 18.5 or later
- **Device**: iPhone SE (2nd generation) or newer
- **Storage**: 50 MB available space
- **Network**: None required (100% offline)

#### Recommended Requirements
- **iOS Version**: Latest iOS version
- **Device**: iPhone 12 or newer for optimal haptic feedback
- **Storage**: 100 MB for comfortable usage
- **Features**: Haptic Engine for enhanced experience

#### Compatibility
- **iPhone**: All models supporting iOS 18.5+
- **iPad**: All models supporting iOS 18.5+
- **iPod Touch**: Supported (limited haptic feedback)

### Development Requirements

#### Hardware Requirements
- **Mac**: Mac with Apple Silicon or Intel processor
- **RAM**: 8 GB minimum, 16 GB recommended
- **Storage**: 10 GB free space for Xcode and projects
- **Display**: Any resolution (Retina recommended)

#### Software Requirements
- **macOS**: Sonoma (14.0) or later
- **Xcode**: Version 16.0 or later
- **Command Line Tools**: Latest version
- **Git**: Version 2.30 or later

## Troubleshooting

### Common Installation Issues

#### App Store Installation Problems

**Issue**: Can't find BreathEasy in App Store
**Solution**: 
- Ensure you're in the correct regional App Store
- Check spelling ("BreathEasy" as one word)
- Search for "breathing exercises" or "mindfulness"

**Issue**: Download fails or gets stuck
**Solution**:
- Check internet connection
- Restart App Store app
- Sign out and back into Apple ID
- Restart device if necessary

#### Development Installation Problems

**Issue**: Xcode build fails
**Solutions**:
```bash
# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/BreathEasy-*

# Clean project
xcodebuild clean -project BreathEasy.xcodeproj

# Try building again
xcodebuild build -scheme BreathEasy
```

**Issue**: Code signing errors
**Solutions**:
1. Verify Apple Developer account is active
2. Check bundle identifier uniqueness
3. Regenerate certificates if needed
4. Select correct development team

**Issue**: Simulator not working
**Solutions**:
1. Update to latest Xcode version
2. Reset simulator: Device → Erase All Content and Settings
3. Try different simulator model
4. Restart Xcode and Simulator

#### Device-Specific Issues

**Issue**: Haptic feedback not working
**Solutions**:
- Check if device supports Haptic Engine
- Verify haptics are enabled in device settings
- Test with physical device (haptics don't work in simulator)
- Check BreathEasy haptic settings

**Issue**: Audio not working
**Solutions**:
- Check device volume and mute switch
- Test with headphones
- Verify audio permissions
- Check BreathEasy audio settings

### Getting Help

#### Community Support
- **GitHub Issues**: Report bugs and technical problems
- **GitHub Discussions**: Ask questions and get community help
- **Documentation**: Check existing guides and documentation

#### Direct Support
- **Email**: [support@breatheasy-app.com](mailto:support@breatheasy-app.com)
- **Response Time**: Usually within 24 hours
- **Include**: Device model, iOS version, specific error messages

## First-Time Setup

### Initial Launch

#### Welcome Flow
1. **Welcome Screen** - Introduction and overview
2. **Privacy Information** - Understanding data handling
3. **Feature Tour** - Key functionality overview
4. **Permission Requests** - Optional but recommended

#### Permission Setup

**Notifications**
- **Purpose**: Daily breathing reminders
- **Recommendation**: Enable for consistency
- **Privacy**: All notifications are local

**Haptic Feedback**
- **Purpose**: Tactile breathing guidance
- **Recommendation**: Enable for enhanced experience
- **Note**: Automatic on compatible devices

### Configuration

#### Basic Settings
1. **Breathing Pattern**: Start with 4-7-8 (great for beginners)
2. **Session Duration**: Begin with 5 minutes
3. **Audio Guidance**: Enable voice instructions initially
4. **Haptic Intensity**: Medium setting recommended

#### Customization
1. **Color Scheme**: Choose your preferred visual theme
2. **Reminder Time**: Set daily notification time
3. **Language**: Select English or Spanish
4. **Accessibility**: Enable if needed (high contrast, reduced motion)

### First Session

#### Getting Started
1. **Choose Default Pattern**: 4-7-8 breathing is beginner-friendly
2. **Set Short Duration**: Start with 2-3 minutes
3. **Find Quiet Space**: Minimize distractions
4. **Comfortable Position**: Sitting or lying down

#### During the Session
1. **Watch the Orb**: Follow the visual breathing guide
2. **Listen for Cues**: Audio instructions help maintain rhythm
3. **Feel the Vibrations**: Haptic feedback enhances timing
4. **Stay Relaxed**: Don't worry about perfect timing

#### After the Session
1. **Rate Your Mood**: Log how you feel after breathing
2. **Review Progress**: Check your first achievement badge
3. **Plan Next Session**: Consider when to practice again

### Building a Routine

#### Daily Practice Tips
- **Consistent Time**: Same time each day builds habits
- **Start Small**: 2-3 minutes is better than skipping
- **Track Progress**: Watch your streak counter grow
- **Explore Patterns**: Try different techniques over time

#### Success Metrics
- **Consistency**: Regular practice matters more than duration
- **Mood Improvement**: Notice emotional benefits over time
- **Achievement Progress**: Celebrate badge milestones
- **Personal Growth**: Adapt practice to your needs

---

**Congratulations on installing BreathEasy! You're now ready to begin your mindful breathing journey. Remember, consistency is more important than perfection.** 🌱
