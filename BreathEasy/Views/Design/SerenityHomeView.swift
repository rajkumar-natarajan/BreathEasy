//
//  SerenityHomeView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Main home screen with zen-inspired interface and breathing pattern carousel
struct SerenityHomeView: View {
    @Environment(DataManager.self) private var dataManager
    @State private var selectedPatternIndex = 0
    @State private var showingSession = false
    @State private var showingMoodSelector = false
    @State private var selectedMoodBefore: MoodLevel?
    @State private var sessionViewModel = SessionViewModel()
    @State private var streakProgress: Double = 0.75
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SerenityDesignSystem.Spacing.zen) {
                    // Hero gradient banner with pattern carousel
                    heroSection(screenSize: geometry.size)
                    
                    // Main start session CTA
                    startSessionSection
                    
                    // Streak and mood section
                    statusSection
                    
                    // Quick stats overview
                    quickStatsSection
                }
                .padding(.horizontal, SerenityDesignSystem.Spacing.lg)
                .padding(.bottom, SerenityDesignSystem.Spacing.xxxl)
            }
            .background(
                ZStack {
                    SerenityDesignSystem.Colors.warmOffWhite
                        .ignoresSafeArea()
                    
                    FloatingParticles(screenSize: geometry.size)
                        .opacity(0.3)
                }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(SerenityDesignSystem.Colors.sageGreen)
                    Text("BreatheEasy")
                        .font(SerenityDesignSystem.Typography.title2)
                        .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                }
            }
        }
        .sheet(isPresented: $showingSession) {
            if let pattern = selectedBreathingPattern {
                EnhancedSessionView(
                    pattern: pattern
                )
            }
        }
        .sheet(isPresented: $showingMoodSelector) {
            MoodSelectionView(
                selectedMood: $selectedMoodBefore,
                onSelection: {
                    showingMoodSelector = false
                    showingSession = true
                }
            )
            .presentationDetents([.medium])
        }
        .onAppear {
            updateStreakProgress()
        }
    }
    
    // MARK: - Hero Section
    
    @ViewBuilder
    private func heroSection(screenSize: CGSize) -> some View {
        VStack(spacing: SerenityDesignSystem.Spacing.xl) {
            // Welcome message
            VStack(spacing: SerenityDesignSystem.Spacing.sm) {
                Text("Welcome back")
                    .font(SerenityDesignSystem.Typography.title3)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
                
                Text("Ready to find your calm?")
                    .font(SerenityDesignSystem.Typography.largeTitle)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                    .multilineTextAlignment(.center)
            }
            
            // Pattern carousel
            BreathingPatternCarousel(
                patterns: availablePatterns,
                selectedIndex: $selectedPatternIndex
            )
        }
        .padding(.top, SerenityDesignSystem.Spacing.xl)
    }
    
    // MARK: - Start Session Section
    
    @ViewBuilder
    private var startSessionSection: some View {
        VStack(spacing: SerenityDesignSystem.Spacing.lg) {
            // Breathing orb preview
            BreathingOrb(
                size: 120,
                isAnimating: true,
                breathPhase: .inhale
            )
            .animation(
                .easeInOut(duration: 4.0)
                .repeatForever(autoreverses: true),
                value: true
            )
            
            // Start session button with pulse effect
            SerenityButton(
                title: "Start Session",
                action: {
                    showingMoodSelector = true
                },
                style: .primary,
                size: .extraLarge
            )
            .shadow(
                color: SerenityDesignSystem.Colors.sageGreen.opacity(0.3),
                radius: 20,
                x: 0,
                y: 10
            )
            .animation(
                .easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true),
                value: true
            )
        }
        .padding(.vertical, SerenityDesignSystem.Spacing.xl)
    }
    
    // MARK: - Status Section
    
    @ViewBuilder
    private var statusSection: some View {
        HStack(spacing: SerenityDesignSystem.Spacing.xl) {
            // Streak ring
            VStack(spacing: SerenityDesignSystem.Spacing.sm) {
                ZStack {
                    ProgressRing(
                        progress: streakProgress,
                        lineWidth: 6,
                        size: 80,
                        color: SerenityDesignSystem.Colors.oceanTeal
                    )
                    
                    VStack(spacing: 2) {
                        Text("\(Int(streakProgress * 7))")
                            .font(SerenityDesignSystem.Typography.title2)
                            .foregroundColor(SerenityDesignSystem.Colors.oceanTeal)
                        
                        Text("day streak")
                            .font(SerenityDesignSystem.Typography.caption)
                            .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.6))
                    }
                }
                
                Text("Keep it up!")
                    .font(SerenityDesignSystem.Typography.callout)
                    .foregroundColor(SerenityDesignSystem.Colors.oceanTeal)
            }
            
            Spacer()
            
            // Today's mood
            VStack(spacing: SerenityDesignSystem.Spacing.sm) {
                Text("How are you feeling?")
                    .font(SerenityDesignSystem.Typography.callout)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
                
                Button(action: {
                    showingMoodSelector = true
                }) {
                    HStack(spacing: SerenityDesignSystem.Spacing.sm) {
                        Text(selectedMoodBefore?.emoji ?? "😐")
                            .font(.title2)
                        
                        Text(selectedMoodBefore?.description ?? "Select mood")
                            .font(SerenityDesignSystem.Typography.callout)
                            .foregroundColor(SerenityDesignSystem.Colors.softSkyBlue)
                    }
                    .padding(.horizontal, SerenityDesignSystem.Spacing.md)
                    .padding(.vertical, SerenityDesignSystem.Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: SerenityDesignSystem.CornerRadius.medium)
                            .fill(SerenityDesignSystem.Colors.softSkyBlue.opacity(0.1))
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, SerenityDesignSystem.Spacing.md)
    }
    
    // MARK: - Quick Stats Section
    
    @ViewBuilder
    private var quickStatsSection: some View {
        SerenityCard {
            VStack(spacing: SerenityDesignSystem.Spacing.lg) {
                HStack {
                    Text("Your Progress")
                        .font(SerenityDesignSystem.Typography.title3)
                        .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                    
                    Spacer()
                    
                    Button("View All") {
                        // Navigate to history
                    }
                    .font(SerenityDesignSystem.Typography.callout)
                    .foregroundColor(SerenityDesignSystem.Colors.softSkyBlue)
                }
                
                HStack(spacing: SerenityDesignSystem.Spacing.xl) {
                    StatItem(
                        icon: "timer",
                        value: "24",
                        unit: "min",
                        label: "This week",
                        color: SerenityDesignSystem.Colors.sageGreen
                    )
                    
                    StatItem(
                        icon: "heart.fill",
                        value: "12",
                        unit: "sessions",
                        label: "Total",
                        color: SerenityDesignSystem.Colors.oceanTeal
                    )
                    
                    StatItem(
                        icon: "chart.line.uptrend.xyaxis",
                        value: "+15%",
                        unit: "calm",
                        label: "Improvement",
                        color: SerenityDesignSystem.Colors.lavenderMist
                    )
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var availablePatterns: [BreathingPatternStruct] {
        dataManager.breathingPatterns.prefix(4).map { $0 }
    }
    
    private var selectedBreathingPattern: BreathingPattern? {
        guard selectedPatternIndex < availablePatterns.count else { return nil }
        return availablePatterns[selectedPatternIndex].toBreathingPattern()
    }
    
    private func updateStreakProgress() {
        // Calculate actual streak progress based on data
        let sessions = dataManager.recentSessions
        // Simplified calculation for demo
        streakProgress = min(Double(sessions.count) / 7.0, 1.0)
    }
}

// MARK: - Supporting Views

/// Horizontal carousel for breathing patterns
struct BreathingPatternCarousel: View {
    let patterns: [BreathingPatternStruct]
    @Binding var selectedIndex: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SerenityDesignSystem.Spacing.lg) {
                ForEach(Array(patterns.enumerated()), id: \.offset) { index, pattern in
                    PatternCarouselCard(
                        pattern: pattern,
                        isSelected: index == selectedIndex
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            selectedIndex = index
                        }
                    }
                }
            }
            .padding(.horizontal, SerenityDesignSystem.Spacing.lg)
        }
    }
}

/// Individual pattern card in carousel
struct PatternCarouselCard: View {
    let pattern: BreathingPatternStruct
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: SerenityDesignSystem.Spacing.md) {
            // Mini breathing orb
            BreathingOrb(
                size: isSelected ? 60 : 50,
                isAnimating: isSelected,
                breathPhase: .inhale
            )
            
            VStack(spacing: SerenityDesignSystem.Spacing.xs) {
                Text(pattern.name)
                    .font(isSelected ? SerenityDesignSystem.Typography.callout : SerenityDesignSystem.Typography.footnote)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                    .fontWeight(isSelected ? .medium : .regular)
                
                Text(pattern.description)
                    .font(SerenityDesignSystem.Typography.caption)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(width: 140, height: 160)
        .padding(SerenityDesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: SerenityDesignSystem.CornerRadius.large)
                .fill(
                    isSelected
                    ? SerenityDesignSystem.Colors.softSkyBlue.opacity(0.1)
                    : SerenityDesignSystem.Colors.crystalWhite
                )
                .overlay(
                    RoundedRectangle(cornerRadius: SerenityDesignSystem.CornerRadius.large)
                        .stroke(
                            isSelected
                            ? SerenityDesignSystem.Colors.softSkyBlue.opacity(0.3)
                            : Color.clear,
                            lineWidth: 2
                        )
                )
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

/// Individual stat item
struct StatItem: View {
    let icon: String
    let value: String
    let unit: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: SerenityDesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(value)
                        .font(SerenityDesignSystem.Typography.title3)
                        .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                    
                    Text(unit)
                        .font(SerenityDesignSystem.Typography.caption)
                        .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.6))
                }
                
                Text(label)
                    .font(SerenityDesignSystem.Typography.caption)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

/// Mood selection sheet
struct MoodSelectionView: View {
    @Binding var selectedMood: MoodLevel?
    let onSelection: () -> Void
    
    var body: some View {
        VStack(spacing: SerenityDesignSystem.Spacing.xl) {
            VStack(spacing: SerenityDesignSystem.Spacing.md) {
                Text("How are you feeling?")
                    .font(SerenityDesignSystem.Typography.title2)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                
                Text("Select your current mood to personalize your session")
                    .font(SerenityDesignSystem.Typography.body)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            MoodSelector(selectedMood: $selectedMood)
            
            if selectedMood != nil {
                SerenityButton(
                    title: "Continue to Session",
                    action: onSelection,
                    style: .primary,
                    size: .large
                )
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedMood)
            }
            
            Spacer()
        }
        .padding(SerenityDesignSystem.Spacing.xl)
        .background(SerenityDesignSystem.Colors.warmOffWhite)
    }
}

#Preview("Serenity Home") {
    NavigationView {
        SerenityHomeView()
            .environment(DataManager.shared)
    }
}
