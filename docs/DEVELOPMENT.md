# Development Guide - BreathEasy

## Overview

This guide provides everything you need to know to contribute to BreathEasy, from setting up your development environment to understanding the codebase architecture and best practices.

## Table of Contents

1. [Development Environment Setup](#development-environment-setup)
2. [Project Structure](#project-structure)
3. [Architecture Overview](#architecture-overview)
4. [Coding Standards](#coding-standards)
5. [Testing Strategy](#testing-strategy)
6. [Build and Deployment](#build-and-deployment)
7. [Contributing Guidelines](#contributing-guidelines)
8. [Debugging Tips](#debugging-tips)
9. [Performance Optimization](#performance-optimization)
10. [Release Process](#release-process)

## Development Environment Setup

### Prerequisites

#### Required Software
- **macOS Sonoma (14.0)** or later
- **Xcode 16.0** or later
- **iOS 18.5 SDK** or later
- **Git 2.30** or later

#### Recommended Tools
- **SF Symbols 6** - For consistent icon usage
- **Simulator** - iPhone 16/16 Pro for testing
- **Instruments** - Performance profiling
- **Reality Composer** - For future AR features

### Initial Setup

#### 1. Clone the Repository
```bash
# Clone the repository
git clone https://github.com/rajkumar-natarajan/BreathEasy.git
cd BreathEasy

# Verify the project structure
ls -la
```

#### 2. Open in Xcode
```bash
# Open the project in Xcode
open BreathEasy.xcodeproj

# Or use Xcode CLI tools
xed .
```

#### 3. Configure Development Team
1. Select the project in Xcode navigator
2. Go to "Signing & Capabilities"
3. Select your development team
4. Update bundle identifier if needed

#### 4. Verify Build Configuration
```bash
# Clean any existing build artifacts
xcodebuild clean -project BreathEasy.xcodeproj -scheme BreathEasy

# Build for simulator
xcodebuild build -project BreathEasy.xcodeproj -scheme BreathEasy -destination 'platform=iOS Simulator,name=iPhone 16'

# Run tests
xcodebuild test -project BreathEasy.xcodeproj -scheme BreathEasy -destination 'platform=iOS Simulator,name=iPhone 16'
```

### Development Configuration

#### Xcode Settings
Recommended Xcode preferences for consistent development:

```
Text Editing:
- Indentation: Spaces, 4 spaces per tab
- Line wrapping: Enabled at 120 characters
- Show line numbers: Enabled
- Code folding ribbon: Enabled

Source Control:
- Enable source control
- Refresh server status automatically
- Add and remove files automatically

Behaviors:
- Testing -> Starts: Show navigator "Test"
- Testing -> Succeeds: Hide navigator
- Build -> Fails: Show navigator "Issue"
```

#### Swift Package Manager
BreathEasy currently uses only built-in frameworks, but for future dependencies:

```swift
// Package.swift (if needed)
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "BreathEasy",
    platforms: [
        .iOS(.v18)
    ],
    dependencies: [
        // Future dependencies would go here
    ],
    targets: [
        .target(
            name: "BreathEasy",
            dependencies: []
        )
    ]
)
```

## Project Structure

### Directory Organization

```
BreathEasy/
├── BreathEasy/                 # Main application code
│   ├── Models/                 # Data models and business logic
│   │   ├── BreathingSession.swift
│   │   ├── BreathingPattern.swift
│   │   └── AppSettings.swift
│   ├── Views/                  # SwiftUI views
│   │   ├── HomeView.swift
│   │   ├── SessionView.swift
│   │   ├── HistoryView.swift
│   │   ├── SettingsView.swift
│   │   └── Components/         # Reusable view components
│   ├── ViewModels/            # Observable view models
│   │   ├── HomeViewModel.swift
│   │   └── SessionViewModel.swift
│   ├── Utilities/             # Helper classes and managers
│   │   ├── DataManager.swift
│   │   ├── HapticManager.swift
│   │   ├── SpeechManager.swift
│   │   └── Extensions/         # Swift extensions
│   ├── Resources/             # Localizable strings, assets
│   │   ├── Localizable.strings
│   │   └── Localizable-es.strings
│   ├── Assets.xcassets/       # Images, colors, app icons
│   ├── BreathEasyApp.swift    # App entry point
│   └── ContentView.swift      # Root content view
├── BreathEasyTests/           # Unit tests
├── BreathEasyUITests/         # UI automation tests
├── docs/                      # Documentation
└── README.md                  # Project overview
```

### File Naming Conventions

#### Swift Files
- **Models**: `ModelName.swift` (e.g., `BreathingSession.swift`)
- **Views**: `ViewName.swift` (e.g., `HomeView.swift`)
- **ViewModels**: `ViewNameViewModel.swift` (e.g., `HomeViewModel.swift`)
- **Managers**: `PurposeManager.swift` (e.g., `DataManager.swift`)
- **Extensions**: `TypeName+Extension.swift` (e.g., `Date+Formatting.swift`)

#### Asset Names
- **Images**: `snake_case` (e.g., `breathing_orb_background`)
- **Colors**: `camelCase` (e.g., `primaryBlue`, `breathingGreen`)
- **SF Symbols**: Use exact SF Symbols names (e.g., `lungs.fill`)

## Architecture Overview

### Design Patterns

#### MVVM (Model-View-ViewModel)
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    View     │───▶│ ViewModel   │───▶│    Model    │
│  (SwiftUI)  │    │(@Observable)│    │(Data Types) │
│             │◀───│             │◀───│             │
└─────────────┘    └─────────────┘    └─────────────┘
```

**Benefits:**
- Clear separation of concerns
- Testable business logic
- Reactive UI updates
- Reusable view models

#### Observable Pattern
```swift
@Observable
class SessionViewModel {
    var isActive = false
    var currentPhase: BreathingPhase = .inhale
    var timeRemaining: TimeInterval = 0
    
    func startSession() {
        isActive = true  // Automatically updates UI
    }
}
```

**Benefits:**
- Automatic UI updates when state changes
- No manual binding management
- Better performance than ObservableObject
- Simpler syntax

#### Singleton Pattern
```swift
class DataManager {
    static let shared = DataManager()
    private init() {}
    
    // Shared state and methods
}
```

**Usage:**
- DataManager: Shared data access
- HapticManager: Device haptic coordination
- SpeechManager: Audio synthesis coordination

### Data Flow Architecture

#### Session Creation Flow
```
HomeView
   ↓ (user selects pattern)
HomeViewModel
   ↓ (validates input)
SessionView
   ↓ (creates session)
SessionViewModel
   ↓ (manages timing)
DataManager
   ↓ (persists data)
UserDefaults
```

#### Settings Update Flow
```
SettingsView
   ↓ (user changes setting)
@State binding
   ↓ (triggers onChange)
DataManager.updateSettings()
   ↓ (updates shared state)
Dependent Views
   ↓ (react to changes)
UI Updates
```

## Coding Standards

### Swift Style Guide

#### General Principles
- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use clear, descriptive names
- Prefer explicitness over brevity
- Maintain consistency throughout the codebase

#### Naming Conventions

```swift
// MARK: - Types
struct BreathingSession { }           // PascalCase for types
enum BreathingPhase { }              // PascalCase for enums
class SessionViewModel { }           // PascalCase for classes

// MARK: - Variables and Functions
var sessionDuration: TimeInterval    // camelCase for properties
func startBreathingSession() { }     // camelCase for functions
let defaultTiming: BreathingTiming   // camelCase for constants

// MARK: - Constants
private let kMaxSessionDuration = 30 // k prefix for file-level constants
static let shared = DataManager()    // shared for singletons

// MARK: - Enums
enum BreathingPhase {
    case inhale                      // lowercase for enum cases
    case hold
    case exhale
    case pause
}
```

#### Code Organization

```swift
// MARK: - File Structure Template
//
//  FileName.swift
//  BreathEasy
//
//  Created by [Author] on [Date].
//

import Foundation
import SwiftUI

/// Brief description of the class/struct purpose
class/struct TypeName {
    
    // MARK: - Properties
    
    // MARK: - Initialization
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
}

// MARK: - Extensions

extension TypeName {
    // Related functionality
}

// MARK: - Preview

#Preview {
    TypeName()
}
```

#### Documentation Standards

```swift
/// Manages breathing session state and timing during active sessions.
/// 
/// This view model coordinates the breathing session lifecycle, including:
/// - Phase timing and transitions
/// - Visual animation synchronization  
/// - Audio and haptic feedback coordination
/// - Session completion and data saving
@Observable
class SessionViewModel {
    
    /// The current breathing phase (inhale, hold, exhale, pause)
    private(set) var currentPhase: BreathingPhase = .inhale
    
    /// Starts a new breathing session with the specified parameters.
    /// 
    /// - Parameters:
    ///   - pattern: The breathing pattern to use
    ///   - duration: Total session length in seconds
    ///   - moodBefore: Optional pre-session mood rating
    /// - Note: This method initializes all timers and begins the session immediately
    func startSession(
        pattern: BreathingPattern, 
        duration: TimeInterval, 
        moodBefore: MoodLevel? = nil
    ) {
        // Implementation
    }
}
```

### SwiftUI Best Practices

#### View Composition
```swift
// GOOD: Break complex views into smaller components
struct HomeView: View {
    var body: some View {
        VStack {
            headerSection
            quickStartSection  
            statsSection
        }
    }
    
    private var headerSection: some View {
        VStack {
            greetingText
            streakCounter
        }
    }
}

// AVOID: Monolithic view builders
struct HomeView: View {
    var body: some View {
        VStack {
            // 100+ lines of view code
        }
    }
}
```

#### State Management
```swift
// GOOD: Use @Observable for view models
@Observable
class HomeViewModel {
    var selectedPattern: BreathingPattern = .fourSevenEight
    var sessionDuration: TimeInterval = 300
}

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
}

// GOOD: Use @State for simple view-specific state
struct SettingsView: View {
    @State private var showingAlert = false
    @State private var selectedTab = 0
}

// AVOID: @State for complex business logic
struct HomeView: View {
    @State private var sessions: [BreathingSession] = []
    @State private var badges: Set<BreathingBadge> = []
    // This should be in a ViewModel or Manager
}
```

#### Performance Optimization
```swift
// GOOD: Use computed properties for derived state
struct StatsView: View {
    let sessions: [BreathingSession]
    
    private var totalTime: TimeInterval {
        sessions.reduce(0) { $0 + $1.duration }
    }
    
    private var averageSession: TimeInterval {
        guard !sessions.isEmpty else { return 0 }
        return totalTime / TimeInterval(sessions.count)
    }
}

// GOOD: Minimize view updates with @Observable
@Observable  
class DataManager {
    private(set) var sessions: [BreathingSession] = []
    
    func addSession(_ session: BreathingSession) {
        sessions.append(session)  // Only sessions-dependent views update
    }
}
```

### Error Handling

#### Result Types
```swift
// Use Result for operations that can fail
func loadSessionData() -> Result<[BreathingSession], DataError> {
    do {
        let data = try loadData()
        let sessions = try JSONDecoder().decode([BreathingSession].self, from: data)
        return .success(sessions)
    } catch {
        return .failure(.decodingError(error))
    }
}

enum DataError: LocalizedError {
    case fileNotFound
    case decodingError(Error)
    case insufficientStorage
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Session data file not found"
        case .decodingError(let error):
            return "Failed to decode session data: \(error.localizedDescription)"
        case .insufficientStorage:
            return "Insufficient storage space to save session"
        }
    }
}
```

#### Optional Handling
```swift
// GOOD: Use guard for early returns
func processSession(_ session: BreathingSession?) {
    guard let session = session else {
        logger.warning("No session provided")
        return
    }
    
    // Process session
}

// GOOD: Use nil coalescing for defaults
let duration = session?.duration ?? 300.0
let mood = session?.moodAfter ?? .neutral

// AVOID: Force unwrapping
let duration = session!.duration  // Dangerous!
```

## Testing Strategy

### Test Organization

```
BreathEasyTests/
├── Models/
│   ├── BreathingSessionTests.swift
│   ├── BreathingPatternTests.swift
│   └── AppSettingsTests.swift
├── ViewModels/
│   ├── HomeViewModelTests.swift
│   └── SessionViewModelTests.swift
├── Utilities/
│   ├── DataManagerTests.swift
│   ├── HapticManagerTests.swift
│   └── SpeechManagerTests.swift
└── Helpers/
    ├── TestHelpers.swift
    └── MockData.swift
```

### Unit Testing

#### Model Tests
```swift
import XCTest
@testable import BreathEasy

final class BreathingSessionTests: XCTestCase {
    
    func testSessionInitialization() {
        // Given
        let pattern = BreathingPattern.fourSevenEight
        let duration: TimeInterval = 300
        let cycles = 10
        
        // When
        let session = BreathingSession(
            pattern: pattern,
            duration: duration,
            cycles: cycles
        )
        
        // Then
        XCTAssertEqual(session.pattern, pattern)
        XCTAssertEqual(session.duration, duration)
        XCTAssertEqual(session.cycles, cycles)
        XCTAssertNotNil(session.id)
        XCTAssertNotNil(session.date)
    }
    
    func testSessionCodableCompliance() {
        // Given
        let originalSession = BreathingSession(
            pattern: .box,
            duration: 600,
            cycles: 20,
            moodBefore: .stressed,
            moodAfter: .calm
        )
        
        // When
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        do {
            let data = try encoder.encode(originalSession)
            let decodedSession = try decoder.decode(BreathingSession.self, from: data)
            
            // Then
            XCTAssertEqual(originalSession.id, decodedSession.id)
            XCTAssertEqual(originalSession.pattern, decodedSession.pattern)
            XCTAssertEqual(originalSession.duration, decodedSession.duration)
            XCTAssertEqual(originalSession.moodBefore, decodedSession.moodBefore)
            XCTAssertEqual(originalSession.moodAfter, decodedSession.moodAfter)
        } catch {
            XCTFail("Encoding/Decoding failed: \(error)")
        }
    }
}
```

#### ViewModel Tests
```swift
import XCTest
@testable import BreathEasy

final class SessionViewModelTests: XCTestCase {
    
    var viewModel: SessionViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SessionViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testSessionInitialization() {
        // Given
        let pattern = BreathingPattern.box
        let duration: TimeInterval = 300
        let mood = MoodLevel.neutral
        
        // When
        viewModel.startSession(pattern: pattern, duration: duration, moodBefore: mood)
        
        // Then
        XCTAssertTrue(viewModel.isActive)
        XCTAssertEqual(viewModel.sessionTimeRemaining, duration)
        XCTAssertEqual(viewModel.currentPhase, .inhale)
        XCTAssertEqual(viewModel.moodBefore, mood)
    }
    
    func testPhaseTransitions() {
        // Given
        viewModel.startSession(pattern: .box, duration: 60, moodBefore: nil)
        let initialPhase = viewModel.currentPhase
        
        // When
        let expectation = XCTestExpectation(description: "Phase transition")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.1) {
            // Then
            XCTAssertNotEqual(self.viewModel.currentPhase, initialPhase)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
```

#### Manager Tests
```swift
import XCTest
@testable import BreathEasy

final class DataManagerTests: XCTestCase {
    
    var dataManager: DataManager!
    
    override func setUp() {
        super.setUp()
        dataManager = DataManager()
        // Clear any existing data for clean tests
        dataManager.clearAllData()
    }
    
    func testSessionSaving() {
        // Given
        let session = BreathingSession(
            pattern: .fourSevenEight,
            duration: 300,
            cycles: 15
        )
        
        // When
        dataManager.saveSession(session)
        
        // Then
        XCTAssertEqual(dataManager.sessions.count, 1)
        XCTAssertEqual(dataManager.sessions.first?.id, session.id)
    }
    
    func testBadgeEarning() {
        // Given
        XCTAssertTrue(dataManager.earnedBadges.isEmpty)
        
        // When
        let session = BreathingSession(pattern: .box, duration: 300, cycles: 10)
        dataManager.saveSession(session)
        
        // Then
        XCTAssertTrue(dataManager.earnedBadges.contains(.firstSession))
    }
    
    func testStreakCalculation() {
        // Given
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let today = Date()
        
        // When
        let session1 = BreathingSession(pattern: .box, duration: 300, cycles: 10)
        let session2 = BreathingSession(pattern: .fourSevenEight, duration: 240, cycles: 8)
        
        // Manually set dates for testing
        var modifiedSession1 = session1
        var modifiedSession2 = session2
        // Note: In actual implementation, you'd need to make date mutable or use dependency injection
        
        dataManager.saveSession(session1)
        dataManager.saveSession(session2)
        
        // Then
        XCTAssertEqual(dataManager.currentStreak, 2)
    }
}
```

### UI Testing

#### Basic UI Tests
```swift
import XCTest

final class BreathEasyUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testBasicNavigation() {
        // Test tab navigation
        XCTAssertTrue(app.tabBars.buttons["Home"].exists)
        XCTAssertTrue(app.tabBars.buttons["History"].exists)
        XCTAssertTrue(app.tabBars.buttons["Achievements"].exists)
        
        // Navigate to History
        app.tabBars.buttons["History"].tap()
        XCTAssertTrue(app.navigationBars["History"].exists)
        
        // Navigate to Achievements
        app.tabBars.buttons["Achievements"].tap()
        XCTAssertTrue(app.navigationBars["Achievements"].exists)
    }
    
    func testSessionFlow() {
        // Start a session
        let startButton = app.buttons["Start Session"]
        XCTAssertTrue(startButton.exists)
        startButton.tap()
        
        // Verify session view appears
        XCTAssertTrue(app.staticTexts["Inhale"].exists)
        
        // Wait for phase transition
        let exhaleText = app.staticTexts["Exhale"]
        XCTAssertTrue(exhaleText.waitForExistence(timeout: 5.0))
        
        // End session early
        let pauseButton = app.buttons["Pause"]
        if pauseButton.exists {
            pauseButton.tap()
            
            let endButton = app.buttons["End Session"]
            if endButton.exists {
                endButton.tap()
            }
        }
        
        // Verify return to home
        XCTAssertTrue(app.buttons["Start Session"].waitForExistence(timeout: 3.0))
    }
    
    func testAccessibility() {
        // Enable accessibility testing
        app.accessibilityActivate()
        
        // Test VoiceOver labels
        let startButton = app.buttons["Start Session"]
        XCTAssertTrue(startButton.isAccessibilityElement)
        XCTAssertNotNil(startButton.accessibilityLabel)
        XCTAssertNotNil(startButton.accessibilityHint)
        
        // Test navigation accessibility
        let historyTab = app.tabBars.buttons["History"]
        XCTAssertTrue(historyTab.isAccessibilityElement)
        XCTAssertEqual(historyTab.accessibilityTraits, .button)
    }
}
```

### Performance Testing

```swift
import XCTest
@testable import BreathEasy

final class BreathEasyPerformanceTests: XCTestCase {
    
    func testDataManagerPerformance() {
        let dataManager = DataManager()
        
        // Test saving many sessions
        measure {
            for i in 0..<1000 {
                let session = BreathingSession(
                    pattern: .box,
                    duration: TimeInterval(i % 600 + 60),
                    cycles: i % 50 + 1
                )
                dataManager.saveSession(session)
            }
        }
    }
    
    func testSessionViewModelMemoryUsage() {
        measure(metrics: [XCTMemoryMetric()]) {
            let viewModel = SessionViewModel()
            viewModel.startSession(pattern: .fourSevenEight, duration: 300, moodBefore: nil)
            
            // Simulate session completion
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
            
            viewModel.endSession(moodAfter: .calm)
        }
    }
}
```

### Test Utilities

#### Mock Data
```swift
// TestHelpers.swift
import Foundation
@testable import BreathEasy

struct MockData {
    
    static func createSession(
        pattern: BreathingPattern = .box,
        duration: TimeInterval = 300,
        cycles: Int = 15,
        moodBefore: MoodLevel? = nil,
        moodAfter: MoodLevel? = nil
    ) -> BreathingSession {
        return BreathingSession(
            pattern: pattern,
            duration: duration,
            cycles: cycles,
            moodBefore: moodBefore,
            moodAfter: moodAfter
        )
    }
    
    static func createSessions(count: Int) -> [BreathingSession] {
        return (0..<count).map { i in
            createSession(
                pattern: BreathingPattern.allCases[i % BreathingPattern.allCases.count],
                duration: TimeInterval(i % 600 + 60),
                cycles: i % 50 + 1
            )
        }
    }
    
    static var sampleSettings: AppSettings {
        var settings = AppSettings()
        settings.enableSoundCues = true
        settings.enableHaptics = true
        settings.hapticIntensity = .medium
        settings.colorScheme = .blue
        return settings
    }
}
```

## Build and Deployment

### Build Configurations

#### Debug Configuration
```
// Debug.xcconfig
SWIFT_OPTIMIZATION_LEVEL = -Onone
SWIFT_COMPILATION_MODE = incremental
GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1
ENABLE_TESTABILITY = YES
```

#### Release Configuration
```
// Release.xcconfig
SWIFT_OPTIMIZATION_LEVEL = -O
SWIFT_COMPILATION_MODE = wholemodule
GCC_PREPROCESSOR_DEFINITIONS = 
ENABLE_TESTABILITY = NO
```

### Build Scripts

#### Clean Build
```bash
#!/bin/bash
# scripts/clean_build.sh

echo "🧹 Cleaning BreathEasy..."

# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/BreathEasy-*

# Clean project
xcodebuild clean -project BreathEasy.xcodeproj -scheme BreathEasy

echo "✅ Clean complete"
```

#### Run Tests
```bash
#!/bin/bash
# scripts/run_tests.sh

echo "🧪 Running BreathEasy tests..."

# Unit tests
echo "Running unit tests..."
xcodebuild test \
    -project BreathEasy.xcodeproj \
    -scheme BreathEasy \
    -destination 'platform=iOS Simulator,name=iPhone 16' \
    -only-testing BreathEasyTests

# UI tests
echo "Running UI tests..."
xcodebuild test \
    -project BreathEasy.xcodeproj \
    -scheme BreathEasy \
    -destination 'platform=iOS Simulator,name=iPhone 16' \
    -only-testing BreathEasyUITests

echo "✅ Tests complete"
```

#### Build for Release
```bash
#!/bin/bash
# scripts/build_release.sh

echo "🚀 Building BreathEasy for release..."

# Create archive
xcodebuild archive \
    -project BreathEasy.xcodeproj \
    -scheme BreathEasy \
    -configuration Release \
    -archivePath ./build/BreathEasy.xcarchive

# Export IPA
xcodebuild -exportArchive \
    -archivePath ./build/BreathEasy.xcarchive \
    -exportPath ./build \
    -exportOptionsPlist ExportOptions.plist

echo "✅ Release build complete"
```

### Continuous Integration

#### GitHub Actions Workflow
```yaml
# .github/workflows/ios.yml
name: iOS CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Select Xcode
      run: sudo xcode-select -switch /Applications/Xcode_16.0.app/Contents/Developer
    
    - name: Build and Test
      run: |
        xcodebuild clean test \
          -project BreathEasy.xcodeproj \
          -scheme BreathEasy \
          -destination 'platform=iOS Simulator,name=iPhone 16' \
          -enableCodeCoverage YES
    
    - name: Upload Coverage
      uses: codecov/codecov-action@v3
      with:
        token: ${{ secrets.CODECOV_TOKEN }}
```

## Contributing Guidelines

### Git Workflow

#### Branch Strategy
```
main                    (Production releases)
├── develop             (Integration branch)
│   ├── feature/xyz     (Feature branches)
│   ├── bugfix/abc      (Bug fix branches)
│   └── hotfix/def      (Critical fixes)
```

#### Commit Messages
Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add custom breathing pattern creation
fix: resolve session timer accuracy issue
docs: update API documentation for DataManager
style: improve breathing orb animation smoothness
refactor: extract haptic feedback into separate manager
test: add unit tests for mood tracking functionality
chore: update dependencies to latest versions
```

#### Pull Request Process
1. **Create Feature Branch**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/custom-patterns
   ```

2. **Make Changes**
   - Write code following style guidelines
   - Add tests for new functionality
   - Update documentation as needed

3. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: add custom breathing pattern creation"
   ```

4. **Push and Create PR**
   ```bash
   git push origin feature/custom-patterns
   # Create PR via GitHub UI
   ```

5. **PR Requirements**
   - [ ] All tests pass
   - [ ] Code coverage maintained
   - [ ] Documentation updated
   - [ ] No breaking changes (or properly documented)
   - [ ] Accessibility verified

### Code Review Checklist

#### Functionality
- [ ] Code works as intended
- [ ] Edge cases are handled
- [ ] Error conditions are managed appropriately
- [ ] Performance impact is acceptable

#### Code Quality
- [ ] Follows established coding standards
- [ ] No code duplication
- [ ] Proper error handling
- [ ] Comprehensive test coverage

#### Documentation
- [ ] Public APIs are documented
- [ ] Complex logic is explained
- [ ] README updated if needed
- [ ] Breaking changes are noted

#### Accessibility
- [ ] VoiceOver labels are present
- [ ] Dynamic Type is supported
- [ ] High contrast mode works
- [ ] Keyboard navigation functions

### Release Process

#### Version Numbering
Follow [Semantic Versioning](https://semver.org/):
- **Major** (1.0.0): Breaking changes
- **Minor** (1.1.0): New features, backward compatible
- **Patch** (1.1.1): Bug fixes, backward compatible

#### Release Checklist
1. **Pre-Release**
   - [ ] All tests pass
   - [ ] Performance regression tests
   - [ ] Accessibility audit
   - [ ] Documentation review

2. **Release Preparation**
   - [ ] Update version numbers
   - [ ] Update CHANGELOG.md
   - [ ] Create release notes
   - [ ] Tag release in Git

3. **App Store Submission**
   - [ ] Build archive
   - [ ] Upload to App Store Connect
   - [ ] Complete app information
   - [ ] Submit for review

4. **Post-Release**
   - [ ] Monitor crash reports
   - [ ] Gather user feedback
   - [ ] Plan next iteration

---

This development guide provides the foundation for maintaining and extending BreathEasy. Always prioritize code quality, user experience, and accessibility in your contributions.
