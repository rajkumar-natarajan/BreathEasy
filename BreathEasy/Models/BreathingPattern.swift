//
//  BreathingPattern.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Foundation

/// Defines different breathing patterns with their specific timing configurations
enum BreathingPattern: String, CaseIterable, Codable {
    case fourSevenEight = "4-7-8"
    case box = "Box"
    case diaphragmatic = "Diaphragmatic"
    case resonant = "Resonant"
    case custom = "Custom"
    
    /// Display name for the pattern
    var displayName: String {
        switch self {
        case .fourSevenEight:
            return "4-7-8 Breathing"
        case .box:
            return "Box Breathing"
        case .diaphragmatic:
            return "Diaphragmatic"
        case .resonant:
            return "Resonant Breathing"
        case .custom:
            return "Custom Pattern"
        }
    }
    
    /// Short description of the pattern
    var description: String {
        switch self {
        case .fourSevenEight:
            return "Inhale 4s, Hold 7s, Exhale 8s - Perfect for sleep and anxiety relief"
        case .box:
            return "Equal 4s phases - Great for focus and concentration"
        case .diaphragmatic:
            return "Slow belly breaths - Deep relaxation and stress relief"
        case .resonant:
            return "5s in, 5s out - Heart rate variability optimization"
        case .custom:
            return "Your personalized breathing rhythm"
        }
    }
    
    /// Default timing configuration for each pattern
    var defaultTiming: BreathingTiming {
        switch self {
        case .fourSevenEight:
            return BreathingTiming(inhale: 4.0, hold: 7.0, exhale: 8.0, pause: 1.0)
        case .box:
            return BreathingTiming(inhale: 4.0, hold: 4.0, exhale: 4.0, pause: 4.0)
        case .diaphragmatic:
            return BreathingTiming(inhale: 6.0, hold: 2.0, exhale: 8.0, pause: 2.0)
        case .resonant:
            return BreathingTiming(inhale: 5.0, hold: 0.0, exhale: 5.0, pause: 0.0)
        case .custom:
            return BreathingTiming(inhale: 4.0, hold: 4.0, exhale: 4.0, pause: 1.0)
        }
    }
    
    /// Color theme associated with each pattern
    var colorScheme: BreathingColorScheme {
        switch self {
        case .fourSevenEight:
            return .purple
        case .box:
            return .blue
        case .diaphragmatic:
            return .green
        case .resonant:
            return .ocean
        case .custom:
            return .sunset
        }
    }
}

/// Timing configuration for breathing phases
struct BreathingTiming: Codable, Equatable {
    var inhale: Double     // Inhale duration in seconds
    var hold: Double       // Hold duration in seconds
    var exhale: Double     // Exhale duration in seconds
    var pause: Double      // Pause duration in seconds
    
    /// Total cycle duration
    var totalDuration: Double {
        return inhale + hold + exhale + pause
    }
    
    /// Validates timing values are within acceptable ranges
    var isValid: Bool {
        return inhale >= 1.0 && inhale <= 60.0 &&
               hold >= 0.0 && hold <= 60.0 &&
               exhale >= 1.0 && exhale <= 60.0 &&
               pause >= 0.0 && pause <= 60.0
    }
}

/// Color schemes for different breathing patterns
enum BreathingColorScheme: String, CaseIterable, Codable {
    case blue, green, purple, ocean, sunset
    
    var displayName: String {
        switch self {
        case .blue:
            return "Ocean Blue"
        case .green:
            return "Forest Green"
        case .purple:
            return "Twilight Purple"
        case .ocean:
            return "Deep Ocean"
        case .sunset:
            return "Warm Sunset"
        }
    }
}

/// Breathing phase states during a session
enum BreathingPhase: String, CaseIterable {
    case inhale = "Inhale"
    case hold = "Hold"
    case exhale = "Exhale"
    case pause = "Pause"
    case ready = "Ready"
    case completed = "Completed"
    
    var instruction: String {
        switch self {
        case .inhale:
            return "Breathe In"
        case .hold:
            return "Hold"
        case .exhale:
            return "Breathe Out"
        case .pause:
            return "Rest"
        case .ready:
            return "Get Ready"
        case .completed:
            return "Well Done!"
        }
    }
}
