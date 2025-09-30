# BreathEasy API Documentation

## Overview

BreathEasy is built with a clean, modular architecture using SwiftUI and the Observation framework. This document provides comprehensive API documentation for developers who want to understand, modify, or extend the app.

## Architecture Overview

### Design Patterns
- **MVVM (Model-View-ViewModel)**: Clear separation of concerns
- **Observable Pattern**: Reactive state management using `@Observable`
- **Singleton Pattern**: Shared managers for data, haptics, and speech
- **Factory Pattern**: Breathing pattern creation and configuration

### Core Components

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Views       │    │   ViewModels    │    │     Models      │
│  (SwiftUI)      │────│   (@Observable) │────│  (Data Types)   │
│                 │    │                 │    │                 │
│ - HomeView      │    │ - HomeViewModel │    │ - BreathingSession
│ - SessionView   │    │ - SessionVM     │    │ - BreathingPattern
│ - HistoryView   │    │                 │    │ - AppSettings   │
│ - SettingsView  │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │    Utilities    │
                    │   (Managers)    │
                    │                 │
                    │ - DataManager   │
                    │ - HapticManager │
                    │ - SpeechManager │
                    └─────────────────┘
```

## Models

### BreathingSession

Represents a completed breathing session with mood tracking and metadata.

```swift
struct BreathingSession: Codable, Identifiable {
    let id: UUID
    let date: Date
    let pattern: BreathingPattern
    let duration: TimeInterval
    let cycles: Int
    let moodBefore: MoodLevel?
    let moodAfter: MoodLevel?
    let customTiming: BreathingTiming?
    
    init(pattern: BreathingPattern, 
         duration: TimeInterval, 
         cycles: Int, 
         moodBefore: MoodLevel? = nil, 
         moodAfter: MoodLevel? = nil, 
         customTiming: BreathingTiming? = nil)
}
```

**Properties:**
- `id`: Unique identifier for the session
- `date`: When the session was completed
- `pattern`: Which breathing pattern was used
- `duration`: Total session duration in seconds
- `cycles`: Number of complete breathing cycles
- `moodBefore`/`moodAfter`: Mood levels for tracking improvement
- `customTiming`: Custom timing if pattern was modified

### BreathingPattern

Defines the available breathing techniques with their configurations.

```swift
enum BreathingPattern: String, CaseIterable, Codable {
    case fourSevenEight = "4-7-8"
    case box = "Box"
    case diaphragmatic = "Diaphragmatic"
    case resonant = "Resonant"
    case custom = "Custom"
    
    var displayName: String { /* ... */ }
    var description: String { /* ... */ }
    var defaultTiming: BreathingTiming { /* ... */ }
    var colorScheme: BreathingColorScheme { /* ... */ }
}
```

**Methods:**
- `displayName`: User-friendly name for the pattern
- `description`: Detailed description of the technique
- `defaultTiming`: Default timing configuration
- `colorScheme`: Associated visual theme

### BreathingTiming

Configures the duration of each breathing phase.

```swift
struct BreathingTiming: Codable, Equatable {
    var inhale: Double     // Inhale duration in seconds
    var hold: Double       // Hold duration in seconds  
    var exhale: Double     // Exhale duration in seconds
    var pause: Double      // Pause duration in seconds
    
    var totalDuration: Double { /* inhale + hold + exhale + pause */ }
    var isValid: Bool { /* validation logic */ }
}
```

**Validation Rules:**
- Inhale: 1.0 - 60.0 seconds
- Hold: 0.0 - 60.0 seconds
- Exhale: 1.0 - 60.0 seconds
- Pause: 0.0 - 60.0 seconds

### MoodLevel

Tracks emotional state before and after sessions.

```swift
enum MoodLevel: Int, CaseIterable, Codable {
    case veryStressed = 1
    case stressed = 2
    case neutral = 3
    case calm = 4
    case veryCalm = 5
    
    var emoji: String { /* ... */ }
    var description: String { /* ... */ }
}
```

### BreathingBadge

Achievement system for motivation and progress tracking.

```swift
enum BreathingBadge: String, CaseIterable, Codable {
    case firstSession = "first_session"
    case threeDayStreak = "three_day_streak"
    case sevenDayStreak = "seven_day_streak"
    case thirtyDayStreak = "thirty_day_streak"
    case hundredSessions = "hundred_sessions"
    case fiveHundredSessions = "five_hundred_sessions"
    case zenMaster = "zen_master"
    case customExplorer = "custom_explorer"
    case moodImprover = "mood_improver"
    case consistentPractice = "consistent_practice"
    
    var title: String { /* ... */ }
    var description: String { /* ... */ }
    var emoji: String { /* ... */ }
}
```

### AppSettings

User preferences and configuration options.

```swift
struct AppSettings: Codable, Equatable {
    var hapticIntensity: HapticIntensity = .medium
    var colorScheme: BreathingColorScheme = .blue
    var enableSoundCues: Bool = true
    var enableHaptics: Bool = true
    var enableHealthKitExport: Bool = false
    var enableNotifications: Bool = true
    var reminderTime: Date = defaultReminderTime
    var sessionDuration: TimeInterval = 300 // 5 minutes
    var enableReducedMotion: Bool = false
    var enableHighContrast: Bool = false
    var preferredLanguage: AppLanguage = .english
    
    enum HapticIntensity: String, CaseIterable, Codable {
        case off, light, medium, strong
    }
    
    enum AppLanguage: String, CaseIterable, Codable {
        case english = "en"
        case spanish = "es"
    }
}
```

## ViewModels

### HomeViewModel

Manages the home screen state and session initiation.

```swift
@Observable
class HomeViewModel {
    // MARK: - State Properties
    var selectedPattern: BreathingPattern = .fourSevenEight
    var sessionDuration: TimeInterval = 300
    var currentMood: MoodLevel?
    var showingMoodSelector = false
    var showingDurationPicker = false
    var showingCustomPatternCreator = false
    
    // MARK: - Computed Properties
    var currentStreak: Int { /* ... */ }
    var todaySessionCount: Int { /* ... */ }
    var weeklyStats: WeeklyStats { /* ... */ }
    
    // MARK: - Methods
    func startSession()
    func updatePattern(_ pattern: BreathingPattern)
    func updateDuration(_ duration: TimeInterval)
    func logPreSessionMood(_ mood: MoodLevel)
}
```

**Key Methods:**
- `startSession()`: Initiates a new breathing session
- `updatePattern(_:)`: Changes the selected breathing pattern
- `updateDuration(_:)`: Sets session duration
- `logPreSessionMood(_:)`: Records mood before session

### SessionViewModel

Manages active breathing session state and timing.

```swift
@Observable
class SessionViewModel {
    // MARK: - State Properties
    private(set) var isActive = false
    private(set) var isPaused = false
    private(set) var currentPhase: BreathingPhase = .inhale
    private(set) var sessionTimeRemaining: TimeInterval = 0
    private(set) var phaseTimeRemaining: TimeInterval = 0
    private(set) var cycleCount = 0
    
    // MARK: - Animation Properties
    private(set) var orbScale: Double = 1.0
    private(set) var orbOpacity: Double = 0.8
    private(set) var breathingRate: Double = 1.0
    
    // MARK: - Methods
    func startSession(pattern: BreathingPattern, duration: TimeInterval, moodBefore: MoodLevel?)
    func pauseSession()
    func resumeSession()
    func endSession(moodAfter: MoodLevel?)
    func skipPhase()
}
```

**Session Lifecycle:**
1. `startSession(...)` - Initialize and begin
2. `pauseSession()` - Temporarily pause
3. `resumeSession()` - Continue from pause
4. `endSession(...)` - Complete and save

## Managers

### DataManager

Singleton responsible for all data persistence and retrieval.

```swift
@Observable
class DataManager {
    static let shared = DataManager()
    
    // MARK: - Properties
    private(set) var sessions: [BreathingSession] = []
    private(set) var settings: AppSettings = AppSettings()
    private(set) var earnedBadges: Set<BreathingBadge> = []
    private(set) var customPatterns: [CustomBreathingPattern] = []
    private(set) var currentStreak: Int = 0
    private(set) var longestStreak: Int = 0
    
    // MARK: - Methods
    func saveSession(_ session: BreathingSession)
    func updateSettings(_ newSettings: AppSettings)
    func saveCustomPattern(_ pattern: CustomBreathingPattern)
    func deleteCustomPattern(_ pattern: CustomBreathingPattern)
    func clearAllData()
    func getWeeklyStats() -> WeeklyStats
    func getTodaySessions() -> [BreathingSession]
    func getSessionsInRange(_ range: DateInterval) -> [BreathingSession]
}
```

**Data Storage:**
- Uses UserDefaults for local persistence
- JSON encoding/decoding for complex types
- Automatic badge calculation and awarding
- Streak tracking with daily validation

**Key Methods:**
- `saveSession(_:)`: Persist a completed session
- `updateSettings(_:)`: Save user preferences
- `getWeeklyStats()`: Calculate weekly progress
- `clearAllData()`: Reset all user data

### HapticManager

Handles haptic feedback synchronized with breathing phases.

```swift
class HapticManager {
    static let shared = HapticManager()
    
    // MARK: - Methods
    func prepareHaptics()
    func playPhaseTransition(for phase: BreathingPhase, intensity: HapticIntensity)
    func playSessionStart()
    func playSessionComplete()
    func playBadgeUnlocked()
    func playButtonTap()
}
```

**Haptic Types:**
- **Phase Transitions**: Different patterns for inhale/exhale/hold
- **Session Events**: Start and completion feedback
- **Achievements**: Badge unlock celebrations
- **UI Feedback**: Button taps and interactions

### SpeechManager

Provides voice guidance and audio cues.

```swift
@MainActor
class SpeechManager: NSObject, @unchecked Sendable {
    static let shared = SpeechManager()
    
    // MARK: - Methods
    func announcePhase(_ phase: BreathingPhase, duration: TimeInterval, language: AppLanguage)
    func announceSessionStart(pattern: BreathingPattern, duration: TimeInterval)
    func announceSessionComplete(cycles: Int, improvement: String?)
    func announceBadgeEarned(_ badge: BreathingBadge)
    func setVoiceSettings(rate: Float, pitch: Float, volume: Float)
    func stopSpeaking()
}
```

**Multilingual Support:**
- English and Spanish voice guidance
- Localized breathing instructions
- Customizable voice parameters
- Phase-specific audio cues

## Views

### HomeView

Main dashboard for starting sessions and viewing progress.

```swift
struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with greeting and streak
                    headerSection
                    
                    // Quick start breathing session
                    quickStartSection
                    
                    // Today's progress
                    todayStatsSection
                    
                    // Weekly overview
                    weeklyStatsSection
                    
                    // Recent achievements
                    recentBadgesSection
                }
            }
        }
    }
}
```

**Key Components:**
- Pattern selector with previews
- Duration picker (1-30 minutes)
- Mood logging integration
- Progress visualization
- Achievement highlights

### SessionView

Active breathing session with visual guidance.

```swift
struct SessionView: View {
    @State private var viewModel = SessionViewModel()
    let pattern: BreathingPattern
    let duration: TimeInterval
    let moodBefore: MoodLevel?
    
    var body: some View {
        ZStack {
            // Background gradient
            backgroundGradient
            
            VStack {
                // Session progress
                sessionProgressSection
                
                // Breathing orb animation
                breathingOrbSection
                
                // Phase instruction
                phaseInstructionSection
                
                // Control buttons
                sessionControlsSection
            }
        }
    }
}
```

**Visual Elements:**
- Animated breathing orb that scales with phases
- Color-coded phase indicators
- Progress ring showing session completion
- Phase timing countdown
- Pause/resume/end controls

### HistoryView

Session history and analytics dashboard.

```swift
struct HistoryView: View {
    private let dataManager = DataManager.shared
    @State private var selectedTimeRange: TimeRange = .week
    @State private var showingSessionDetail: BreathingSession?
    
    var body: some View {
        NavigationStack {
            VStack {
                // Time range picker
                timeRangePicker
                
                // Statistics overview
                statsOverviewSection
                
                // Sessions list
                sessionsListSection
            }
        }
    }
}
```

**Analytics Features:**
- Session count and total time
- Mood improvement tracking
- Pattern usage statistics
- Streak visualization
- Detailed session logs

### SettingsView

Configuration and customization options.

```swift
struct SettingsView: View {
    private let dataManager = DataManager.shared
    @State private var settings = DataManager.shared.settings
    
    var body: some View {
        NavigationStack {
            List {
                audioHapticsSection
                visualAccessibilitySection
                notificationsSection
                healthIntegrationSection
                languageSection
                dataManagementSection
                aboutSection
            }
        }
    }
}
```

**Settings Categories:**
- Audio & Haptics: Sound cues, voice guidance, haptic intensity
- Visual & Accessibility: Color schemes, reduced motion, high contrast
- Notifications: Daily reminders, quiet hours
- Health Integration: HealthKit export, mindfulness data
- Language: English/Spanish interface
- Data Management: Export, privacy, clear data

## Utilities

### ColorSchemeManager

Manages app theming and color schemes.

```swift
struct ColorSchemeManager {
    static func primaryColor(for scheme: BreathingColorScheme) -> Color
    static func secondaryColor(for scheme: BreathingColorScheme) -> Color
    static func gradientColors(for scheme: BreathingColorScheme) -> [Color]
    static func backgroundGradient(for scheme: BreathingColorScheme) -> LinearGradient
}
```

### AnimationManager

Handles complex animations and transitions.

```swift
struct AnimationManager {
    static let breathingAnimation: Animation
    static let phaseTransition: Animation
    static let orbPulse: Animation
    static let progressRing: Animation
    
    static func breathingCurve(for phase: BreathingPhase) -> Animation
    static func scaleCurve(for timing: BreathingTiming) -> Animation
}
```

### NotificationManager

Manages local notifications and reminders.

```swift
class NotificationManager {
    static let shared = NotificationManager()
    
    func scheduleDaily(at time: Date, enabled: Bool)
    func scheduleMilestone(for badge: BreathingBadge)
    func cancelAllNotifications()
    func requestPermission() async -> Bool
}
```

## Data Flow

### Session Creation Flow
```
1. User selects pattern and duration in HomeView
2. HomeViewModel validates inputs and logs pre-mood
3. Navigation to SessionView with parameters
4. SessionViewModel initializes timing and starts session
5. Real-time updates trigger UI animations
6. Session completion saves to DataManager
7. Badge calculations and streak updates
8. Return to HomeView with updated stats
```

### Settings Update Flow
```
1. User modifies setting in SettingsView
2. Setting binding triggers onChange
3. DataManager.updateSettings() called
4. UserDefaults persistence
5. Dependent managers notified (Haptic, Speech, etc.)
6. UI reflects changes immediately
```

## Testing

### Unit Tests
```swift
// Example test structure
class DataManagerTests: XCTestCase {
    var dataManager: DataManager!
    
    override func setUp() {
        dataManager = DataManager()
    }
    
    func testSessionSaving() {
        // Test session persistence
    }
    
    func testBadgeCalculation() {
        // Test achievement logic
    }
    
    func testStreakTracking() {
        // Test streak calculations
    }
}
```

### UI Tests
```swift
class BreathEasyUITests: XCTestCase {
    func testSessionFlow() {
        // Test complete session workflow
    }
    
    func testSettingsModification() {
        // Test settings changes
    }
    
    func testAccessibility() {
        // Test VoiceOver and accessibility features
    }
}
```

## Performance Considerations

### Memory Management
- Use `@Observable` for efficient view updates
- Minimize timer usage during sessions
- Lazy loading of historical data
- Proper cleanup of audio/haptic resources

### Battery Optimization
- Pause background processing during sessions
- Efficient animation rendering
- Minimal UserDefaults access
- Smart notification scheduling

### Accessibility
- Full VoiceOver support
- Dynamic Type scaling
- High contrast mode
- Reduced motion options
- Keyboard navigation

## Extension Points

### Adding New Breathing Patterns
1. Add case to `BreathingPattern` enum
2. Define `defaultTiming` and `colorScheme`
3. Add localized strings for name/description
4. Update pattern selection UI

### Custom Badge Types
1. Add case to `BreathingBadge` enum
2. Implement earning criteria in DataManager
3. Add localized strings and emoji
4. Update achievement display logic

### New Languages
1. Add case to `AppLanguage` enum
2. Create localized string files
3. Update SpeechManager voice logic
4. Add language selection in settings

---

This API documentation provides a comprehensive overview of the BreathEasy architecture. For implementation examples and detailed usage, refer to the specific source files in the project.
