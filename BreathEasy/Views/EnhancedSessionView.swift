//
//  EnhancedSessionView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct EnhancedSessionView: View {
    let pattern: BreathingPattern
    @Environment(\.dismiss) private var dismiss
    @State private var sessionViewModel = SessionViewModel()
    @State private var enhancedColorScheme = EnhancedColorScheme.shared
    @State private var showingComplete = false
    @State private var use3DHeartAnimation = false
    @State private var showingViewSelector = false
    
    var body: some View {
        ZStack {
            // Background gradient
            enhancedColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: DesignTokens.Spacing.xxl) {
                // Header with close button and session info
                headerSection
                
                Spacer()
                
                // Main breathing visualization - with animation toggle
                breathingVisualizationSection
                
                Spacer()
                
                // Session controls and info
                controlsSection
                
                // Progress indicator
                progressSection
            }
            .padding(DesignTokens.Spacing.lg)
        }
        .onAppear {
            sessionViewModel.configureSession(pattern: pattern)
            sessionViewModel.startSession()
        }
        .onChange(of: sessionViewModel.isSessionActive) { _, isActive in
            if !isActive && sessionViewModel.currentCycle > 0 {
                showingComplete = true
            }
        }
        .sheet(isPresented: $showingComplete) {
            // Use existing SessionCompleteView from project
            SessionCompleteView(
                pattern: pattern,
                duration: sessionViewModel.elapsedTime,
                cyclesCompleted: sessionViewModel.currentCycle,
                moodBefore: nil,
                moodAfter: nil
            ) {
                dismiss()
            }
        }
        .sheet(isPresented: $showingViewSelector) {
            visualizationSelectorSheet
        }
    }
    
    // MARK: - Helper Functions
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // MARK: - View Components
    
    private var breathingVisualizationSection: some View {
        ZStack {
            if use3DHeartAnimation {
                AnimatedHeartView(
                    phase: sessionViewModel.currentPhase,
                    pattern: pattern,
                    progress: sessionViewModel.phaseProgress,
                    colorScheme: enhancedColorScheme
                )
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))
            } else {
                EnhancedBreathingOrbView(
                    phase: sessionViewModel.currentPhase,
                    pattern: pattern,
                    progress: sessionViewModel.phaseProgress,
                    colorScheme: enhancedColorScheme
                )
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))
            }
        }
        .animation(.spring(response: 0.8, dampingFraction: 0.7), value: use3DHeartAnimation)
    }
    
    private var visualizationSelectorSheet: some View {
        NavigationView {
            VStack(spacing: DesignTokens.Spacing.xl) {
                Text("Choose Your Breathing Guide")
                    .font(DesignTokens.Typography.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                Text("Select the visualization that helps you focus best during your breathing session.")
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: DesignTokens.Spacing.lg) {
                    // Traditional Orb Option
                    VisualizationOption(
                        title: "Breathing Orb",
                        description: "Classic meditation orb with gentle animations",
                        icon: "circle.fill",
                        isSelected: !use3DHeartAnimation,
                        accentColor: enhancedColorScheme.primaryColor
                    ) {
                        withAnimation(.spring()) {
                            use3DHeartAnimation = false
                        }
                    }
                    
                    // 3D Heart Option
                    VisualizationOption(
                        title: "3D Animated Heart",
                        description: "Cardiovascular system with blood flow visualization",
                        icon: "heart.fill",
                        isSelected: use3DHeartAnimation,
                        accentColor: .red
                    ) {
                        withAnimation(.spring()) {
                            use3DHeartAnimation = true
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Visualization")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingViewSelector = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private var headerSection: some View {
        HStack {
            // Close button
            Button {
                sessionViewModel.stopSession()
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(enhancedColorScheme.primaryColor)
                    .background(Color(.systemBackground))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            // Session info
            VStack(spacing: DesignTokens.Spacing.xs) {
                Text(pattern.name)
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Label("\(sessionViewModel.currentCycle)", systemImage: "repeat.circle.fill")
                    
                    Label(timeString(from: sessionViewModel.elapsedTime), systemImage: "clock.fill")
                }
                .font(DesignTokens.Typography.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Settings/View selector button
            Button {
                showingViewSelector = true
            } label: {
                Image(systemName: use3DHeartAnimation ? "heart.fill" : "circle.fill")
                    .font(.title2)
                    .foregroundColor(enhancedColorScheme.primaryColor)
            }
        }
    }
    
    private var controlsSection: some View {
        HStack(spacing: DesignTokens.Spacing.xl) {
            // Pause/Resume button
            Button {
                if sessionViewModel.isPaused {
                    sessionViewModel.resumeSession()
                } else {
                    sessionViewModel.pauseSession()
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(enhancedColorScheme.primaryColor.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: sessionViewModel.isPaused ? "play.fill" : "pause.fill")
                        .font(.title2)
                        .foregroundColor(enhancedColorScheme.primaryColor)
                }
            }
            
            // Stop button
            Button {
                sessionViewModel.stopSession()
                dismiss()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "stop.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private var progressSection: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            // Cycle progress
            VStack(spacing: DesignTokens.Spacing.sm) {
                HStack {
                    Text("Cycle Progress")
                        .font(DesignTokens.Typography.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(sessionViewModel.currentCycle + 1) of \(sessionViewModel.totalCycles)")
                        .font(DesignTokens.Typography.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(enhancedColorScheme.primaryColor)
                }
                
                ModernProgressView(
                    progress: sessionViewModel.sessionProgress,
                    color: enhancedColorScheme.primaryColor
                )
                .frame(height: 8)
            }
            
            // Phase breakdown
            PhaseBreakdownView(
                pattern: pattern,
                currentPhase: sessionViewModel.currentPhase,
                colorScheme: enhancedColorScheme
            )
        }
        .padding(DesignTokens.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.lg)
                .fill(enhancedColorScheme.cardBackgroundColor.opacity(0.8))
        )
        .background(.ultraThinMaterial)
    }
}

// MARK: - Supporting Views

struct PhaseBreakdownView: View {
    let pattern: BreathingPattern
    let currentPhase: BreathingPhase
    let colorScheme: EnhancedColorScheme
    
    var body: some View {
        HStack {
            PhaseIndicator(
                title: "Inhale",
                duration: pattern.inhaleCount,
                isActive: currentPhase == .inhale,
                color: .blue
            )
            
            Image(systemName: "arrow.right")
                .font(.caption)
                .foregroundColor(.secondary)
            
            PhaseIndicator(
                title: "Hold",
                duration: pattern.holdCount,
                isActive: currentPhase == .hold,
                color: .green
            )
            
            Image(systemName: "arrow.right")
                .font(.caption)
                .foregroundColor(.secondary)
            
            PhaseIndicator(
                title: "Exhale",
                duration: pattern.exhaleCount,
                isActive: currentPhase == .exhale,
                color: .orange
            )
            
            if pattern.pauseCount > 0 {
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                PhaseIndicator(
                    title: "Pause",
                    duration: pattern.pauseCount,
                    isActive: currentPhase == .pause,
                    color: .purple
                )
            }
        }
    }
}

// MARK: - Supporting Views

struct VisualizationOption: View {
    let title: String
    let description: String
    let icon: String
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(isSelected ? 1.0 : 0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(isSelected ? .white : accentColor)
                }
                
                // Content
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(title)
                        .font(DesignTokens.Typography.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(DesignTokens.Typography.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? accentColor : .secondary)
            }
            .padding(DesignTokens.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.lg)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.lg)
                            .stroke(
                                isSelected ? accentColor : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

struct PhaseIndicator: View {
    let title: String
    let duration: Int
    let isActive: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            ZStack {
                Circle()
                    .fill(isActive ? color : color.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Text("\(duration)")
                    .font(DesignTokens.Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(isActive ? .white : color)
            }
            
            Text(title)
                .font(DesignTokens.Typography.caption2)
                .foregroundColor(isActive ? color : .secondary)
        }
        .scaleEffect(isActive ? 1.1 : 1.0)
        .animation(DesignTokens.Animation.spring, value: isActive)
    }
}

// MARK: - Preview

#Preview {
    EnhancedSessionView(
        pattern: .fourSevenEight
    )
}
