//
//  HomeViewModel.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Foundation
import SwiftUI

/// ViewModel for home screen functionality
@Observable
class HomeViewModel {
    
    // MARK: - State Properties
    var selectedPattern: BreathingPattern = .fourSevenEight
    var sessionDuration: TimeInterval = 300 // 5 minutes default
    var currentMood: MoodLevel?
    var showingMoodSelector = false
    var showingDurationPicker = false
    var showingCustomPatternCreator = false
    
    // MARK: - Dependencies
    private let dataManager = DataManager.shared
    
    // MARK: - Computed Properties
    
    /// Current streak count
    var currentStreak: Int {
        return dataManager.currentStreak
    }
    
    /// Today's session count
    var todaySessionCount: Int {
        return dataManager.todaySessions.count
    }
    
    /// Weekly statistics
    var weeklyStats: WeeklyStats {
        return dataManager.getWeeklyStats()
    }
    
    /// Recent badges (last 3)
    var recentBadges: Array<BreathingBadge> {
        return Array(dataManager.earnedBadges.sorted { badge1, badge2 in
            // Sort by badge priority/importance
            badge1.rawValue < badge2.rawValue
        }.prefix(3))
    }
    
    /// Available patterns including custom ones
    var availablePatterns: [PatternDisplayItem] {
        var patterns: [PatternDisplayItem] = BreathingPattern.allCases.map { pattern in
            PatternDisplayItem(
                pattern: pattern,
                timing: pattern.defaultTiming,
                isCustom: false
            )
        }
        
        // Add custom patterns
        let customPatterns = dataManager.customPatterns.map { customPattern in
            PatternDisplayItem(
                pattern: .custom,
                timing: customPattern.timing,
                isCustom: true,
                customName: customPattern.name,
                customId: customPattern.id
            )
        }
        
        patterns.append(contentsOf: customPatterns)
        return patterns
    }
    
    /// Quick session durations
    let quickDurations: [TimeInterval] = [60, 180, 300, 600, 900] // 1m, 3m, 5m, 10m, 15m
    
    /// Session duration options with display names
    var durationOptions: [(duration: TimeInterval, display: String)] {
        return quickDurations.map { duration in
            let minutes = Int(duration) / 60
            let seconds = Int(duration) % 60
            
            let display: String
            if seconds == 0 {
                display = "\(minutes) min"
            } else {
                display = "\(minutes):\(String(format: "%02d", seconds))"
            }
            
            return (duration: duration, display: display)
        }
    }
    
    // MARK: - Pattern Selection
    
    /// Selects a breathing pattern
    func selectPattern(_ pattern: BreathingPattern) {
        selectedPattern = pattern
    }
    
    /// Selects a custom pattern
    func selectCustomPattern(_ customPattern: CustomBreathingPattern) {
        selectedPattern = .custom
        // Additional logic for custom pattern handling would go here
    }
    
    // MARK: - Duration Management
    
    /// Sets session duration
    func setSessionDuration(_ duration: TimeInterval) {
        sessionDuration = duration
    }
    
    /// Shows duration picker
    func showDurationPicker() {
        showingDurationPicker = true
    }
    
    /// Hides duration picker
    func hideDurationPicker() {
        showingDurationPicker = false
    }
    
    // MARK: - Mood Tracking
    
    /// Shows mood selector
    func showMoodSelector() {
        showingMoodSelector = true
    }
    
    /// Hides mood selector
    func hideMoodSelector() {
        showingMoodSelector = false
    }
    
    /// Sets current mood
    func setCurrentMood(_ mood: MoodLevel) {
        currentMood = mood
        showingMoodSelector = false
    }
    
    /// Clears current mood
    func clearCurrentMood() {
        currentMood = nil
    }
    
    // MARK: - Custom Pattern Creation
    
    /// Shows custom pattern creator
    func showCustomPatternCreator() {
        showingCustomPatternCreator = true
    }
    
    /// Hides custom pattern creator
    func hideCustomPatternCreator() {
        showingCustomPatternCreator = false
    }
    
    /// Creates and saves custom pattern
    func createCustomPattern(name: String, timing: BreathingTiming, colorScheme: BreathingColorScheme) {
        let customPattern = CustomBreathingPattern(
            name: name,
            timing: timing,
            colorScheme: colorScheme,
            dateCreated: Date()
        )
        
        dataManager.saveCustomPattern(customPattern)
        hideCustomPatternCreator()
    }
    
    // MARK: - Session Starting
    
    /// Prepares and validates session start
    func canStartSession() -> Bool {
        return sessionDuration > 0
    }
    
    /// Gets session configuration for starting
    func getSessionConfiguration() -> SessionConfiguration {
        let timing: BreathingTiming?
        
        if selectedPattern == .custom {
            // Would need to identify which custom pattern was selected
            timing = nil // This would be set based on selected custom pattern
        } else {
            timing = nil // Use default pattern timing
        }
        
        return SessionConfiguration(
            pattern: selectedPattern,
            customTiming: timing,
            duration: sessionDuration,
            moodBefore: currentMood
        )
    }
    
    // MARK: - Daily Motivation
    
    /// Gets motivational message based on user's progress
    func getDailyMotivation() -> String {
        let streak = currentStreak
        _ = todaySessionCount  // Silence the warning
        
        if streak == 0 {
            return "Ready to start your mindfulness journey? Take your first breath."
        } else if streak == 1 {
            return "Great start! One day at a time builds lasting habits."
        } else if streak < 7 {
            return "You're building momentum! \(streak) days strong. 🌱"
        } else if streak < 30 {
            return "Amazing consistency! \(streak) days of mindful breathing. ⭐"
        } else {
            return "Mindfulness master! \(streak) days of inner peace. 🧘‍♂️"
        }
    }
    
    /// Gets personalized recommendation based on usage patterns
    func getPersonalizedRecommendation() -> PatternRecommendation? {
        let recentSessions = dataManager.sessions.prefix(10)
        
        // Analyze mood improvements by pattern
        let patternEffectiveness: [BreathingPattern: Double] = Dictionary(grouping: recentSessions) { $0.pattern }
            .compactMapValues { sessions -> Double? in
                let improvements = sessions.compactMap { $0.effectivenessScore }
                guard !improvements.isEmpty else { return nil }
                return improvements.reduce(0, +) / Double(improvements.count)
            }
        
        // Find most effective pattern
        let bestPattern = patternEffectiveness.max { $0.value < $1.value }
        
        if let (pattern, effectiveness) = bestPattern, effectiveness > 0.2 {
            return PatternRecommendation(
                pattern: pattern,
                reason: "This pattern has improved your mood by \(Int(effectiveness * 100))% recently",
                confidence: min(1.0, effectiveness * 2)
            )
        }
        
        // Fallback recommendations based on time of day
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour < 10 {
            return PatternRecommendation(
                pattern: .resonant,
                reason: "Morning resonant breathing helps start your day centered",
                confidence: 0.7
            )
        } else if hour > 18 {
            return PatternRecommendation(
                pattern: .fourSevenEight,
                reason: "Evening 4-7-8 breathing promotes relaxation and better sleep",
                confidence: 0.8
            )
        } else {
            return PatternRecommendation(
                pattern: .box,
                reason: "Box breathing is excellent for midday focus and stress relief",
                confidence: 0.6
            )
        }
    }
}

// MARK: - Supporting Models

/// Configuration for starting a breathing session
struct SessionConfiguration {
    let pattern: BreathingPattern
    let customTiming: BreathingTiming?
    let duration: TimeInterval
    let moodBefore: MoodLevel?
}

/// Display item for pattern selection
struct PatternDisplayItem: Identifiable {
    let id = UUID()
    let pattern: BreathingPattern
    let timing: BreathingTiming
    let isCustom: Bool
    let customName: String?
    let customId: UUID?
    
    init(pattern: BreathingPattern, timing: BreathingTiming, isCustom: Bool, customName: String? = nil, customId: UUID? = nil) {
        self.pattern = pattern
        self.timing = timing
        self.isCustom = isCustom
        self.customName = customName
        self.customId = customId
    }
    
    var displayName: String {
        return customName ?? pattern.displayName
    }
    
    var description: String {
        if isCustom {
            return "Custom pattern: \(Int(timing.inhale))s-\(Int(timing.hold))s-\(Int(timing.exhale))s-\(Int(timing.pause))s"
        } else {
            return pattern.description
        }
    }
}

/// Pattern recommendation with reasoning
struct PatternRecommendation {
    let pattern: BreathingPattern
    let reason: String
    let confidence: Double // 0.0 to 1.0
}
