//
//  SpeechManager.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Foundation
import AVFoundation

/// Manages text-to-speech guidance for breathing exercises
@Observable
class SpeechManager: NSObject, @unchecked Sendable {
    static let shared = SpeechManager()
    
    private let synthesizer = AVSpeechSynthesizer()
    private var currentLanguage: AppSettings.AppLanguage = .english
    
    override init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
    }
    
    // MARK: - Configuration
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    func updateLanguage(_ language: AppSettings.AppLanguage) {
        currentLanguage = language
    }
    
    // MARK: - Breathing Guidance
    
    /// Speaks guidance for breathing phase
    func speakBreathingGuidance(for phase: BreathingPhase, duration: TimeInterval? = nil) {
        let text = getBreathingGuidanceText(for: phase, duration: duration)
        speak(text: text)
    }
    
    /// Speaks session start guidance
    func speakSessionStart(pattern: BreathingPattern, duration: TimeInterval) {
        let minutes = Int(duration) / 60
        let text: String
        
        switch currentLanguage {
        case .english:
            if minutes > 0 {
                text = "Starting \(pattern.displayName) session for \(minutes) minutes. Get comfortable and begin when ready."
            } else {
                text = "Starting \(pattern.displayName) session. Get comfortable and begin when ready."
            }
        case .spanish:
            if minutes > 0 {
                text = "Iniciando sesión de \(getSpanishPatternName(pattern)) por \(minutes) minutos. Ponte cómodo y comienza cuando estés listo."
            } else {
                text = "Iniciando sesión de \(getSpanishPatternName(pattern)). Ponte cómodo y comienza cuando estés listo."
            }
        }
        
        speak(text: text)
    }
    
    /// Speaks session completion message
    func speakSessionCompletion(cyclesCompleted: Int, moodImprovement: Bool) {
        let text: String
        
        switch currentLanguage {
        case .english:
            if moodImprovement {
                text = "Excellent work! You completed \(cyclesCompleted) breathing cycles and improved your wellbeing."
            } else {
                text = "Well done! You completed \(cyclesCompleted) breathing cycles. Great job on your practice."
            }
        case .spanish:
            if moodImprovement {
                text = "¡Excelente trabajo! Completaste \(cyclesCompleted) ciclos de respiración y mejoraste tu bienestar."
            } else {
                text = "¡Bien hecho! Completaste \(cyclesCompleted) ciclos de respiración. Gran trabajo en tu práctica."
            }
        }
        
        speak(text: text)
    }
    
    /// Speaks badge unlock announcement
    func speakBadgeUnlock(_ badge: BreathingBadge) {
        let text: String
        
        switch currentLanguage {
        case .english:
            text = "Congratulations! You've unlocked the \(badge.title) badge. \(badge.description)"
        case .spanish:
            text = "¡Felicidades! Has desbloqueado la insignia \(getSpanishBadgeTitle(badge)). \(getSpanishBadgeDescription(badge))"
        }
        
        speak(text: text)
    }
    
    /// Speaks reminder message
    func speakReminder() {
        let text: String
        
        switch currentLanguage {
        case .english:
            text = "Time for your mindful breathing practice. Take a moment to center yourself."
        case .spanish:
            text = "Es hora de tu práctica de respiración consciente. Tómate un momento para centrarte."
        }
        
        speak(text: text)
    }
    
    // MARK: - Speech Control
    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func pauseSpeaking() {
        synthesizer.pauseSpeaking(at: .immediate)
    }
    
    func continueSpeaking() {
        synthesizer.continueSpeaking()
    }
    
    var isSpeaking: Bool {
        return synthesizer.isSpeaking
    }
    
    // MARK: - Private Methods
    
    private func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = getVoiceForLanguage()
        utterance.rate = 0.5 // Slower, calming pace
        utterance.pitchMultiplier = 0.9 // Slightly lower pitch for relaxation
        utterance.volume = 0.8
        
        synthesizer.speak(utterance)
    }
    
    private func getVoiceForLanguage() -> AVSpeechSynthesisVoice? {
        let languageCode: String
        
        switch currentLanguage {
        case .english:
            languageCode = "en-US"
        case .spanish:
            languageCode = "es-ES"
        }
        
        return AVSpeechSynthesisVoice(language: languageCode)
    }
    
    private func getBreathingGuidanceText(for phase: BreathingPhase, duration: TimeInterval?) -> String {
        switch currentLanguage {
        case .english:
            return getEnglishGuidanceText(for: phase, duration: duration)
        case .spanish:
            return getSpanishGuidanceText(for: phase, duration: duration)
        }
    }
    
    private func getEnglishGuidanceText(for phase: BreathingPhase, duration: TimeInterval?) -> String {
        switch phase {
        case .ready:
            return "Get ready to begin"
        case .inhale:
            if let duration = duration, duration > 4 {
                return "Breathe in slowly and deeply"
            } else {
                return "Breathe in"
            }
        case .hold:
            if let duration = duration, duration > 4 {
                return "Hold your breath gently"
            } else {
                return "Hold"
            }
        case .exhale:
            if let duration = duration, duration > 6 {
                return "Breathe out slowly and completely"
            } else {
                return "Breathe out"
            }
        case .pause:
            return "Rest and relax"
        case .completed:
            return "Beautiful work. You're finished."
        }
    }
    
    private func getSpanishGuidanceText(for phase: BreathingPhase, duration: TimeInterval?) -> String {
        switch phase {
        case .ready:
            return "Prepárate para comenzar"
        case .inhale:
            if let duration = duration, duration > 4 {
                return "Inhala lenta y profundamente"
            } else {
                return "Inhala"
            }
        case .hold:
            if let duration = duration, duration > 4 {
                return "Mantén la respiración suavemente"
            } else {
                return "Mantén"
            }
        case .exhale:
            if let duration = duration, duration > 6 {
                return "Exhala lenta y completamente"
            } else {
                return "Exhala"
            }
        case .pause:
            return "Descansa y relájate"
        case .completed:
            return "Hermoso trabajo. Has terminado."
        }
    }
    
    private func getSpanishPatternName(_ pattern: BreathingPattern) -> String {
        switch pattern {
        case .fourSevenEight:
            return "Respiración 4-7-8"
        case .box:
            return "Respiración Cuadrada"
        case .diaphragmatic:
            return "Respiración Diafragmática"
        case .resonant:
            return "Respiración Resonante"
        case .custom:
            return "Patrón Personalizado"
        }
    }
    
    private func getSpanishBadgeTitle(_ badge: BreathingBadge) -> String {
        switch badge {
        case .firstSession:
            return "Primera Respiración"
        case .threeDayStreak:
            return "Comenzando"
        case .sevenDayStreak:
            return "Guerrero de la Semana"
        case .thirtyDayStreak:
            return "Maestro Mensual"
        case .hundredSessions:
            return "Experto en Respiración"
        case .fiveHundredSessions:
            return "Gurú de la Atención Plena"
        case .zenMaster:
            return "Maestro Zen"
        case .customExplorer:
            return "Explorador de Patrones"
        case .moodImprover:
            return "Alquimista del Estado de Ánimo"
        case .consistentPractice:
            return "Respiración Constante"
        }
    }
    
    private func getSpanishBadgeDescription(_ badge: BreathingBadge) -> String {
        switch badge {
        case .firstSession:
            return "Completaste tu primera sesión de respiración"
        case .threeDayStreak:
            return "3 días de práctica constante"
        case .sevenDayStreak:
            return "7 días de respiración consciente"
        case .thirtyDayStreak:
            return "30 días de dedicación"
        case .hundredSessions:
            return "100 sesiones de respiración completadas"
        case .fiveHundredSessions:
            return "500 sesiones de paz interior"
        case .zenMaster:
            return "Dominaste todos los patrones de respiración"
        case .customExplorer:
            return "Creaste 5 patrones personalizados"
        case .moodImprover:
            return "Mejoraste el estado de ánimo en 10 sesiones"
        case .consistentPractice:
            return "14 días consecutivos de práctica"
        }
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension SpeechManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        // Optional: Track speech events
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // Optional: Handle speech completion
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        // Optional: Handle speech cancellation
    }
}
