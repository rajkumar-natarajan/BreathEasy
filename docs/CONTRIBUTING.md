# Contributing to BreathEasy

First off, thank you for considering contributing to BreathEasy! 🙏 It's people like you that make BreathEasy such a great tool for mindful breathing and wellness.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [How Can I Contribute?](#how-can-i-contribute)
4. [Development Process](#development-process)
5. [Style Guidelines](#style-guidelines)
6. [Testing Requirements](#testing-requirements)
7. [Pull Request Process](#pull-request-process)
8. [Community Guidelines](#community-guidelines)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [support@breatheasy-app.com](mailto:support@breatheasy-app.com).

### Our Pledge

We are committed to making participation in this project a harassment-free experience for everyone, regardless of:
- Age, body size, disability, ethnicity, gender identity and expression
- Level of experience, education, socio-economic status
- Nationality, personal appearance, race, religion
- Sexual identity and orientation

## Getting Started

### Prerequisites

Before contributing, ensure you have:
- **macOS Sonoma (14.0)** or later
- **Xcode 16.0** or later with iOS 18.5 SDK
- **Git 2.30** or later
- Basic familiarity with Swift and SwiftUI
- Understanding of iOS app development

### Development Setup

1. **Fork the Repository**
   ```bash
   # Go to https://github.com/rajkumar-natarajan/BreathEasy
   # Click "Fork" button
   ```

2. **Clone Your Fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/BreathEasy.git
   cd BreathEasy
   ```

3. **Add Upstream Remote**
   ```bash
   git remote add upstream https://github.com/rajkumar-natarajan/BreathEasy.git
   ```

4. **Open in Xcode**
   ```bash
   open BreathEasy.xcodeproj
   ```

5. **Run Tests**
   ```bash
   # Verify everything works
   xcodebuild test -scheme BreathEasy -destination 'platform=iOS Simulator,name=iPhone 16'
   ```

## How Can I Contribute?

### Reporting Bugs 🐛

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

#### Bug Report Template
```markdown
**Describe the Bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Tap on '...'
3. Select '...'
4. See error

**Expected Behavior**
A clear description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Device Information:**
- Device: [e.g. iPhone 16 Pro]
- iOS Version: [e.g. iOS 18.5]
- App Version: [e.g. 1.0.0]

**Additional Context**
Add any other context about the problem here.
```

### Suggesting Features 💡

Feature requests are welcome! To suggest a feature:

#### Feature Request Template
```markdown
**Is your feature request related to a problem?**
A clear description of what the problem is. Ex. I'm always frustrated when [...]

**Describe the solution you'd like**
A clear description of what you want to happen.

**Describe alternatives you've considered**
Other solutions or features you've considered.

**Additional context**
Add any other context, mockups, or screenshots about the feature request.

**Impact on Privacy**
How does this feature align with our privacy-first approach?
```

### Contributing Code 👨‍💻

Areas where we especially welcome contributions:

#### High Priority
- **Accessibility improvements** - VoiceOver, Dynamic Type, motor accessibility
- **Localization** - Additional language support beyond English/Spanish
- **Bug fixes** - Any reported issues or edge cases
- **Performance optimizations** - Battery life, memory usage, animation smoothness

#### Medium Priority
- **New breathing patterns** - Research-backed techniques
- **Visual enhancements** - Improved animations, themes, or visual feedback
- **Audio improvements** - Better sound design, voice guidance enhancements
- **Analytics features** - Better progress tracking and insights

#### Lower Priority
- **Platform expansion** - watchOS, macOS support (future consideration)
- **Advanced features** - Biometric integration, group sessions (future consideration)

### Improving Documentation 📚

Documentation improvements are always appreciated:
- **API Documentation** - Code comments and technical docs
- **User Guides** - Tutorials, best practices, troubleshooting
- **Developer Guides** - Setup, architecture, contributing process
- **Translations** - Localized documentation

## Development Process

### Branch Strategy

```
main                    (Production releases)
├── develop             (Integration branch)
│   ├── feature/xyz     (Feature branches)
│   ├── bugfix/abc      (Bug fix branches)
│   └── hotfix/def      (Critical fixes)
```

### Creating a Feature Branch

```bash
# Start from develop branch
git checkout develop
git pull upstream develop

# Create your feature branch
git checkout -b feature/descriptive-name

# Example branch names:
# feature/custom-breathing-patterns
# feature/improved-accessibility
# bugfix/session-timer-accuracy
# docs/api-documentation-update
```

### Making Changes

1. **Write Code**
   - Follow our [style guidelines](#style-guidelines)
   - Add appropriate comments and documentation
   - Consider accessibility in all UI changes

2. **Add Tests**
   - Unit tests for business logic
   - UI tests for user interactions
   - Accessibility tests for new features

3. **Update Documentation**
   - Code comments for public APIs
   - User-facing documentation for new features
   - Update README if needed

### Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/):

#### Commit Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only changes
- `style`: Changes that don't affect meaning (white-space, formatting)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvement
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to build process or auxiliary tools

#### Examples
```bash
feat: add custom breathing pattern creation
fix: resolve session timer accuracy on background transition
docs: update API documentation for DataManager
style: improve breathing orb animation smoothness
refactor: extract haptic feedback logic into HapticManager
perf: optimize session data loading performance
test: add unit tests for mood tracking functionality
chore: update Xcode project settings for iOS 18.5
```

## Style Guidelines

### Swift Code Style

#### Naming Conventions
```swift
// Types: PascalCase
struct BreathingSession { }
class SessionViewModel { }
enum BreathingPhase { }

// Variables/Functions: camelCase
var sessionDuration: TimeInterval
func startBreathingSession() { }

// Constants: camelCase with descriptive names
let defaultSessionDuration: TimeInterval = 300
let maximumCustomPatterns = 10

// Private properties: leading underscore only for stored properties that back public computed properties
private var _isSessionActive = false
var isSessionActive: Bool { _isSessionActive }
```

#### Code Organization
```swift
// MARK: - File header
//
//  FileName.swift
//  BreathEasy
//
//  Created by [Your Name] on [Date].
//

import Foundation
import SwiftUI

/// Clear, concise class description
/// 
/// Detailed explanation of the class purpose,
/// key responsibilities, and usage examples.
class ExampleClass {
    
    // MARK: - Properties
    
    // MARK: - Initialization
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
}

// MARK: - Extensions

extension ExampleClass {
    // Group related functionality
}

// MARK: - Conformances

extension ExampleClass: SomeProtocol {
    // Protocol implementation
}

// MARK: - Preview (for SwiftUI views)

#Preview {
    ExampleView()
}
```

#### Documentation
```swift
/// Manages breathing session state and provides real-time updates during active sessions.
///
/// This view model coordinates the breathing session lifecycle, including:
/// - Phase timing and transitions (inhale, hold, exhale, pause)
/// - Visual animation synchronization with breathing phases
/// - Audio cues and haptic feedback coordination
/// - Session completion and data persistence
///
/// ## Usage
/// ```swift
/// let viewModel = SessionViewModel()
/// viewModel.startSession(pattern: .fourSevenEight, duration: 300)
/// ```
@Observable
class SessionViewModel {
    
    /// The current breathing phase during an active session.
    ///
    /// This property automatically updates as the session progresses through
    /// each phase of the breathing pattern. UI components observe this value
    /// to synchronize animations and visual feedback.
    private(set) var currentPhase: BreathingPhase = .inhale
    
    /// Starts a new breathing session with the specified configuration.
    ///
    /// - Parameters:
    ///   - pattern: The breathing pattern to follow (4-7-8, Box, etc.)
    ///   - duration: Total session length in seconds (60-1800)
    ///   - moodBefore: Optional pre-session mood rating for tracking
    ///
    /// - Note: This method immediately begins the session timer and phase transitions.
    ///         Ensure the view is ready to respond to state changes before calling.
    ///
    /// - Warning: Only one session can be active at a time. Starting a new session
    ///           while one is active will terminate the current session.
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
// GOOD: Break complex views into smaller, focused components
struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                quickStartSection
                progressSection
                recentActivitySection
            }
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            greetingText
            streakCounter
        }
    }
}

// AVOID: Monolithic view bodies
struct HomeView: View {
    var body: some View {
        VStack {
            // 100+ lines of inline view code
        }
    }
}
```

#### State Management
```swift
// GOOD: Use @Observable for complex state
@Observable
class HomeViewModel {
    var selectedPattern: BreathingPattern = .fourSevenEight
    var sessionDuration: TimeInterval = 300
    var isLoading = false
    
    func updatePattern(_ pattern: BreathingPattern) {
        selectedPattern = pattern
        // Additional logic...
    }
}

// GOOD: Use @State for simple view-specific state
struct SettingsView: View {
    @State private var showingAlert = false
    @State private var selectedTab = 0
}

// AVOID: Complex business logic in @State
struct HomeView: View {
    @State private var allSessions: [BreathingSession] = []
    @State private var badges: Set<BreathingBadge> = []
    // This belongs in a ViewModel or Manager
}
```

#### Accessibility
```swift
// Always include accessibility support
Button("Start Session") {
    startBreathingSession()
}
.accessibilityLabel("Start breathing session")
.accessibilityHint("Begins a guided breathing exercise with the selected pattern")
.accessibilityAddTraits(.startsMediaSession)

Text(currentPhase.displayName)
    .accessibilityLabel("Current breathing phase")
    .accessibilityValue(currentPhase.accessibilityDescription)
    .accessibilityAddTraits(.updatesFrequently)
```

### Testing Requirements

All contributions must include appropriate tests:

#### Unit Tests Required For
- **New models** - Data structures, validation, encoding/decoding
- **Business logic** - Calculations, algorithms, state management
- **Manager classes** - Data persistence, external API interactions
- **View models** - State changes, user interactions, computed properties

#### UI Tests Required For
- **New user flows** - Complete feature workflows
- **Critical paths** - Session creation, settings changes, data export
- **Accessibility** - VoiceOver navigation, keyboard support

#### Example Test Structure
```swift
import XCTest
@testable import BreathEasy

final class BreathingPatternTests: XCTestCase {
    
    func testFourSevenEightTiming() {
        // Given
        let pattern = BreathingPattern.fourSevenEight
        
        // When
        let timing = pattern.defaultTiming
        
        // Then
        XCTAssertEqual(timing.inhale, 4.0)
        XCTAssertEqual(timing.hold, 7.0)
        XCTAssertEqual(timing.exhale, 8.0)
        XCTAssertEqual(timing.pause, 1.0)
    }
    
    func testCustomTimingValidation() {
        // Given
        let validTiming = BreathingTiming(inhale: 4, hold: 2, exhale: 6, pause: 1)
        let invalidTiming = BreathingTiming(inhale: 0, hold: -1, exhale: 61, pause: 2)
        
        // Then
        XCTAssertTrue(validTiming.isValid)
        XCTAssertFalse(invalidTiming.isValid)
    }
}
```

## Pull Request Process

### Before Submitting

1. **Ensure all tests pass**
   ```bash
   xcodebuild test -scheme BreathEasy -destination 'platform=iOS Simulator,name=iPhone 16'
   ```

2. **Verify accessibility**
   - Test with VoiceOver enabled
   - Check Dynamic Type scaling
   - Verify keyboard navigation

3. **Update documentation**
   - Add/update code comments
   - Update user documentation if needed
   - Add changelog entry for user-facing changes

4. **Check performance**
   - No memory leaks
   - Smooth animations (60fps)
   - Reasonable battery usage

### PR Template

When creating a pull request, use this template:

```markdown
## Description
Brief description of changes and motivation.

## Type of Change
- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] UI tests added/updated
- [ ] Manual testing completed
- [ ] Accessibility testing completed

## Accessibility
- [ ] VoiceOver labels added/updated
- [ ] Dynamic Type scaling verified
- [ ] Keyboard navigation tested
- [ ] High contrast mode verified

## Screenshots (if applicable)
Include screenshots for UI changes.

## Checklist
- [ ] My code follows the style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
```

### Review Process

1. **Automated Checks** - CI/CD pipeline runs tests and checks
2. **Code Review** - Maintainer reviews code quality and design
3. **Testing** - Reviewer tests functionality on device
4. **Accessibility Review** - Ensure accessibility standards are met
5. **Documentation Review** - Verify documentation is updated
6. **Approval** - Once all checks pass, PR is approved and merged

### Review Criteria

Your PR will be evaluated on:

#### Functionality
- [ ] Works as intended
- [ ] Handles edge cases appropriately
- [ ] No regressions in existing functionality
- [ ] Performance impact is acceptable

#### Code Quality
- [ ] Follows established patterns and conventions
- [ ] No unnecessary code duplication
- [ ] Proper error handling
- [ ] Clear, self-documenting code

#### Testing
- [ ] Comprehensive test coverage
- [ ] Tests are meaningful and well-structured
- [ ] No flaky or unreliable tests

#### Accessibility
- [ ] Full VoiceOver support
- [ ] Dynamic Type compatibility
- [ ] Appropriate accessibility traits and labels
- [ ] Keyboard navigation support

#### Documentation
- [ ] Code is well-commented
- [ ] Public APIs are documented
- [ ] User-facing changes are documented
- [ ] Breaking changes are clearly noted

## Community Guidelines

### Communication

- **Be respectful** - Treat everyone with kindness and respect
- **Be patient** - Remember that people come from different backgrounds and experience levels
- **Be constructive** - Provide helpful feedback and suggestions
- **Be collaborative** - Work together toward the common goal of improving BreathEasy

### Getting Help

- **GitHub Discussions** - For questions, ideas, and community interaction
- **GitHub Issues** - For bug reports and feature requests
- **Email** - [support@breatheasy-app.com](mailto:support@breatheasy-app.com) for private matters

### Recognition

We believe in recognizing contributions! Contributors will be:
- Listed in our CONTRIBUTORS.md file
- Mentioned in release notes for significant contributions
- Invited to provide input on project direction

### Maintainer Responsibilities

Maintainers are responsible for:
- Reviewing and merging pull requests
- Maintaining code quality standards
- Ensuring project direction aligns with goals
- Supporting contributors and answering questions
- Maintaining a welcoming community environment

---

Thank you for contributing to BreathEasy! Your efforts help make mindful breathing more accessible to everyone. 🙏

Together, we're building something meaningful that helps people find calm in their daily lives.

**Remember: Every contribution matters, no matter how small.** 🌱
