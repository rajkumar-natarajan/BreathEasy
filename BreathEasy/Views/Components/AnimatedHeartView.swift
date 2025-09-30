//
//  AnimatedHeartView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// 3D animated heart that pumps blood during breathing exercises
struct AnimatedHeartView: View {
    let phase: BreathingPhase
    let pattern: BreathingPattern
    let progress: Double
    let colorScheme: EnhancedColorScheme
    
    @State private var heartScale: CGFloat = 1.0
    @State private var heartRotation: Double = 0
    @State private var bloodPulseScale: CGFloat = 1.0
    @State private var bloodFlowOffset: CGSize = .zero
    @State private var arterialPulse: CGFloat = 1.0
    @State private var venousFlow: Double = 0
    @State private var oxygenationLevel: Double = 0.8
    @State private var heartbeatIntensity: Double = 1.0
    
    // Animation timing
    @State private var animationTimer: Timer?
    
    private let heartSize: CGFloat = 180
    
    var body: some View {
        ZStack {
            // Background cardiovascular system
            cardiovascularBackground
            
            // Blood vessels network
            bloodVesselNetwork
            
            // Oxygen particles
            oxygenParticleSystem
            
            // Main 3D heart
            main3DHeartView
            
            // Blood flow indicators
            bloodFlowIndicators
            
            // Phase instruction overlay
            phaseInstructionOverlay
        }
        .frame(width: heartSize * 2.5, height: heartSize * 2.5)
        .onChange(of: phase) { _, newPhase in
            animateForPhase(newPhase)
        }
        .onAppear {
            startContinuousAnimations()
        }
        .onDisappear {
            stopAnimations()
        }
    }
    
    // MARK: - View Components
    
    private var cardiovascularBackground: some View {
        ZStack {
            // Subtle pulmonary visualization
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.blue.opacity(0.1 * oxygenationLevel),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: heartSize * 1.5
                    )
                )
                .scaleEffect(1.2 + (heartbeatIntensity * 0.3))
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: heartbeatIntensity)
        }
    }
    
    private var bloodVesselNetwork: some View {
        ZStack {
            // Major arteries (red - oxygenated blood)
            ForEach(0..<6, id: \.self) { index in
                Path { path in
                    let angle = Double(index) * 60.0
                    let startRadius = heartSize * 0.6
                    let endRadius = heartSize * 1.3
                    
                    let startX = cos(angle * .pi / 180) * startRadius
                    let startY = sin(angle * .pi / 180) * startRadius
                    let endX = cos(angle * .pi / 180) * endRadius
                    let endY = sin(angle * .pi / 180) * endRadius
                    
                    path.move(to: CGPoint(x: startX, y: startY))
                    path.addLine(to: CGPoint(x: endX, y: endY))
                }
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.red.opacity(0.8 * oxygenationLevel),
                            Color.red.opacity(0.2)
                        ],
                        startPoint: .center,
                        endPoint: .leading
                    ),
                    style: StrokeStyle(
                        lineWidth: 4 * arterialPulse,
                        lineCap: .round
                    )
                )
                .scaleEffect(arterialPulse)
            }
            
            // Venous return system (blue - deoxygenated blood)
            ForEach(0..<6, id: \.self) { index in
                Path { path in
                    let angle = Double(index) * 60.0 + 30.0 // Offset from arteries
                    let startRadius = heartSize * 1.2
                    let endRadius = heartSize * 0.7
                    
                    let startX = cos(angle * .pi / 180) * startRadius
                    let startY = sin(angle * .pi / 180) * startRadius
                    let endX = cos(angle * .pi / 180) * endRadius
                    let endY = sin(angle * .pi / 180) * endRadius
                    
                    path.move(to: CGPoint(x: startX, y: startY))
                    path.addCurve(
                        to: CGPoint(x: endX, y: endY),
                        control1: CGPoint(x: startX * 0.7, y: startY * 0.7),
                        control2: CGPoint(x: endX * 1.3, y: endY * 1.3)
                    )
                }
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.4),
                            Color.blue.opacity(0.8 * (1.0 - oxygenationLevel))
                        ],
                        startPoint: .leading,
                        endPoint: .center
                    ),
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round
                    )
                )
                .scaleEffect(0.9)
            }
        }
        .rotationEffect(.degrees(venousFlow))
    }
    
    private var oxygenParticleSystem: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { index in
                OxygenParticle(
                    index: index,
                    phase: phase,
                    heartSize: heartSize,
                    oxygenationLevel: oxygenationLevel
                )
            }
        }
    }
    
    private var main3DHeartView: some View {
        ZStack {
            // Heart shadow for 3D effect
            HeartShape()
                .fill(Color.black.opacity(0.2))
                .frame(width: heartSize, height: heartSize)
                .scaleEffect(heartScale * 0.95)
                .offset(x: 3, y: 3)
                .blur(radius: 2)
            
            // Main heart body
            HeartShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.red.opacity(0.9),
                            Color.red.opacity(0.7),
                            Color.pink.opacity(0.8),
                            Color.red
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: heartSize, height: heartSize)
                .scaleEffect(heartScale)
                .rotation3DEffect(
                    .degrees(heartRotation),
                    axis: (x: 0.3, y: 1.0, z: 0.1)
                )
            
            // Heart highlight for 3D depth
            HeartShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
                .frame(width: heartSize * 0.8, height: heartSize * 0.8)
                .scaleEffect(heartScale)
                .rotation3DEffect(
                    .degrees(heartRotation),
                    axis: (x: 0.3, y: 1.0, z: 0.1)
                )
            
            // Cardiovascular chambers
            heartChambersView
            
            // Heartbeat pulse overlay
            heartbeatPulseView
        }
    }
    
    private var heartChambersView: some View {
        ZStack {
            // Left ventricle
            Circle()
                .fill(Color.red.opacity(0.6))
                .frame(width: heartSize * 0.3, height: heartSize * 0.3)
                .offset(x: -heartSize * 0.15, y: heartSize * 0.1)
                .scaleEffect(heartScale * (0.8 + bloodPulseScale * 0.2))
            
            // Right ventricle
            Circle()
                .fill(Color.blue.opacity(0.6))
                .frame(width: heartSize * 0.25, height: heartSize * 0.25)
                .offset(x: heartSize * 0.15, y: heartSize * 0.1)
                .scaleEffect(heartScale * (0.8 + bloodPulseScale * 0.2))
            
            // Atria
            Circle()
                .fill(Color.purple.opacity(0.4))
                .frame(width: heartSize * 0.2, height: heartSize * 0.2)
                .offset(x: 0, y: -heartSize * 0.2)
                .scaleEffect(heartScale)
        }
        .rotation3DEffect(
            .degrees(heartRotation),
            axis: (x: 0.3, y: 1.0, z: 0.1)
        )
    }
    
    private var heartbeatPulseView: some View {
        ZStack {
            // Systolic pulse ring
            Circle()
                .stroke(
                    Color.red.opacity(0.6),
                    lineWidth: 3
                )
                .frame(width: heartSize * 1.2, height: heartSize * 1.2)
                .scaleEffect(bloodPulseScale)
                .opacity(2.0 - bloodPulseScale)
            
            // Diastolic recovery ring
            Circle()
                .stroke(
                    Color.pink.opacity(0.3),
                    lineWidth: 2
                )
                .frame(width: heartSize * 0.9, height: heartSize * 0.9)
                .scaleEffect(2.0 - bloodPulseScale)
                .opacity(bloodPulseScale - 0.5)
        }
    }
    
    private var bloodFlowIndicators: some View {
        ZStack {
            // Blood ejection during systole
            ForEach(0..<8, id: \.self) { index in
                BloodDroplet(
                    index: index,
                    phase: phase,
                    heartSize: heartSize,
                    bloodFlowOffset: bloodFlowOffset,
                    oxygenationLevel: oxygenationLevel
                )
            }
        }
    }
    
    private var phaseInstructionOverlay: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            Text(cardiovascularPhaseText)
                .font(DesignTokens.Typography.title3)
                .fontWeight(.semibold)
                .foregroundColor(colorScheme.primaryColor)
                .multilineTextAlignment(.center)
            
            Text(cardiovascularInstruction)
                .font(DesignTokens.Typography.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, heartSize)
    }
    
    // MARK: - Computed Properties
    
    private var cardiovascularPhaseText: String {
        switch phase {
        case .inhale:
            return "Oxygenating Blood"
        case .hold:
            return "Gas Exchange"
        case .exhale:
            return "Circulating Oxygen"
        case .pause:
            return "Venous Return"
        case .ready:
            return "Heart Ready"
        case .completed:
            return "Circulation Complete"
        }
    }
    
    private var cardiovascularInstruction: String {
        switch phase {
        case .inhale:
            return "Blood picks up fresh oxygen"
        case .hold:
            return "Oxygen enters bloodstream"
        case .exhale:
            return "Heart pumps oxygenated blood"
        case .pause:
            return "Deoxygenated blood returns"
        case .ready:
            return "Preparing cardiovascular system"
        case .completed:
            return "Optimal circulation achieved"
        }
    }
    
    // MARK: - Animation Methods
    
    private func animateForPhase(_ newPhase: BreathingPhase) {
        switch newPhase {
        case .inhale:
            // Diastole - heart fills with blood
            withAnimation(.easeInOut(duration: pattern.defaultTiming.inhale)) {
                heartScale = 1.2
                bloodPulseScale = 1.4
                arterialPulse = 1.2
                oxygenationLevel = 0.9
                heartbeatIntensity = 1.3
                bloodFlowOffset = CGSize(width: 20, height: -20)
            }
            
        case .hold:
            // Isovolumetric contraction - preparing to pump
            withAnimation(.easeInOut(duration: pattern.defaultTiming.hold)) {
                heartScale = 1.3
                bloodPulseScale = 1.1
                arterialPulse = 1.4
                oxygenationLevel = 1.0
                heartbeatIntensity = 1.5
            }
            
        case .exhale:
            // Systole - heart pumps blood out
            withAnimation(.easeInOut(duration: pattern.defaultTiming.exhale)) {
                heartScale = 0.9
                bloodPulseScale = 1.8
                arterialPulse = 1.6
                oxygenationLevel = 0.7
                heartbeatIntensity = 1.1
                bloodFlowOffset = CGSize(width: -30, height: 30)
            }
            
        case .pause:
            // Diastolic relaxation
            withAnimation(.easeInOut(duration: pattern.defaultTiming.pause)) {
                heartScale = 1.0
                bloodPulseScale = 1.0
                arterialPulse = 1.0
                oxygenationLevel = 0.8
                heartbeatIntensity = 1.0
                bloodFlowOffset = .zero
            }
            
        case .ready:
            withAnimation(.easeInOut(duration: 1.0)) {
                heartScale = 1.0
                bloodPulseScale = 1.0
                arterialPulse = 1.0
                oxygenationLevel = 0.8
                heartbeatIntensity = 1.0
            }
            
        case .completed:
            withAnimation(.spring(response: 1.5, dampingFraction: 0.6)) {
                heartScale = 1.4
                bloodPulseScale = 1.3
                arterialPulse = 1.2
                oxygenationLevel = 1.0
                heartbeatIntensity = 1.6
            }
        }
    }
    
    private func startContinuousAnimations() {
        // Subtle heart rotation for 3D effect
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            heartRotation = 360
        }
        
        // Venous blood flow
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            venousFlow = 360
        }
        
        // Continuous heartbeat rhythm
        startHeartbeatRhythm()
    }
    
    private func startHeartbeatRhythm() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { _ in
            // Natural heartbeat rhythm
            withAnimation(.easeInOut(duration: 0.3)) {
                bloodPulseScale = 1.4
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.9)) {
                    bloodPulseScale = 1.0
                }
            }
        }
    }
    
    private func stopAnimations() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

// MARK: - Supporting Views

/// Custom heart shape for realistic cardiac silhouette
struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Start at the bottom point
        path.move(to: CGPoint(x: width / 2, y: height))
        
        // Left curve (left ventricle outline)
        path.addCurve(
            to: CGPoint(x: 0, y: height * 0.3),
            control1: CGPoint(x: width / 2, y: height * 0.8),
            control2: CGPoint(x: 0, y: height * 0.6)
        )
        
        // Left atrium
        path.addCurve(
            to: CGPoint(x: width * 0.25, y: 0),
            control1: CGPoint(x: 0, y: height * 0.1),
            control2: CGPoint(x: width * 0.1, y: 0)
        )
        
        // Top left curve
        path.addCurve(
            to: CGPoint(x: width / 2, y: height * 0.3),
            control1: CGPoint(x: width * 0.4, y: 0),
            control2: CGPoint(x: width / 2, y: height * 0.1)
        )
        
        // Top right curve
        path.addCurve(
            to: CGPoint(x: width * 0.75, y: 0),
            control1: CGPoint(x: width / 2, y: height * 0.1),
            control2: CGPoint(x: width * 0.6, y: 0)
        )
        
        // Right atrium
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.3),
            control1: CGPoint(x: width * 0.9, y: 0),
            control2: CGPoint(x: width, y: height * 0.1)
        )
        
        // Right curve (right ventricle outline)
        path.addCurve(
            to: CGPoint(x: width / 2, y: height),
            control1: CGPoint(x: width, y: height * 0.6),
            control2: CGPoint(x: width / 2, y: height * 0.8)
        )
        
        return path
    }
}

/// Individual oxygen particle that flows through the cardiovascular system
struct OxygenParticle: View {
    let index: Int
    let phase: BreathingPhase
    let heartSize: CGFloat
    let oxygenationLevel: Double
    
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color.cyan.opacity(0.8),
                        Color.blue.opacity(0.6)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 3
                )
            )
            .frame(width: 6, height: 6)
            .scaleEffect(scale)
            .offset(offset)
            .opacity(opacity * oxygenationLevel)
            .onChange(of: phase) { _, newPhase in
                animateForPhase(newPhase)
            }
            .onAppear {
                startParticleFlow()
            }
    }
    
    private func animateForPhase(_ newPhase: BreathingPhase) {
        let baseDelay = Double(index) * 0.1
        
        switch newPhase {
        case .inhale:
            withAnimation(.easeInOut(duration: 2.0).delay(baseDelay)) {
                offset = CGSize(
                    width: cos(Double(index) * 0.785) * heartSize * 0.8,
                    height: sin(Double(index) * 0.785) * heartSize * 0.8
                )
                opacity = 0.9
                scale = 1.0
            }
            
        case .exhale:
            withAnimation(.easeInOut(duration: 2.0).delay(baseDelay)) {
                offset = CGSize(
                    width: cos(Double(index) * 0.785) * heartSize * 1.5,
                    height: sin(Double(index) * 0.785) * heartSize * 1.5
                )
                opacity = 0.6
                scale = 0.7
            }
            
        default:
            withAnimation(.easeInOut(duration: 1.0).delay(baseDelay)) {
                offset = CGSize(
                    width: cos(Double(index) * 0.785) * heartSize * 0.6,
                    height: sin(Double(index) * 0.785) * heartSize * 0.6
                )
                opacity = 0.7
                scale = 0.8
            }
        }
    }
    
    private func startParticleFlow() {
        // Continuous orbital motion
        withAnimation(.linear(duration: 4.0 + Double(index) * 0.3).repeatForever(autoreverses: false)) {
            offset = CGSize(
                width: cos(Double(index) * 2.0) * heartSize * 0.4,
                height: sin(Double(index) * 2.0) * heartSize * 0.4
            )
        }
        
        withAnimation(.easeInOut(duration: 1.5).delay(Double(index) * 0.1)) {
            opacity = 0.6
            scale = 0.8
        }
    }
}

/// Blood droplet that represents circulation during heartbeat
struct BloodDroplet: View {
    let index: Int
    let phase: BreathingPhase
    let heartSize: CGFloat
    let bloodFlowOffset: CGSize
    let oxygenationLevel: Double
    
    @State private var position: CGSize = .zero
    @State private var opacity: Double = 0.0
    @State private var dropletScale: CGFloat = 0.3
    
    var body: some View {
        Ellipse()
            .fill(
                LinearGradient(
                    colors: [
                        Color.red.opacity(0.8 * oxygenationLevel),
                        Color.darkRed.opacity(0.9)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 8, height: 12)
            .scaleEffect(dropletScale)
            .offset(position)
            .opacity(opacity)
            .onChange(of: phase) { _, newPhase in
                animateBloodFlow(for: newPhase)
            }
            .onChange(of: bloodFlowOffset) { _, newOffset in
                updateFlowPosition(offset: newOffset)
            }
    }
    
    private func animateBloodFlow(for newPhase: BreathingPhase) {
        let angle = Double(index) * 45.0
        let baseDelay = Double(index) * 0.05
        
        switch newPhase {
        case .inhale:
            withAnimation(.easeOut(duration: 1.5).delay(baseDelay)) {
                position = CGSize(
                    width: cos(angle * .pi / 180) * heartSize * 0.3,
                    height: sin(angle * .pi / 180) * heartSize * 0.3
                )
                opacity = 0.4
                dropletScale = 0.6
            }
            
        case .exhale:
            withAnimation(.easeIn(duration: 1.5).delay(baseDelay)) {
                position = CGSize(
                    width: cos(angle * .pi / 180) * heartSize * 1.1,
                    height: sin(angle * .pi / 180) * heartSize * 1.1
                )
                opacity = 0.8
                dropletScale = 1.0
            }
            
        default:
            withAnimation(.easeInOut(duration: 1.0).delay(baseDelay)) {
                position = CGSize(
                    width: cos(angle * .pi / 180) * heartSize * 0.5,
                    height: sin(angle * .pi / 180) * heartSize * 0.5
                )
                opacity = 0.6
                dropletScale = 0.7
            }
        }
    }
    
    private func updateFlowPosition(offset: CGSize) {
        withAnimation(.easeInOut(duration: 0.3)) {
            position.width += offset.width * 0.1
            position.height += offset.height * 0.1
        }
    }
}

// MARK: - Color Extensions

extension Color {
    static let darkRed = Color(red: 0.6, green: 0.1, blue: 0.1)
}

// MARK: - Preview

#Preview {
    VStack {
        AnimatedHeartView(
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
