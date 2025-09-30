//
//  ModelCompatibility.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Foundation

// MARK: - BreathingPattern Compatibility Extensions

extension BreathingPattern {
    /// Name for compatibility with enhanced views
    var name: String {
        return displayName
    }
    
    /// Inhale count in seconds
    var inhaleCount: Int {
        return Int(defaultTiming.inhale)
    }
    
    /// Hold count in seconds
    var holdCount: Int {
        return Int(defaultTiming.hold)
    }
    
    /// Exhale count in seconds
    var exhaleCount: Int {
        return Int(defaultTiming.exhale)
    }
    
    /// Pause count in seconds
    var pauseCount: Int {
        return Int(defaultTiming.pause)
    }
}

// MARK: - BreathingSession Compatibility Extensions

extension BreathingSession {
    /// Pattern name for enhanced views
    var patternName: String {
        return pattern.displayName
    }
    
    /// Start time for enhanced views (using date)
    var startTime: Date {
        return date
    }
    
    /// Completed cycles for enhanced views
    var completedCycles: Int {
        return cyclesCompleted
    }
}

// MARK: - BreathingPhase Compatibility Extensions

extension BreathingPhase {
    /// Map existing enum cases to enhanced view expectations
    static let prepare: BreathingPhase = .ready
    static let complete: BreathingPhase = .completed
}

// MARK: - Temporary BreathingPattern Struct for Enhanced Views

/// Temporary struct to bridge compatibility gap
/// This allows enhanced views to work while maintaining existing model structure
struct BreathingPatternStruct: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let inhaleSeconds: Int
    let holdSeconds: Int
    let exhaleSeconds: Int
    let pauseSeconds: Int
    let isCustom: Bool
    
    init(name: String, description: String = "", inhaleSeconds: Int, holdSeconds: Int, exhaleSeconds: Int, pauseSeconds: Int, isCustom: Bool = false) {
        self.name = name
        self.description = description
        self.inhaleSeconds = inhaleSeconds
        self.holdSeconds = holdSeconds
        self.exhaleSeconds = exhaleSeconds
        self.pauseSeconds = pauseSeconds
        self.isCustom = isCustom
    }
    
    // Legacy property support
    var inhaleCount: Int { inhaleSeconds }
    var holdCount: Int { holdSeconds }
    var exhaleCount: Int { exhaleSeconds }
    var pauseCount: Int { pauseSeconds }
    
    /// Convert from existing BreathingPattern enum
    init(from pattern: BreathingPattern) {
        self.name = pattern.displayName
        self.description = pattern.description
        self.inhaleSeconds = Int(pattern.defaultTiming.inhale)
        self.holdSeconds = Int(pattern.defaultTiming.hold)
        self.exhaleSeconds = Int(pattern.defaultTiming.exhale)
        self.pauseSeconds = Int(pattern.defaultTiming.pause)
        self.isCustom = pattern == .custom
    }
    
    /// Convert to existing BreathingPattern enum
    func toBreathingPattern() -> BreathingPattern? {
        switch name {
        case "4-7-8 Breathing":
            return .fourSevenEight
        case "Box Breathing":
            return .box
        case "Diaphragmatic":
            return .diaphragmatic
        case "Resonant Breathing":
            return .resonant
        default:
            return .custom
        }
    }
}
