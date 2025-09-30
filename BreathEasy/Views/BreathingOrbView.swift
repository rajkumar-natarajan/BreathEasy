//
//  BreathingOrbView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Animated breathing orb that guides users through breathing phases
struct BreathingOrbView: View {
    let colorScheme: BreathingColorScheme
    let phase: BreathingPhase
    let scale: Double
    let opacity: Double
    let particleOffset: CGSize
    
    @Environment(\.colorScheme) private var systemColorScheme
    
    var body: some View {
        ZStack {
            // Background particles for ambiance
            if phase == .exhale || phase == .completed {
                ForEach(0..<8, id: \.self) { index in
                    Circle()
                        .fill(
                            ColorSchemeManager.particleColors(for: colorScheme)[index % 3]
                        )
                        .frame(width: 8, height: 8)
                        .offset(
                            x: particleOffset.width * Double(index) * 0.3 + cos(Double(index) * 0.785) * 40,
                            y: particleOffset.height * Double(index) * 0.3 + sin(Double(index) * 0.785) * 40
                        )
                        .opacity(phase == .exhale ? 0.7 : 0.3)
                        .animation(
                            .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.1),
                            value: particleOffset
                        )
                }
            }
            
            // Main breathing orb
            ZStack {
                // Outer glow ring
                Circle()
                    .stroke(
                        ColorSchemeManager.primaryColor(for: colorScheme).opacity(0.3),
                        lineWidth: 2
                    )
                    .frame(width: 220, height: 220)
                    .scaleEffect(scale * 1.1)
                    .opacity(opacity * 0.5)
                
                // Middle ring
                Circle()
                    .stroke(
                        ColorSchemeManager.accentColor(for: colorScheme).opacity(0.5),
                        lineWidth: 1
                    )
                    .frame(width: 180, height: 180)
                    .scaleEffect(scale)
                    .opacity(opacity * 0.7)
                
                // Main orb with gradient fill
                Circle()
                    .fill(ColorSchemeManager.orbGradient(for: colorScheme, phase: phase))
                    .frame(width: 160, height: 160)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .overlay(
                        // Inner highlight
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        .white.opacity(0.4),
                                        .clear
                                    ]),
                                    center: UnitPoint(x: 0.3, y: 0.3),
                                    startRadius: 5,
                                    endRadius: 50
                                )
                            )
                            .frame(width: 120, height: 120)
                            .scaleEffect(scale)
                    )
                
                // Phase indicator dot
                Circle()
                    .fill(ColorSchemeManager.accentColor(for: colorScheme))
                    .frame(width: 12, height: 12)
                    .scaleEffect(phaseIndicatorScale)
                    .opacity(0.9)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true),
                        value: phase
                    )
            }
            .shadow(
                color: ColorSchemeManager.primaryColor(for: colorScheme).opacity(0.3),
                radius: 20,
                x: 0,
                y: 0
            )
        }
        .frame(width: 300, height: 300)
    }
    
    /// Scale for the phase indicator based on current phase
    private var phaseIndicatorScale: Double {
        switch phase {
        case .inhale:
            return 1.5
        case .hold:
            return 1.0
        case .exhale:
            return 0.5
        case .pause:
            return 0.8
        case .ready:
            return 1.2
        case .completed:
            return 2.0
        }
    }
}

/// Preview for breathing orb
#Preview("Breathing Orb - Inhale") {
    BreathingOrbView(
        colorScheme: .blue,
        phase: .inhale,
        scale: 1.2,
        opacity: 0.9,
        particleOffset: CGSize(width: 10, height: 15)
    )
    .background(Color.black)
}

#Preview("Breathing Orb - Exhale") {
    BreathingOrbView(
        colorScheme: .green,
        phase: .exhale,
        scale: 0.8,
        opacity: 0.7,
        particleOffset: CGSize(width: 25, height: 20)
    )
    .background(Color.black)
}
