//
//  BreathingSession.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Foundation

/// Represents a completed breathing session
struct BreathingSession: Codable, Identifiable {
    let id: UUID
    let date: Date
    let pattern: BreathingPattern
    let customTiming: BreathingTiming?
    let duration: TimeInterval  // Total session duration in seconds
    let cyclesCompleted: Int
    let moodBefore: MoodLevel?
    let moodAfter: MoodLevel?
    let wasCompleted: Bool
    
    init(date: Date = Date(), pattern: BreathingPattern, customTiming: BreathingTiming? = nil, 
         duration: TimeInterval, cyclesCompleted: Int, moodBefore: MoodLevel? = nil, 
         moodAfter: MoodLevel? = nil, wasCompleted: Bool = true) {
        self.id = UUID()
        self.date = date
        self.pattern = pattern
        self.customTiming = customTiming
        self.duration = duration
        self.cyclesCompleted = cyclesCompleted
        self.moodBefore = moodBefore
        self.moodAfter = moodAfter
        self.wasCompleted = wasCompleted
    }
    
    /// Session effectiveness score based on mood improvement
    var effectivenessScore: Double {
        guard let before = moodBefore?.rawValue,
              let after = moodAfter?.rawValue else {
            return 0.0
        }
        return Double(after - before) / 4.0  // Normalized to -1.0 to 1.0
    }
    
    /// Display duration as formatted string
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
}

/// Mood levels for pre/post session tracking
enum MoodLevel: Int, CaseIterable, Codable {
    case veryStressed = 1
    case stressed = 2
    case neutral = 3
    case calm = 4
    case veryCalm = 5
    
    var emoji: String {
        switch self {
        case .veryStressed:
            return "😰"
        case .stressed:
            return "😟"
        case .neutral:
            return "😐"
        case .calm:
            return "😌"
        case .veryCalm:
            return "😇"
        }
    }
    
    var description: String {
        switch self {
        case .veryStressed:
            return "Very Stressed"
        case .stressed:
            return "Stressed"
        case .neutral:
            return "Neutral"
        case .calm:
            return "Calm"
        case .veryCalm:
            return "Very Calm"
        }
    }
}

/// User achievements and badges
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
    
    var title: String {
        switch self {
        case .firstSession:
            return "First Breath"
        case .threeDayStreak:
            return "Getting Started"
        case .sevenDayStreak:
            return "Week Warrior"
        case .thirtyDayStreak:
            return "Monthly Master"
        case .hundredSessions:
            return "Breathing Expert"
        case .fiveHundredSessions:
            return "Mindfulness Guru"
        case .zenMaster:
            return "Zen Master"
        case .customExplorer:
            return "Pattern Explorer"
        case .moodImprover:
            return "Mood Alchemist"
        case .consistentPractice:
            return "Steady Breath"
        }
    }
    
    var description: String {
        switch self {
        case .firstSession:
            return "Completed your first breathing session"
        case .threeDayStreak:
            return "3 days of consistent practice"
        case .sevenDayStreak:
            return "7 days of mindful breathing"
        case .thirtyDayStreak:
            return "30 days of dedication"
        case .hundredSessions:
            return "100 breathing sessions completed"
        case .fiveHundredSessions:
            return "500 sessions of inner peace"
        case .zenMaster:
            return "Mastered all breathing patterns"
        case .customExplorer:
            return "Created 5 custom patterns"
        case .moodImprover:
            return "Improved mood in 10 sessions"
        case .consistentPractice:
            return "14 consecutive days of practice"
        }
    }
    
    var emoji: String {
        switch self {
        case .firstSession:
            return "🌱"
        case .threeDayStreak:
            return "🔥"
        case .sevenDayStreak:
            return "⭐"
        case .thirtyDayStreak:
            return "🏆"
        case .hundredSessions:
            return "💎"
        case .fiveHundredSessions:
            return "👑"
        case .zenMaster:
            return "🧘‍♂️"
        case .customExplorer:
            return "🎨"
        case .moodImprover:
            return "🌈"
        case .consistentPractice:
            return "⚡"
        }
    }
}

/// App settings and preferences
struct AppSettings: Codable, Equatable {
    var hapticIntensity: HapticIntensity = .medium
    var colorScheme: BreathingColorScheme = .blue
    var enableSoundCues: Bool = true
    var enableHaptics: Bool = true
    var enableHealthKitExport: Bool = false
    var enableNotifications: Bool = true
    var reminderTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
    var sessionDuration: TimeInterval = 300 // 5 minutes default
    var enableReducedMotion: Bool = false
    var enableHighContrast: Bool = false
    var preferredLanguage: AppLanguage = .english
    
    /// Haptic intensity levels
    enum HapticIntensity: String, CaseIterable, Codable {
        case off = "off"
        case light = "light"
        case medium = "medium"
        case strong = "strong"
        
        var displayName: String {
            switch self {
            case .off:
                return "Off"
            case .light:
                return "Light"
            case .medium:
                return "Medium"
            case .strong:
                return "Strong"
            }
        }
    }
    
    /// Supported languages
    enum AppLanguage: String, CaseIterable, Codable {
        case english = "en"
        case spanish = "es"
        
        var displayName: String {
            switch self {
            case .english:
                return "English"
            case .spanish:
                return "Español"
            }
        }
    }
}
