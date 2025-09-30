//
//  SessionViewModel.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Foundation
import SwiftUI
import CoreHaptics

/// ViewModel managing breathing session state and timer logic
@Observable
class SessionViewModel {
    
    // MARK: - Session State
    private(set) var currentPhase: BreathingPhase = .ready
    private(set) var currentPattern: BreathingPattern = .fourSevenEight
    private(set) var customTiming: BreathingTiming?
    private(set) var isSessionActive = false
    private(set) var isPaused = false
    private(set) var sessionDuration: TimeInterval = 300 // 5 minutes default
    private(set) var elapsedTime: TimeInterval = 0
    private(set) var currentCycle = 0
    private(set) var totalCycles = 0
    private(set) var phaseProgress: Double = 0.0
    private(set) var sessionProgress: Double = 0.0
    
    // MARK: - Phase Timing
    private(set) var phaseTimeRemaining: TimeInterval = 0
    private(set) var phaseStartTime: Date = Date()
    
    // MARK: - Session Data
    private(set) var sessionStartTime: Date?
    private(set) var moodBefore: MoodLevel?
    private(set) var moodAfter: MoodLevel?
    
    // MARK: - Animation Properties
    private(set) var orbScale: Double = 1.0
    private(set) var orbOpacity: Double = 0.8
    private(set) var particleOffset: CGSize = .zero
    private(set) var breathingRate: Double = 1.0
    
    // MARK: - Dependencies
    private let dataManager = DataManager.shared
    private let hapticManager = HapticManager.shared
    private let speechManager = SpeechManager.shared
    
    // MARK: - Timers
    private var sessionTimer: Timer?
    private var phaseTimer: Timer?
    private var animationTimer: Timer?
    
    // MARK: - Configuration
    private var settings: AppSettings {
        return dataManager.settings
    }
    
    // MARK: - Session Management
    
    /// Configures session with pattern and duration
    func configureSession(pattern: BreathingPattern, customTiming: BreathingTiming? = nil, duration: TimeInterval = 300) {
        self.currentPattern = pattern
        self.customTiming = customTiming
        self.sessionDuration = duration
        
        let timing = customTiming ?? pattern.defaultTiming
        self.totalCycles = Int(duration / timing.totalDuration)
        
        resetSessionState()
    }
    
    /// Sets pre-session mood
    func setMoodBefore(_ mood: MoodLevel) {
        self.moodBefore = mood
    }
    
    /// Sets post-session mood
    func setMoodAfter(_ mood: MoodLevel) {
        self.moodAfter = mood
    }
    
    /// Starts the breathing session
    func startSession() {
        guard !isSessionActive else { return }
        
        sessionStartTime = Date()
        isSessionActive = true
        isPaused = false
        currentPhase = .ready
        elapsedTime = 0
        currentCycle = 0
        
        // Announce session start
        if settings.enableSoundCues {
            speechManager.speakSessionStart(pattern: currentPattern, duration: sessionDuration)
        }
        
        // Start with ready phase
        startPhase(.ready, duration: 3.0)
        
        // Start main session timer
        startSessionTimer()
    }
    
    /// Pauses the session
    func pauseSession() {
        guard isSessionActive && !isPaused else { return }
        
        isPaused = true
        stopAllTimers()
        
        if settings.enableHaptics {
            hapticManager.triggerBreathingHaptic(for: .pause, intensity: settings.hapticIntensity)
        }
    }
    
    /// Resumes the session
    func resumeSession() {
        guard isSessionActive && isPaused else { return }
        
        isPaused = false
        phaseStartTime = Date()
        
        // Resume timers
        startSessionTimer()
        startPhaseTimer()
        startAnimationTimer()
        
        if settings.enableHaptics {
            hapticManager.triggerBreathingHaptic(for: currentPhase, intensity: settings.hapticIntensity)
        }
    }
    
    /// Stops the session
    func stopSession() {
        guard isSessionActive else { return }
        
        stopAllTimers()
        
        // Save session data
        saveSession(completed: false)
        
        // Reset state
        resetSessionState()
    }
    
    /// Completes the session
    func completeSession() {
        guard isSessionActive else { return }
        
        stopAllTimers()
        
        // Announce completion
        if settings.enableSoundCues {
            let moodImproved = (moodAfter?.rawValue ?? 0) > (moodBefore?.rawValue ?? 0)
            speechManager.speakSessionCompletion(cyclesCompleted: currentCycle, moodImprovement: moodImproved)
        }
        
        // Celebration haptics
        if settings.enableHaptics {
            hapticManager.triggerSessionCompletionHaptic()
        }
        
        // Save session data
        saveSession(completed: true)
        
        // Update phase for completion state
        currentPhase = .completed
    }
    
    // MARK: - Phase Management
    
    private func startPhase(_ phase: BreathingPhase, duration: TimeInterval) {
        currentPhase = phase
        phaseTimeRemaining = duration
        phaseStartTime = Date()
        phaseProgress = 0.0
        
        // Trigger haptic feedback
        if settings.enableHaptics {
            hapticManager.triggerBreathingHaptic(for: phase, intensity: settings.hapticIntensity)
        }
        
        // Trigger speech guidance
        if settings.enableSoundCues && phase != .ready {
            speechManager.speakBreathingGuidance(for: phase, duration: duration)
        }
        
        // Start phase timer
        startPhaseTimer()
        
        // Start animation timer
        startAnimationTimer()
        
        // Update breathing animation properties
        updateBreathingAnimation(for: phase, duration: duration)
    }
    
    private func advanceToNextPhase() {
        let timing = customTiming ?? currentPattern.defaultTiming
        
        switch currentPhase {
        case .ready:
            startPhase(.inhale, duration: timing.inhale)
            
        case .inhale:
            if timing.hold > 0 {
                startPhase(.hold, duration: timing.hold)
            } else {
                startPhase(.exhale, duration: timing.exhale)
            }
            
        case .hold:
            startPhase(.exhale, duration: timing.exhale)
            
        case .exhale:
            if timing.pause > 0 {
                startPhase(.pause, duration: timing.pause)
            } else {
                completeCurrentCycle()
            }
            
        case .pause:
            completeCurrentCycle()
            
        case .completed:
            break
        }
    }
    
    private func completeCurrentCycle() {
        currentCycle += 1
        
        // Check if session should continue
        if elapsedTime < sessionDuration && currentCycle < totalCycles {
            startPhase(.inhale, duration: customTiming?.inhale ?? currentPattern.defaultTiming.inhale)
        } else {
            completeSession()
        }
    }
    
    // MARK: - Timer Management
    
    private func startSessionTimer() {
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateSessionProgress()
        }
    }
    
    private func startPhaseTimer() {
        phaseTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updatePhaseProgress()
        }
    }
    
    private func startAnimationTimer() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            self?.updateAnimations()
        }
    }
    
    private func stopAllTimers() {
        sessionTimer?.invalidate()
        phaseTimer?.invalidate()
        animationTimer?.invalidate()
        sessionTimer = nil
        phaseTimer = nil
        animationTimer = nil
    }
    
    // MARK: - Progress Updates
    
    private func updateSessionProgress() {
        guard isSessionActive && !isPaused else { return }
        
        elapsedTime += 0.1
        sessionProgress = min(elapsedTime / sessionDuration, 1.0)
        
        // Check for session completion
        if elapsedTime >= sessionDuration {
            completeSession()
        }
    }
    
    private func updatePhaseProgress() {
        guard isSessionActive && !isPaused else { return }
        
        let elapsed = Date().timeIntervalSince(phaseStartTime)
        phaseTimeRemaining = max(0, phaseTimeRemaining - 0.1)
        phaseProgress = elapsed / (elapsed + phaseTimeRemaining)
        
        // Check for phase completion
        if phaseTimeRemaining <= 0 {
            advanceToNextPhase()
        }
    }
    
    // MARK: - Breathing Animations
    
    private func updateBreathingAnimation(for phase: BreathingPhase, duration: TimeInterval) {
        withAnimation(.easeInOut(duration: duration)) {
            switch phase {
            case .ready:
                orbScale = 1.0
                orbOpacity = 0.8
                breathingRate = 1.0
                
            case .inhale:
                orbScale = 1.4
                orbOpacity = 1.0
                breathingRate = 0.8
                
            case .hold:
                orbScale = 1.4
                orbOpacity = 0.9
                breathingRate = 0.6
                
            case .exhale:
                orbScale = 0.8
                orbOpacity = 0.6
                breathingRate = 1.2
                
            case .pause:
                orbScale = 1.0
                orbOpacity = 0.7
                breathingRate = 1.0
                
            case .completed:
                orbScale = 1.2
                orbOpacity = 1.0
                breathingRate = 1.0
            }
        }
    }
    
    private func updateAnimations() {
        guard isSessionActive && !isPaused else { return }
        
        // Update particle effects for exhale phase
        if currentPhase == .exhale {
            let time = Date().timeIntervalSince(phaseStartTime)
            let maxOffset: CGFloat = 50
            let offsetMagnitude = sin(time * 3) * maxOffset
            particleOffset = CGSize(
                width: cos(time * 2) * offsetMagnitude,
                height: sin(time * 2.5) * offsetMagnitude
            )
        } else {
            particleOffset = .zero
        }
    }
    
    // MARK: - Data Persistence
    
    private func saveSession(completed: Bool) {
        guard let startTime = sessionStartTime else { return }
        
        let session = BreathingSession(
            date: startTime,
            pattern: currentPattern,
            customTiming: customTiming,
            duration: elapsedTime,
            cyclesCompleted: currentCycle,
            moodBefore: moodBefore,
            moodAfter: moodAfter,
            wasCompleted: completed
        )
        
        dataManager.saveSession(session)
    }
    
    private func resetSessionState() {
        isSessionActive = false
        isPaused = false
        currentPhase = .ready
        elapsedTime = 0
        currentCycle = 0
        phaseProgress = 0.0
        sessionProgress = 0.0
        phaseTimeRemaining = 0
        sessionStartTime = nil
        
        // Reset animation properties
        orbScale = 1.0
        orbOpacity = 0.8
        particleOffset = .zero
        breathingRate = 1.0
        
        stopAllTimers()
    }
    
    // MARK: - Computed Properties
    
    /// Formatted time remaining in session
    var sessionTimeRemaining: String {
        let remaining = max(0, sessionDuration - elapsedTime)
        let minutes = Int(remaining) / 60
        let seconds = Int(remaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    /// Formatted phase time remaining
    var phaseTimeRemainingFormatted: String {
        return String(format: "%.1f", phaseTimeRemaining)
    }
    
    /// Current phase instruction text
    var currentPhaseInstruction: String {
        return currentPhase.instruction
    }
    
    /// Session can be paused
    var canPause: Bool {
        return isSessionActive && !isPaused && currentPhase != .ready && currentPhase != .completed
    }
    
    /// Session can be resumed
    var canResume: Bool {
        return isSessionActive && isPaused
    }
}
