//
//  SerenityComponents.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

// MARK: - Serenity Button
/// Elegant button component with zen-inspired design
struct SerenityButton: View {
    let title: String
    let action: () -> Void
    var style: Style = .primary
    var size: Size = .large
    var isEnabled: Bool = true
    
    enum Style {
        case primary, secondary, ghost, floating
    }
    
    enum Size {
        case small, medium, large, extraLarge
    }
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: SerenityDesignSystem.Spacing.sm) {
                Text(title)
                    .font(fontForSize)
                    .foregroundColor(textColor)
                    .kerning(1.2)
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundView)
            .overlay(overlayView)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: 0,
                y: shadowOffset
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .disabled(!isEnabled)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
    
    // MARK: - Style Properties
    
    private var fontForSize: Font {
        switch size {
        case .small: return SerenityDesignSystem.Typography.callout
        case .medium: return SerenityDesignSystem.Typography.body
        case .large: return SerenityDesignSystem.Typography.bodyEmphasized
        case .extraLarge: return SerenityDesignSystem.Typography.title3
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch size {
        case .small: return SerenityDesignSystem.Spacing.md
        case .medium: return SerenityDesignSystem.Spacing.lg
        case .large: return SerenityDesignSystem.Spacing.xl
        case .extraLarge: return SerenityDesignSystem.Spacing.xxl
        }
    }
    
    private var verticalPadding: CGFloat {
        switch size {
        case .small: return SerenityDesignSystem.Spacing.sm
        case .medium: return SerenityDesignSystem.Spacing.md
        case .large: return SerenityDesignSystem.Spacing.lg
        case .extraLarge: return SerenityDesignSystem.Spacing.xl
        }
    }
    
    private var cornerRadius: CGFloat {
        switch size {
        case .small: return SerenityDesignSystem.CornerRadius.small
        case .medium: return SerenityDesignSystem.CornerRadius.medium
        case .large: return SerenityDesignSystem.CornerRadius.large
        case .extraLarge: return SerenityDesignSystem.CornerRadius.extraLarge
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary: return SerenityDesignSystem.Colors.crystalWhite
        case .secondary: return SerenityDesignSystem.Colors.softSkyBlue
        case .ghost: return SerenityDesignSystem.Colors.softSkyBlue
        case .floating: return SerenityDesignSystem.Colors.deepCharcoal
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            SerenityDesignSystem.Colors.sageGreen
        case .secondary:
            SerenityDesignSystem.Colors.softGray
        case .ghost:
            Color.clear
        case .floating:
            SerenityDesignSystem.Colors.crystalWhite
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch style {
        case .ghost:
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(SerenityDesignSystem.Colors.softSkyBlue.opacity(0.6), lineWidth: 1.5)
        default:
            EmptyView()
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .floating: return SerenityDesignSystem.Shadow.medium
        default: return SerenityDesignSystem.Shadow.gentle
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .floating: return SerenityDesignSystem.Shadow.mediumRadius
        default: return SerenityDesignSystem.Shadow.gentleRadius
        }
    }
    
    private var shadowOffset: CGFloat {
        switch style {
        case .floating: return 4
        default: return 2
        }
    }
}

// MARK: - Serenity Card
/// Elegant card component with neumorphic design
struct SerenityCard<Content: View>: View {
    let content: Content
    var padding: CGFloat = SerenityDesignSystem.Spacing.lg
    var cornerRadius: CGFloat = SerenityDesignSystem.CornerRadius.large
    var showShadow: Bool = true
    
    init(
        padding: CGFloat = SerenityDesignSystem.Spacing.lg,
        cornerRadius: CGFloat = SerenityDesignSystem.CornerRadius.large,
        showShadow: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.showShadow = showShadow
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(SerenityDesignSystem.Colors.crystalWhite)
                    .shadow(
                        color: showShadow ? SerenityDesignSystem.Shadow.soft : .clear,
                        radius: showShadow ? SerenityDesignSystem.Shadow.softRadius : 0,
                        x: 0,
                        y: showShadow ? 2 : 0
                    )
            )
    }
}

// MARK: - Breathing Orb
/// Central breathing visualization with fluid animations
struct BreathingOrb: View {
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 0.8
    
    let size: CGFloat
    let isAnimating: Bool
    let breathPhase: BreathPhase
    
    enum BreathPhase {
        case inhale, hold, exhale, pause
        
        var scale: CGFloat {
            switch self {
            case .inhale: return 1.2
            case .hold: return 1.2
            case .exhale: return 0.8
            case .pause: return 0.8
            }
        }
        
        var opacity: Double {
            switch self {
            case .inhale: return 1.0
            case .hold: return 0.9
            case .exhale: return 0.6
            case .pause: return 0.7
            }
        }
        
        var duration: Double {
            switch self {
            case .inhale: return SerenityDesignSystem.Animation.inhale
            case .hold: return SerenityDesignSystem.Animation.hold
            case .exhale: return SerenityDesignSystem.Animation.exhale
            case .pause: return SerenityDesignSystem.Animation.pause
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            SerenityDesignSystem.Colors.oceanTeal.opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: size * 0.3,
                        endRadius: size * 0.6
                    )
                )
                .frame(width: size * 1.4, height: size * 1.4)
                .scaleEffect(scale * 1.1)
                .opacity(opacity * 0.5)
            
            // Main orb
            Circle()
                .fill(SerenityDesignSystem.Colors.breathGradient)
                .frame(width: size, height: size)
                .scaleEffect(scale)
                .opacity(opacity)
                .overlay(
                    Circle()
                        .stroke(
                            SerenityDesignSystem.Colors.crystalWhite.opacity(0.3),
                            lineWidth: 2
                        )
                        .scaleEffect(scale)
                )
            
            // Inner light
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            SerenityDesignSystem.Colors.crystalWhite.opacity(0.6),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.3
                    )
                )
                .frame(width: size * 0.6, height: size * 0.6)
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
        }
        .onChange(of: breathPhase) { oldPhase, newPhase in
            if isAnimating {
                animateToPhase(newPhase)
            }
        }
        .onAppear {
            if isAnimating {
                startContinuousRotation()
            }
        }
    }
    
    private func animateToPhase(_ phase: BreathPhase) {
        withAnimation(
            .easeInOut(duration: phase.duration)
        ) {
            scale = phase.scale
            opacity = phase.opacity
        }
    }
    
    private func startContinuousRotation() {
        withAnimation(
            .linear(duration: 20)
            .repeatForever(autoreverses: false)
        ) {
            rotation = 360
        }
    }
}

// MARK: - Floating Particles
/// Ambient particle system for zen atmosphere
struct FloatingParticles: View {
    @State private var particleOffsets: [CGPoint] = []
    @State private var particleOpacities: [Double] = []
    
    let particleCount: Int = 8
    let screenSize: CGSize
    
    var body: some View {
        ZStack {
            ForEach(0..<particleCount, id: \.self) { index in
                Circle()
                    .fill(SerenityDesignSystem.Colors.lavenderMist.opacity(0.4))
                    .frame(width: randomSize(), height: randomSize())
                    .offset(
                        x: particleOffsets.indices.contains(index) ? particleOffsets[index].x : 0,
                        y: particleOffsets.indices.contains(index) ? particleOffsets[index].y : 0
                    )
                    .opacity(particleOpacities.indices.contains(index) ? particleOpacities[index] : 0)
                    .animation(
                        .easeInOut(duration: Double.random(in: 3...6))
                        .repeatForever(autoreverses: true)
                        .delay(Double.random(in: 0...2)),
                        value: particleOffsets.indices.contains(index) ? particleOffsets[index] : .zero
                    )
            }
        }
        .onAppear {
            initializeParticles()
            animateParticles()
        }
    }
    
    private func randomSize() -> CGFloat {
        CGFloat.random(in: 3...8)
    }
    
    private func initializeParticles() {
        particleOffsets = (0..<particleCount).map { _ in
            CGPoint(
                x: CGFloat.random(in: -screenSize.width/2...screenSize.width/2),
                y: CGFloat.random(in: -screenSize.height/2...screenSize.height/2)
            )
        }
        
        particleOpacities = (0..<particleCount).map { _ in
            Double.random(in: 0.2...0.6)
        }
    }
    
    private func animateParticles() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for index in 0..<particleCount {
                if particleOffsets.indices.contains(index) {
                    let randomOffset = CGPoint(
                        x: CGFloat.random(in: -20...20),
                        y: CGFloat.random(in: -30...10)
                    )
                    particleOffsets[index].x += randomOffset.x
                    particleOffsets[index].y += randomOffset.y
                    
                    // Wrap around screen
                    if particleOffsets[index].y < -screenSize.height/2 {
                        particleOffsets[index].y = screenSize.height/2
                    }
                }
            }
        }
    }
}

// MARK: - Progress Ring
/// Circular progress indicator for streaks and session progress
struct ProgressRing: View {
    let progress: Double // 0.0 to 1.0
    let lineWidth: CGFloat
    let size: CGFloat
    let color: Color
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(
                    color.opacity(0.2),
                    lineWidth: lineWidth
                )
                .frame(width: size, height: size)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(
                    .easeInOut(duration: SerenityDesignSystem.Animation.smooth),
                    value: animatedProgress
                )
        }
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: progress) { oldValue, newValue in
            animatedProgress = newValue
        }
    }
}

// MARK: - Mood Selector
/// Elegant mood selection interface
struct MoodSelector: View {
    @Binding var selectedMood: MoodLevel?
    
    let moods: [MoodLevel] = [.veryStressed, .stressed, .neutral, .calm, .veryCalm]
    
    var body: some View {
        HStack(spacing: SerenityDesignSystem.Spacing.md) {
            ForEach(moods, id: \.self) { mood in
                Button(action: {
                    selectedMood = mood
                }) {
                    VStack(spacing: SerenityDesignSystem.Spacing.xs) {
                        Text(mood.emoji)
                            .font(.title2)
                            .scaleEffect(selectedMood == mood ? 1.2 : 1.0)
                            .animation(
                                .spring(response: 0.3, dampingFraction: 0.6),
                                value: selectedMood == mood
                            )
                        
                        Text(mood.description)
                            .font(SerenityDesignSystem.Typography.caption)
                            .foregroundColor(
                                selectedMood == mood
                                ? SerenityDesignSystem.Colors.softSkyBlue
                                : SerenityDesignSystem.Colors.deepCharcoal.opacity(0.6)
                            )
                    }
                    .padding(SerenityDesignSystem.Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: SerenityDesignSystem.CornerRadius.small)
                            .fill(
                                selectedMood == mood
                                ? SerenityDesignSystem.Colors.softSkyBlue.opacity(0.1)
                                : Color.clear
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview("Serenity Components") {
    VStack(spacing: SerenityDesignSystem.Spacing.xl) {
        // Button Examples
        SerenityButton(title: "Start Session", action: {})
        
        SerenityButton(title: "Secondary", action: {}, style: .secondary)
        
        SerenityButton(title: "Ghost", action: {}, style: .ghost)
        
        // Card Example
        SerenityCard {
            VStack {
                Text("Serenity Card")
                    .font(SerenityDesignSystem.Typography.title2)
                Text("Beautiful card component")
                    .font(SerenityDesignSystem.Typography.body)
            }
        }
        
        // Breathing Orb
        BreathingOrb(
            size: 150,
            isAnimating: true,
            breathPhase: .inhale
        )
        
        // Progress Ring
        ProgressRing(
            progress: 0.7,
            lineWidth: 8,
            size: 60,
            color: SerenityDesignSystem.Colors.sageGreen
        )
    }
    .padding()
    .background(SerenityDesignSystem.Colors.warmOffWhite)
}
