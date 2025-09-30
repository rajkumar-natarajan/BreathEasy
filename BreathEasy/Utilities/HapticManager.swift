//
//  HapticManager.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Foundation
import CoreHaptics
import UIKit

/// Manages haptic feedback synchronized with breathing patterns
@Observable
class HapticManager {
    static let shared = HapticManager()
    
    private var hapticEngine: CHHapticEngine?
    private var hapticPlayer: CHHapticPatternPlayer?
    private var isHapticsAvailable: Bool {
        return CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
    
    private init() {
        setupHapticEngine()
    }
    
    // MARK: - Setup
    
    private func setupHapticEngine() {
        guard isHapticsAvailable else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
            
            // Handle engine reset
            hapticEngine?.resetHandler = { [weak self] in
                do {
                    try self?.hapticEngine?.start()
                } catch {
                    print("Failed to restart haptic engine: \(error)")
                }
            }
            
            // Handle engine stop
            hapticEngine?.stoppedHandler = { reason in
                print("Haptic engine stopped: \(reason)")
            }
            
        } catch {
            print("Failed to setup haptic engine: \(error)")
        }
    }
    
    // MARK: - Breathing Phase Haptics
    
    /// Triggers haptic feedback for breathing phase transitions
    func triggerBreathingHaptic(for phase: BreathingPhase, intensity: AppSettings.HapticIntensity) {
        guard intensity != .off, isHapticsAvailable else {
            // Fallback to legacy haptics for older devices
            triggerLegacyHaptic(for: phase, intensity: intensity)
            return
        }
        
        let hapticIntensity = getHapticIntensityValue(intensity)
        
        switch phase {
        case .inhale:
            triggerInhaleHaptic(intensity: hapticIntensity)
        case .hold:
            triggerHoldHaptic(intensity: hapticIntensity)
        case .exhale:
            triggerExhaleHaptic(intensity: hapticIntensity)
        case .pause:
            triggerPauseHaptic(intensity: hapticIntensity)
        case .ready:
            triggerReadyHaptic(intensity: hapticIntensity)
        case .completed:
            triggerCompletionHaptic(intensity: hapticIntensity)
        }
    }
    
    /// Creates continuous haptic pattern for breathing phase duration
    func createBreathingPattern(phase: BreathingPhase, duration: TimeInterval, intensity: AppSettings.HapticIntensity) -> CHHapticPattern? {
        guard intensity != .off, isHapticsAvailable else { return nil }
        
        let hapticIntensity = getHapticIntensityValue(intensity)
        var events: [CHHapticEvent] = []
        
        switch phase {
        case .inhale:
            // Gradual intensity increase
            events = createGradualIntensityEvents(
                startTime: 0,
                duration: duration,
                startIntensity: 0.1,
                endIntensity: hapticIntensity,
                type: .hapticContinuous
            )
            
        case .hold:
            // Steady light pulse
            events = createPulseEvents(
                duration: duration,
                pulseFrequency: 0.5,
                intensity: hapticIntensity * 0.3
            )
            
        case .exhale:
            // Gradual intensity decrease
            events = createGradualIntensityEvents(
                startTime: 0,
                duration: duration,
                startIntensity: hapticIntensity,
                endIntensity: 0.1,
                type: .hapticContinuous
            )
            
        case .pause:
            // Very light occasional tap
            if duration > 2.0 {
                events = [CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: hapticIntensity * 0.2),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
                    ],
                    relativeTime: duration / 2
                )]
            }
            
        default:
            break
        }
        
        do {
            return try CHHapticPattern(events: events, parameters: [])
        } catch {
            print("Failed to create haptic pattern: \(error)")
            return nil
        }
    }
    
    // MARK: - Badge and Achievement Haptics
    
    /// Celebratory haptic for badge unlock
    func triggerBadgeUnlockHaptic() {
        guard isHapticsAvailable else {
            triggerLegacySuccessHaptic()
            return
        }
        
        let events = [
            // First burst
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.9)
                ],
                relativeTime: 0
            ),
            // Second burst
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
                ],
                relativeTime: 0.1
            ),
            // Third burst
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
                ],
                relativeTime: 0.2
            )
        ]
        
        playHapticPattern(events: events)
    }
    
    /// Session completion celebration
    func triggerSessionCompletionHaptic() {
        guard isHapticsAvailable else {
            triggerLegacySuccessHaptic()
            return
        }
        
        let events = createSuccessPattern()
        playHapticPattern(events: events)
    }
    
    // MARK: - Private Haptic Methods
    
    private func triggerInhaleHaptic(intensity: Float) {
        let events = [
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
                ],
                relativeTime: 0
            )
        ]
        playHapticPattern(events: events)
    }
    
    private func triggerHoldHaptic(intensity: Float) {
        let events = [
            CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity * 0.4),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
                ],
                relativeTime: 0,
                duration: 0.5
            )
        ]
        playHapticPattern(events: events)
    }
    
    private func triggerExhaleHaptic(intensity: Float) {
        let events = [
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity * 0.8),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
                ],
                relativeTime: 0
            )
        ]
        playHapticPattern(events: events)
    }
    
    private func triggerPauseHaptic(intensity: Float) {
        let events = [
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity * 0.2),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
                ],
                relativeTime: 0
            )
        ]
        playHapticPattern(events: events)
    }
    
    private func triggerReadyHaptic(intensity: Float) {
        let events = [
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity * 0.6),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ],
                relativeTime: 0
            )
        ]
        playHapticPattern(events: events)
    }
    
    private func triggerCompletionHaptic(intensity: Float) {
        let events = createSuccessPattern(intensity: intensity)
        playHapticPattern(events: events)
    }
    
    private func createSuccessPattern(intensity: Float = 1.0) -> [CHHapticEvent] {
        return [
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity * 0.7),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
                ],
                relativeTime: 0
            ),
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
                ],
                relativeTime: 0.15
            )
        ]
    }
    
    private func createGradualIntensityEvents(
        startTime: TimeInterval,
        duration: TimeInterval,
        startIntensity: Float,
        endIntensity: Float,
        type: CHHapticEvent.EventType
    ) -> [CHHapticEvent] {
        let event = CHHapticEvent(
            eventType: type,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: startIntensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
            ],
            relativeTime: startTime,
            duration: duration
        )
        
        return [event]
    }
    
    private func createPulseEvents(duration: TimeInterval, pulseFrequency: TimeInterval, intensity: Float) -> [CHHapticEvent] {
        var events: [CHHapticEvent] = []
        var currentTime: TimeInterval = 0
        
        while currentTime < duration {
            events.append(
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
                    ],
                    relativeTime: currentTime
                )
            )
            currentTime += pulseFrequency
        }
        
        return events
    }
    
    private func playHapticPattern(events: [CHHapticEvent]) {
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic pattern: \(error)")
        }
    }
    
    private func getHapticIntensityValue(_ intensity: AppSettings.HapticIntensity) -> Float {
        switch intensity {
        case .off:
            return 0.0
        case .light:
            return 0.3
        case .medium:
            return 0.6
        case .strong:
            return 1.0
        }
    }
    
    // MARK: - Legacy Haptic Support
    
    private func triggerLegacyHaptic(for phase: BreathingPhase, intensity: AppSettings.HapticIntensity) {
        guard intensity != .off else { return }
        
        switch phase {
        case .inhale, .ready:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .exhale:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .hold, .pause:
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        case .completed:
            triggerLegacySuccessHaptic()
        }
    }
    
    private func triggerLegacySuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
