//
//  EnhancedBreathingOrbView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct EnhancedBreathingOrbView: View {
    let phase: BreathingPhase
    let pattern: BreathingPattern
    let progress: Double
    let colorScheme: EnhancedColorScheme
    
    @State private var orbScale: CGFloat = 1.0
    @State private var innerOrbScale: CGFloat = 0.8
    @State private var particleOpacity: Double = 0.0
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    private let orbSize: CGFloat = 200
    
    var body: some View {
        ZStack {
            // Background glow
            backgroundGlow
            
            // Particle effects
            particleSystem
            
            // Main breathing orb
            mainOrb
            
            // Progress ring
            progressRing
            
            // Phase indicator
            phaseIndicator
        }
        .frame(width: orbSize * 1.5, height: orbSize * 1.5)
        .onChange(of: phase) { _, newPhase in
            updateOrbForPhase(newPhase)
        }
        .onAppear {
            startContinuousAnimations()
        }
    }
    
    // MARK: - View Components
    
    private var backgroundGlow: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        colorScheme.breathingOrbColors.first?.opacity(0.1) ?? .clear,
                        .clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: orbSize
                )
            )
            .frame(width: orbSize * 2, height: orbSize * 2)
            .scaleEffect(pulseScale)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulseScale)
    }
    
    private var particleSystem: some View {
        ZStack {
            ForEach(0..<8) { index in
                ParticleView(
                    index: index,
                    phase: phase,
                    colors: colorScheme.breathingOrbColors,
                    orbSize: orbSize
                )
            }
        }
        .opacity(particleOpacity)
    }
    
    private var mainOrb: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: colorScheme.breathingOrbColors.map { $0.opacity(0.3) },
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 4
                )
                .frame(width: orbSize + 20, height: orbSize + 20)
                .scaleEffect(orbScale)
            
            // Main orb
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            colorScheme.breathingOrbColors.first?.opacity(0.8) ?? .blue.opacity(0.8),
                            colorScheme.breathingOrbColors.last?.opacity(0.4) ?? .blue.opacity(0.4),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: orbSize / 2
                    )
                )
                .frame(width: orbSize, height: orbSize)
                .scaleEffect(orbScale)
                .overlay(
                    // Inner highlight
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    .white.opacity(0.3),
                                    .clear
                                ],
                                center: UnitPoint(x: 0.3, y: 0.3),
                                startRadius: 0,
                                endRadius: orbSize / 3
                            )
                        )
                        .frame(width: orbSize * 0.6, height: orbSize * 0.6)
                        .scaleEffect(innerOrbScale)
                )
            
            // Center pulse
            Circle()
                .fill(colorScheme.breathingOrbColors.first ?? .blue)
                .frame(width: 20, height: 20)
                .scaleEffect(innerOrbScale * 0.5)
                .opacity(0.8)
        }
        .rotationEffect(.degrees(rotationAngle))
    }
    
    private var progressRing: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(
                colorScheme.primaryColor,
                style: StrokeStyle(
                    lineWidth: 6,
                    lineCap: .round
                )
            )
            .frame(width: orbSize + 40, height: orbSize + 40)
            .rotationEffect(.degrees(-90))
            .animation(.easeInOut(duration: 0.3), value: progress)
    }
    
    private var phaseIndicator: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            Text(phaseText)
                .font(DesignTokens.Typography.title3)
                .fontWeight(.semibold)
                .foregroundColor(colorScheme.primaryColor)
            
            Text(phaseInstruction)
                .font(DesignTokens.Typography.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .offset(y: orbSize * 0.8)
    }
    
    // MARK: - Helper Properties
    
    private var phaseText: String {
        switch phase {
        case .inhale:
            return "Breathe In"
        case .hold:
            return "Hold"
        case .exhale:
            return "Breathe Out"
        case .pause:
            return "Pause"
        case .ready:
            return "Prepare"
        case .completed:
            return "Complete"
        }
    }
    
    private var phaseInstruction: String {
        switch phase {
        case .inhale:
            return "Slowly breathe in through your nose"
        case .hold:
            return "Hold your breath gently"
        case .exhale:
            return "Slowly breathe out through your mouth"
        case .pause:
            return "Rest and pause naturally"
        case .ready:
            return "Get ready to begin"
        case .completed:
            return "Well done! Take a moment to notice how you feel"
        }
    }
    
    // MARK: - Animation Methods
    
    private func updateOrbForPhase(_ newPhase: BreathingPhase) {
        switch newPhase {
        case .inhale:
            withAnimation(.easeInOut(duration: pattern.defaultTiming.inhale)) {
                orbScale = 1.3
                innerOrbScale = 1.1
                particleOpacity = 0.8
            }
            
        case .hold:
            withAnimation(.easeInOut(duration: 0.5)) {
                orbScale = 1.3
                innerOrbScale = 1.1
                particleOpacity = 1.0
            }
            
        case .exhale:
            withAnimation(.easeInOut(duration: pattern.defaultTiming.exhale)) {
                orbScale = 0.8
                innerOrbScale = 0.6
                particleOpacity = 0.3
            }
            
        case .pause:
            withAnimation(.easeInOut(duration: 0.5)) {
                orbScale = 1.0
                innerOrbScale = 0.8
                particleOpacity = 0.1
            }
            
        case .ready:
            withAnimation(.easeInOut(duration: 1.0)) {
                orbScale = 1.0
                innerOrbScale = 0.8
                particleOpacity = 0.5
            }
            
        case .completed:
            withAnimation(.spring(response: 1.0, dampingFraction: 0.6)) {
                orbScale = 1.2
                innerOrbScale = 1.0
                particleOpacity = 1.0
            }
        }
    }
    
    private func startContinuousAnimations() {
        // Rotation animation
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        // Pulse animation
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            pulseScale = 1.1
        }
    }
}

// MARK: - Particle View

struct ParticleView: View {
    let index: Int
    let phase: BreathingPhase
    let colors: [Color]
    let orbSize: CGFloat
    
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.5
    
    private var angle: Double {
        Double(index) * (360.0 / 8.0)
    }
    
    var body: some View {
        Circle()
            .fill(colors.randomElement() ?? .blue)
            .frame(width: 8, height: 8)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(
                x: cos(angle * .pi / 180) * offset,
                y: sin(angle * .pi / 180) * offset
            )
            .onChange(of: phase) { _, newPhase in
                animateForPhase(newPhase)
            }
            .onAppear {
                startParticleAnimation()
            }
    }
    
    private func animateForPhase(_ newPhase: BreathingPhase) {
        switch newPhase {
        case .inhale:
            withAnimation(.easeOut(duration: 2.0).delay(Double(index) * 0.1)) {
                offset = orbSize * 0.3
                opacity = 0.8
                scale = 1.0
            }
            
        case .exhale:
            withAnimation(.easeIn(duration: 2.0).delay(Double(index) * 0.1)) {
                offset = orbSize * 0.1
                opacity = 0.2
                scale = 0.3
            }
            
        default:
            withAnimation(.easeInOut(duration: 1.0)) {
                offset = orbSize * 0.2
                opacity = 0.5
                scale = 0.6
            }
        }
    }
    
    private func startParticleAnimation() {
        // Continuous floating animation
        withAnimation(.easeInOut(duration: 3.0 + Double(index) * 0.5).repeatForever(autoreverses: true)) {
            offset = orbSize * 0.15
        }
        
        withAnimation(.easeInOut(duration: 2.0).delay(Double(index) * 0.2)) {
            opacity = 0.4
            scale = 0.8
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        EnhancedBreathingOrbView(
            phase: .inhale,
            pattern: .fourSevenEight,
            progress: 0.6,
            colorScheme: EnhancedColorScheme.shared
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
        LinearGradient(
            colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}
