//
//  DataManager.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Foundation
import Combine

/// Manages local data storage using UserDefaults for offline-first approach
@Observable
class DataManager {
    static let shared = DataManager()
    
    // MARK: - Storage Keys
    private enum StorageKeys {
        static let sessions = "breathing_sessions"
        static let settings = "app_settings"
        static let badges = "earned_badges"
        static let customPatterns = "custom_patterns"
        static let streaks = "streak_data"
    }
    
    // MARK: - Published Properties
    private(set) var sessions: [BreathingSession] = []
    private(set) var settings: AppSettings = AppSettings()
    private(set) var earnedBadges: Set<BreathingBadge> = []
    private(set) var customPatterns: [CustomBreathingPattern] = []
    private(set) var currentStreak: Int = 0
    private(set) var longestStreak: Int = 0
    
    private init() {
        loadAllData()
    }
    
    // MARK: - Session Management
    
    /// Saves a new breathing session
    func saveSession(_ session: BreathingSession) {
        sessions.append(session)
        sessions.sort { $0.date > $1.date } // Most recent first
        saveSessionsToStorage()
        updateStreaks()
        checkForNewBadges()
    }
    
    /// Gets sessions for a specific date range
    func getSessions(from startDate: Date, to endDate: Date) -> [BreathingSession] {
        return sessions.filter { session in
            session.date >= startDate && session.date <= endDate
        }
    }
    
    /// Gets sessions for today
    var todaySessions: [BreathingSession] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        return getSessions(from: today, to: tomorrow)
    }
    
    /// Gets recent sessions (last 10)
    var recentSessions: [BreathingSession] {
        return Array(sessions.prefix(10))
    }
    
    /// Gets sessions for this week
    var weekSessions: [BreathingSession] {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        return getSessions(from: startOfWeek, to: Date())
    }
    
    /// All sessions (for compatibility)
    var allSessions: [BreathingSession] {
        return sessions
    }
    
    /// Today's total minutes
    var todayMinutes: Int {
        return Int(todaySessions.reduce(0) { $0 + $1.duration } / 60)
    }
    
    /// Total minutes across all sessions
    var totalMinutes: Int {
        return Int(sessions.reduce(0) { $0 + $1.duration } / 60)
    }
    
    /// Available breathing patterns
    var breathingPatterns: [BreathingPatternStruct] {
        return BreathingPattern.allCases.compactMap { pattern in
            guard pattern != .custom else { return nil } // Exclude custom for now
            return BreathingPatternStruct(from: pattern)
        }
    }
    
    /// Total sessions count
    var totalSessionsCount: Int {
        return sessions.count
    }
    
    /// Total time spent in sessions
    var totalTimeSpent: TimeInterval {
        return sessions.reduce(0) { $0 + $1.duration }
    }
    
    // MARK: - Settings Management
    
    /// Updates app settings
    func updateSettings(_ newSettings: AppSettings) {
        settings = newSettings
        saveSettingsToStorage()
    }
    
    // MARK: - Custom Patterns Management
    
    /// Saves a custom breathing pattern
    func saveCustomPattern(_ pattern: CustomBreathingPattern) {
        customPatterns.append(pattern)
        saveCustomPatternsToStorage()
        
        // Check for custom explorer badge
        if customPatterns.count >= 5 {
            earnBadge(.customExplorer)
        }
    }
    
    /// Convenience method to add custom pattern from BreathingPatternStruct
    func addCustomPattern(_ patternStruct: BreathingPatternStruct) {
        let timing = BreathingTiming(
            inhale: Double(patternStruct.inhaleSeconds),
            hold: Double(patternStruct.holdSeconds),
            exhale: Double(patternStruct.exhaleSeconds),
            pause: Double(patternStruct.pauseSeconds)
        )
        
        let customPattern = CustomBreathingPattern(
            name: patternStruct.name,
            timing: timing,
            colorScheme: .purple, // Default color scheme
            dateCreated: Date()
        )
        
        saveCustomPattern(customPattern)
    }
    
    /// Deletes a custom pattern
    func deleteCustomPattern(_ pattern: CustomBreathingPattern) {
        customPatterns.removeAll { $0.id == pattern.id }
        saveCustomPatternsToStorage()
    }
    
    /// Clear all user data (sessions, custom patterns, badges, etc.)
    func clearAllData() {
        sessions.removeAll()
        customPatterns.removeAll()
        earnedBadges.removeAll()
        currentStreak = 0
        longestStreak = 0
        
        // Save empty data to storage
        saveSessionsToStorage()
        saveCustomPatternsToStorage()
        saveBadgesToStorage()
        saveStreaksToStorage()
    }
    
    // MARK: - Badges and Achievements
    
    /// Earns a new badge
    private func earnBadge(_ badge: BreathingBadge) {
        if !earnedBadges.contains(badge) {
            earnedBadges.insert(badge)
            saveBadgesToStorage()
        }
    }
    
    /// Checks for newly earned badges after a session
    private func checkForNewBadges() {
        // First session badge
        if sessions.count == 1 {
            earnBadge(.firstSession)
        }
        
        // Session count badges
        if sessions.count >= 100 {
            earnBadge(.hundredSessions)
        }
        if sessions.count >= 500 {
            earnBadge(.fiveHundredSessions)
        }
        
        // Streak badges
        if currentStreak >= 3 {
            earnBadge(.threeDayStreak)
        }
        if currentStreak >= 7 {
            earnBadge(.sevenDayStreak)
        }
        if currentStreak >= 30 {
            earnBadge(.thirtyDayStreak)
        }
        if currentStreak >= 14 && isConsecutiveStreak() {
            earnBadge(.consistentPractice)
        }
        
        // Mood improvement badge
        let recentMoodImprovements = sessions.prefix(10).filter { session in
            guard let effectiveness = session.moodAfter?.rawValue,
                  let before = session.moodBefore?.rawValue else { return false }
            return effectiveness > before
        }
        if recentMoodImprovements.count >= 10 {
            earnBadge(.moodImprover)
        }
        
        // Zen master badge (used all patterns)
        let usedPatterns = Set(sessions.map { $0.pattern })
        if usedPatterns.count >= BreathingPattern.allCases.count - 1 { // Exclude custom
            earnBadge(.zenMaster)
        }
    }
    
    // MARK: - Streak Management
    
    /// Updates current and longest streaks
    private func updateStreaks() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Get unique days with sessions
        let sessionDates = Set(sessions.map { calendar.startOfDay(for: $0.date) })
        
        // Calculate current streak
        var streak = 0
        var currentDate = today
        
        while sessionDates.contains(currentDate) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        currentStreak = streak
        
        // Update longest streak
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
        
        saveStreaksToStorage()
    }
    
    /// Checks if the streak is consecutive (no gaps)
    private func isConsecutiveStreak() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let sessionDates = Set(sessions.map { calendar.startOfDay(for: $0.date) })
        
        for i in 0..<currentStreak {
            let checkDate = calendar.date(byAdding: .day, value: -i, to: today)!
            if !sessionDates.contains(checkDate) {
                return false
            }
        }
        return true
    }
    
    // MARK: - Analytics
    
    /// Gets weekly session statistics
    func getWeeklyStats() -> WeeklyStats {
        let calendar = Calendar.current
        let now = Date()
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        let weekSessions = getSessions(from: weekStart, to: now)
        
        let totalTime = weekSessions.reduce(0) { $0 + $1.duration }
        let averageMoodImprovement = weekSessions.compactMap { session in
            guard let before = session.moodBefore?.rawValue,
                  let after = session.moodAfter?.rawValue else { return nil }
            return Double(after - before)
        }.reduce(0, +) / Double(max(1, weekSessions.count))
        
        let patternCounts = Dictionary(grouping: weekSessions, by: { $0.pattern })
            .mapValues { $0.count }
        let favoritePattern = patternCounts.max(by: { $0.value < $1.value })?.key
        
        return WeeklyStats(
            sessionsCount: weekSessions.count,
            totalTime: totalTime,
            averageMoodImprovement: averageMoodImprovement,
            favoritePattern: favoritePattern
        )
    }
    
    // MARK: - Data Persistence
    
    private func loadAllData() {
        loadSessions()
        loadSettings()
        loadBadges()
        loadCustomPatterns()
        loadStreaks()
    }
    
    private func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: StorageKeys.sessions),
           let decodedSessions = try? JSONDecoder().decode([BreathingSession].self, from: data) {
            sessions = decodedSessions.sorted { $0.date > $1.date }
        }
    }
    
    private func saveSessionsToStorage() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: StorageKeys.sessions)
        }
    }
    
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: StorageKeys.settings),
           let decodedSettings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = decodedSettings
        }
    }
    
    private func saveSettingsToStorage() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: StorageKeys.settings)
        }
    }
    
    private func loadBadges() {
        if let data = UserDefaults.standard.data(forKey: StorageKeys.badges),
           let decodedBadges = try? JSONDecoder().decode(Set<BreathingBadge>.self, from: data) {
            earnedBadges = decodedBadges
        }
    }
    
    private func saveBadgesToStorage() {
        if let encoded = try? JSONEncoder().encode(earnedBadges) {
            UserDefaults.standard.set(encoded, forKey: StorageKeys.badges)
        }
    }
    
    private func loadCustomPatterns() {
        if let data = UserDefaults.standard.data(forKey: StorageKeys.customPatterns),
           let decodedPatterns = try? JSONDecoder().decode([CustomBreathingPattern].self, from: data) {
            customPatterns = decodedPatterns
        }
    }
    
    private func saveCustomPatternsToStorage() {
        if let encoded = try? JSONEncoder().encode(customPatterns) {
            UserDefaults.standard.set(encoded, forKey: StorageKeys.customPatterns)
        }
    }
    
    private func loadStreaks() {
        currentStreak = UserDefaults.standard.integer(forKey: "current_streak")
        longestStreak = UserDefaults.standard.integer(forKey: "longest_streak")
    }
    
    private func saveStreaksToStorage() {
        UserDefaults.standard.set(currentStreak, forKey: "current_streak")
        UserDefaults.standard.set(longestStreak, forKey: "longest_streak")
    }
}

// MARK: - Supporting Models

/// Custom breathing pattern created by user
struct CustomBreathingPattern: Codable, Identifiable {
    let id: UUID
    let name: String
    let timing: BreathingTiming
    let colorScheme: BreathingColorScheme
    let dateCreated: Date
    
    init(name: String, timing: BreathingTiming, colorScheme: BreathingColorScheme, dateCreated: Date) {
        self.id = UUID()
        self.name = name
        self.timing = timing
        self.colorScheme = colorScheme
        self.dateCreated = dateCreated
    }
}

/// Weekly statistics summary
struct WeeklyStats {
    let sessionsCount: Int
    let totalTime: TimeInterval
    let averageMoodImprovement: Double
    let favoritePattern: BreathingPattern?
}
