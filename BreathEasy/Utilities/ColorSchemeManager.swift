//
//  ColorSchemeManager.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Manages color themes for breathing patterns
struct ColorSchemeManager {
    
    /// Gets gradient colors for a breathing color scheme
    static func gradientColors(for scheme: BreathingColorScheme) -> [Color] {
        switch scheme {
        case .blue:
            return [
                Color(red: 0.2, green: 0.6, blue: 1.0),    // Light blue
                Color(red: 0.1, green: 0.3, blue: 0.8),    // Medium blue
                Color(red: 0.05, green: 0.2, blue: 0.6)    // Deep blue
            ]
            
        case .green:
            return [
                Color(red: 0.3, green: 0.9, blue: 0.5),    // Light green
                Color(red: 0.2, green: 0.7, blue: 0.4),    // Medium green
                Color(red: 0.1, green: 0.5, blue: 0.3)     // Deep green
            ]
            
        case .purple:
            return [
                Color(red: 0.7, green: 0.4, blue: 1.0),    // Light purple
                Color(red: 0.5, green: 0.2, blue: 0.8),    // Medium purple
                Color(red: 0.3, green: 0.1, blue: 0.6)     // Deep purple
            ]
            
        case .ocean:
            return [
                Color(red: 0.4, green: 0.8, blue: 0.9),    // Light ocean
                Color(red: 0.2, green: 0.6, blue: 0.8),    // Medium ocean
                Color(red: 0.1, green: 0.4, blue: 0.7)     // Deep ocean
            ]
            
        case .sunset:
            return [
                Color(red: 1.0, green: 0.7, blue: 0.4),    // Warm orange
                Color(red: 0.9, green: 0.5, blue: 0.6),    // Coral
                Color(red: 0.7, green: 0.3, blue: 0.5)     // Deep coral
            ]
        }
    }
    
    /// Gets primary color for a scheme
    static func primaryColor(for scheme: BreathingColorScheme) -> Color {
        return gradientColors(for: scheme)[1]
    }
    
    /// Gets accent color for a scheme
    static func accentColor(for scheme: BreathingColorScheme) -> Color {
        return gradientColors(for: scheme)[0]
    }
    
    /// Gets background gradient for a scheme
    static func backgroundGradient(for scheme: BreathingColorScheme) -> LinearGradient {
        let colors = gradientColors(for: scheme)
        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Gets radial gradient for breathing orb
    static func orbGradient(for scheme: BreathingColorScheme, phase: BreathingPhase) -> RadialGradient {
        let colors = gradientColors(for: scheme)
        
        let phaseColors: [Color]
        switch phase {
        case .inhale:
            phaseColors = [colors[0].opacity(0.9), colors[1].opacity(0.7)]
        case .hold:
            phaseColors = [colors[1].opacity(0.8), colors[2].opacity(0.6)]
        case .exhale:
            phaseColors = [colors[0].opacity(0.6), colors[2].opacity(0.9)]
        case .pause:
            phaseColors = [colors[0].opacity(0.5), colors[1].opacity(0.3)]
        case .ready:
            phaseColors = [colors[1].opacity(0.7), colors[0].opacity(0.5)]
        case .completed:
            phaseColors = [colors[0], colors[1]]
        }
        
        return RadialGradient(
            gradient: Gradient(colors: phaseColors),
            center: .center,
            startRadius: 10,
            endRadius: 150
        )
    }
    
    /// Gets particle colors for exhale animations
    static func particleColors(for scheme: BreathingColorScheme) -> [Color] {
        let colors = gradientColors(for: scheme)
        return colors.map { $0.opacity(0.6) }
    }
}

/// Custom modifier for breathing-themed styling
struct BreathingThemeModifier: ViewModifier {
    let colorScheme: BreathingColorScheme
    let phase: BreathingPhase
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(ColorSchemeManager.primaryColor(for: colorScheme))
            .background(
                ColorSchemeManager.backgroundGradient(for: colorScheme)
                    .opacity(0.1)
            )
    }
}

extension View {
    /// Applies breathing theme styling
    func breathingTheme(_ colorScheme: BreathingColorScheme, phase: BreathingPhase = .ready) -> some View {
        modifier(BreathingThemeModifier(colorScheme: colorScheme, phase: phase))
    }
}
