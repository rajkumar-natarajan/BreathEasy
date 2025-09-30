//
//  SerenityContentView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Main content view with zen-inspired tab navigation
struct SerenityContentView: View {
    @Environment(DataManager.self) private var dataManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home tab
            NavigationView {
                SerenityHomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)
            
            // History tab
            NavigationView {
                SerenityHistoryView()
            }
            .tabItem {
                Label("History", systemImage: "chart.line.uptrend.xyaxis")
            }
            .tag(1)
            
            // Patterns tab
            NavigationView {
                SerenityPatternsView()
            }
            .tabItem {
                Label("Patterns", systemImage: "waveform.path.ecg")
            }
            .tag(2)
            
            // Settings tab
            NavigationView {
                SerenitySettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
            .tag(3)
        }
        .accentColor(SerenityDesignSystem.Colors.softSkyBlue)
        .background(SerenityDesignSystem.Colors.warmOffWhite)
    }
}

// MARK: - Tab Views

/// History view with session analytics
struct SerenityHistoryView: View {
    @Environment(DataManager.self) private var dataManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: SerenityDesignSystem.Spacing.xl) {
                // Weekly overview card
                SerenityCard {
                    VStack(spacing: SerenityDesignSystem.Spacing.lg) {
                        HStack {
                            Text("This Week")
                                .font(SerenityDesignSystem.Typography.title3)
                                .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                            
                            Spacer()
                            
                            Text("5 sessions")
                                .font(SerenityDesignSystem.Typography.callout)
                                .foregroundColor(SerenityDesignSystem.Colors.oceanTeal)
                        }
                        
                        HStack(spacing: SerenityDesignSystem.Spacing.xl) {
                            StatItem(
                                icon: "timer",
                                value: "24",
                                unit: "min",
                                label: "Total time",
                                color: SerenityDesignSystem.Colors.sageGreen
                            )
                            
                            StatItem(
                                icon: "heart.fill",
                                value: "4.8",
                                unit: "rating",
                                label: "Avg. mood",
                                color: SerenityDesignSystem.Colors.oceanTeal
                            )
                            
                            StatItem(
                                icon: "flame.fill",
                                value: "7",
                                unit: "days",
                                label: "Streak",
                                color: SerenityDesignSystem.Colors.lavenderMist
                            )
                        }
                    }
                }
                
                // Recent sessions
                VStack(spacing: SerenityDesignSystem.Spacing.lg) {
                    HStack {
                        Text("Recent Sessions")
                            .font(SerenityDesignSystem.Typography.title3)
                            .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                        
                        Spacer()
                    }
                    
                    LazyVStack(spacing: SerenityDesignSystem.Spacing.md) {
                        ForEach(dataManager.recentSessions.prefix(10)) { session in
                            SessionHistoryCard(session: session)
                        }
                    }
                }
            }
            .padding(SerenityDesignSystem.Spacing.lg)
        }
        .background(SerenityDesignSystem.Colors.warmOffWhite)
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.large)
    }
}

/// Patterns management view
struct SerenityPatternsView: View {
    @Environment(DataManager.self) private var dataManager
    @State private var showingCustomCreator = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: SerenityDesignSystem.Spacing.xl) {
                // Create custom pattern
                SerenityCard {
                    VStack(spacing: SerenityDesignSystem.Spacing.lg) {
                        HStack {
                            VStack(alignment: .leading, spacing: SerenityDesignSystem.Spacing.sm) {
                                Text("Create Custom Pattern")
                                    .font(SerenityDesignSystem.Typography.title3)
                                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                                
                                Text("Design your own breathing rhythm")
                                    .font(SerenityDesignSystem.Typography.body)
                                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            SerenityButton(
                                title: "Create",
                                action: {
                                    showingCustomCreator = true
                                },
                                style: .secondary,
                                size: .medium
                            )
                        }
                    }
                }
                
                // Available patterns
                VStack(spacing: SerenityDesignSystem.Spacing.lg) {
                    HStack {
                        Text("Breathing Patterns")
                            .font(SerenityDesignSystem.Typography.title3)
                            .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                        
                        Spacer()
                    }
                    
                    LazyVStack(spacing: SerenityDesignSystem.Spacing.md) {
                        ForEach(dataManager.breathingPatterns) { pattern in
                            PatternCard(pattern: pattern)
                        }
                    }
                }
            }
            .padding(SerenityDesignSystem.Spacing.lg)
        }
        .background(SerenityDesignSystem.Colors.warmOffWhite)
        .navigationTitle("Patterns")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingCustomCreator) {
            SerenityCustomPatternCreator()
        }
    }
}

/// Settings view with zen aesthetics
struct SerenitySettingsView: View {
    @Environment(DataManager.self) private var dataManager
    @State private var notificationsEnabled = true
    @State private var hapticFeedbackEnabled = true
    @State private var soundsEnabled = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: SerenityDesignSystem.Spacing.xl) {
                // User profile section
                SerenityCard {
                    VStack(spacing: SerenityDesignSystem.Spacing.lg) {
                        HStack {
                            VStack(alignment: .leading, spacing: SerenityDesignSystem.Spacing.sm) {
                                Text("Profile")
                                    .font(SerenityDesignSystem.Typography.title3)
                                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                                
                                Text("Personalize your experience")
                                    .font(SerenityDesignSystem.Typography.body)
                                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Circle()
                                .fill(SerenityDesignSystem.Colors.sageGreen.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text("👤")
                                        .font(.title2)
                                )
                        }
                    }
                }
                
                // App preferences
                SerenityCard {
                    VStack(spacing: SerenityDesignSystem.Spacing.lg) {
                        HStack {
                            Text("Preferences")
                                .font(SerenityDesignSystem.Typography.title3)
                                .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                            
                            Spacer()
                        }
                        
                        VStack(spacing: SerenityDesignSystem.Spacing.md) {
                            SettingsToggleRow(
                                title: "Notifications",
                                description: "Remind me to breathe",
                                isOn: $notificationsEnabled
                            )
                            
                            SettingsToggleRow(
                                title: "Haptic Feedback",
                                description: "Feel the breathing rhythm",
                                isOn: $hapticFeedbackEnabled
                            )
                            
                            SettingsToggleRow(
                                title: "Breathing Sounds",
                                description: "Enhance with audio cues",
                                isOn: $soundsEnabled
                            )
                        }
                    }
                }
                
                // About section
                SerenityCard {
                    VStack(spacing: SerenityDesignSystem.Spacing.lg) {
                        HStack {
                            Text("About")
                                .font(SerenityDesignSystem.Typography.title3)
                                .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                            
                            Spacer()
                        }
                        
                        VStack(spacing: SerenityDesignSystem.Spacing.md) {
                            HStack {
                                Text("Version")
                                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
                                
                                Spacer()
                                
                                Text("1.0.0")
                                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                            }
                            
                            HStack {
                                Text("Made with")
                                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
                                
                                Image(systemName: "heart.fill")
                                    .foregroundColor(SerenityDesignSystem.Colors.oceanTeal)
                                
                                Text("for mindfulness")
                                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
                                
                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding(SerenityDesignSystem.Spacing.lg)
        }
        .background(SerenityDesignSystem.Colors.warmOffWhite)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Supporting Components

/// Session history card
struct SessionHistoryCard: View {
    let session: BreathingSession
    
    var body: some View {
        HStack(spacing: SerenityDesignSystem.Spacing.md) {
            // Date indicator
            VStack(spacing: 4) {
                Text(session.date, format: .dateTime.day())
                    .font(SerenityDesignSystem.Typography.title3)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                
                Text(session.date, format: .dateTime.month(.abbreviated))
                    .font(SerenityDesignSystem.Typography.caption)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
            }
            .frame(width: 50)
            
            VStack(alignment: .leading, spacing: SerenityDesignSystem.Spacing.xs) {
                Text(session.patternName)
                    .font(SerenityDesignSystem.Typography.callout)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                
                HStack(spacing: SerenityDesignSystem.Spacing.sm) {
                    Text("\(Int(session.duration))m")
                        .font(SerenityDesignSystem.Typography.caption)
                        .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
                    
                    if let moodAfter = session.moodAfter {
                        Text("•")
                            .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.3))
                        
                        Text(moodAfter.emoji)
                            .font(SerenityDesignSystem.Typography.caption)
                    }
                }
            }
            
            Spacer()
            
            // Quick rating
            if let moodAfter = session.moodAfter {
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= moodAfter.rawValue ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundColor(
                                star <= moodAfter.rawValue
                                ? SerenityDesignSystem.Colors.oceanTeal
                                : SerenityDesignSystem.Colors.deepCharcoal.opacity(0.3)
                            )
                    }
                }
            }
        }
        .padding(SerenityDesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: SerenityDesignSystem.CornerRadius.medium)
                .fill(SerenityDesignSystem.Colors.crystalWhite)
                .shadow(
                    color: SerenityDesignSystem.Colors.deepCharcoal.opacity(0.05),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
    }
}

/// Pattern display card
struct PatternCard: View {
    let pattern: BreathingPatternStruct
    
    var body: some View {
        HStack(spacing: SerenityDesignSystem.Spacing.md) {
            // Mini breathing orb
            BreathingOrb(
                size: 40,
                isAnimating: false,
                breathPhase: .inhale
            )
            
            VStack(alignment: .leading, spacing: SerenityDesignSystem.Spacing.xs) {
                Text(pattern.name)
                    .font(SerenityDesignSystem.Typography.callout)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                
                Text(pattern.description)
                    .font(SerenityDesignSystem.Typography.caption)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
                    .lineLimit(2)
                
                HStack(spacing: SerenityDesignSystem.Spacing.sm) {
                    Text("\(pattern.inhaleSeconds)s in")
                        .font(SerenityDesignSystem.Typography.caption)
                        .foregroundColor(SerenityDesignSystem.Colors.sageGreen)
                    
                    Text("•")
                        .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.3))
                    
                    Text("\(pattern.exhaleSeconds)s out")
                        .font(SerenityDesignSystem.Typography.caption)
                        .foregroundColor(SerenityDesignSystem.Colors.oceanTeal)
                }
            }
            
            Spacer()
            
            Button(action: {
                // Start session with this pattern
            }) {
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(SerenityDesignSystem.Colors.softSkyBlue)
            }
        }
        .padding(SerenityDesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: SerenityDesignSystem.CornerRadius.medium)
                .fill(SerenityDesignSystem.Colors.crystalWhite)
                .shadow(
                    color: SerenityDesignSystem.Colors.deepCharcoal.opacity(0.05),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
    }
}

/// Settings toggle row
struct SettingsToggleRow: View {
    let title: String
    let description: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(SerenityDesignSystem.Typography.callout)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                
                Text(description)
                    .font(SerenityDesignSystem.Typography.caption)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: SerenityDesignSystem.Colors.softSkyBlue))
        }
    }
}

/// Custom pattern creator
struct SerenityCustomPatternCreator: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(DataManager.self) private var dataManager
    
    @State private var patternName = ""
    @State private var inhaleSeconds = 4.0
    @State private var holdSeconds = 4.0
    @State private var exhaleSeconds = 4.0
    @State private var pauseSeconds = 0.0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: SerenityDesignSystem.Spacing.xl) {
                    // Header
                    VStack(spacing: SerenityDesignSystem.Spacing.md) {
                        Text("Create Custom Pattern")
                            .font(SerenityDesignSystem.Typography.largeTitle)
                            .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                        
                        Text("Design a breathing rhythm that works for you")
                            .font(SerenityDesignSystem.Typography.body)
                            .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    
                    // Pattern name
                    SerenityCard {
                        VStack(alignment: .leading, spacing: SerenityDesignSystem.Spacing.md) {
                            Text("Pattern Name")
                                .font(SerenityDesignSystem.Typography.callout)
                                .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                            
                            TextField("Enter pattern name", text: $patternName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    // Timing controls
                    SerenityCard {
                        VStack(spacing: SerenityDesignSystem.Spacing.lg) {
                            Text("Breathing Timing")
                                .font(SerenityDesignSystem.Typography.callout)
                                .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                            
                            VStack(spacing: SerenityDesignSystem.Spacing.md) {
                                TimingSlider(
                                    title: "Inhale",
                                    value: $inhaleSeconds,
                                    range: 1...10,
                                    color: SerenityDesignSystem.Colors.sageGreen
                                )
                                
                                TimingSlider(
                                    title: "Hold",
                                    value: $holdSeconds,
                                    range: 0...10,
                                    color: SerenityDesignSystem.Colors.oceanTeal
                                )
                                
                                TimingSlider(
                                    title: "Exhale",
                                    value: $exhaleSeconds,
                                    range: 1...10,
                                    color: SerenityDesignSystem.Colors.softSkyBlue
                                )
                                
                                TimingSlider(
                                    title: "Pause",
                                    value: $pauseSeconds,
                                    range: 0...5,
                                    color: SerenityDesignSystem.Colors.lavenderMist
                                )
                            }
                        }
                    }
                    
                    // Preview
                    SerenityCard {
                        VStack(spacing: SerenityDesignSystem.Spacing.lg) {
                            Text("Preview")
                                .font(SerenityDesignSystem.Typography.callout)
                                .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                            
                            BreathingOrb(
                                size: 100,
                                isAnimating: true,
                                breathPhase: .inhale
                            )
                            
                            Text("Total cycle: \(Int(inhaleSeconds + holdSeconds + exhaleSeconds + pauseSeconds))s")
                                .font(SerenityDesignSystem.Typography.caption)
                                .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal.opacity(0.7))
                        }
                    }
                    
                    // Save button
                    SerenityButton(
                        title: "Save Pattern",
                        action: savePattern,
                        style: .primary,
                        size: .large
                    )
                    .disabled(patternName.isEmpty)
                }
                .padding(SerenityDesignSystem.Spacing.lg)
            }
            .background(SerenityDesignSystem.Colors.warmOffWhite)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func savePattern() {
        let pattern = BreathingPatternStruct(
            name: patternName,
            description: "Custom breathing pattern",
            inhaleSeconds: Int(inhaleSeconds),
            holdSeconds: Int(holdSeconds),
            exhaleSeconds: Int(exhaleSeconds),
            pauseSeconds: Int(pauseSeconds),
            isCustom: true
        )
        
        dataManager.addCustomPattern(pattern)
        dismiss()
    }
}

/// Timing adjustment slider
struct TimingSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let color: Color
    
    var body: some View {
        VStack(spacing: SerenityDesignSystem.Spacing.sm) {
            HStack {
                Text(title)
                    .font(SerenityDesignSystem.Typography.callout)
                    .foregroundColor(SerenityDesignSystem.Colors.deepCharcoal)
                
                Spacer()
                
                Text("\(Int(value))s")
                    .font(SerenityDesignSystem.Typography.callout)
                    .foregroundColor(color)
                    .fontWeight(.medium)
            }
            
            Slider(value: $value, in: range, step: 1)
                .accentColor(color)
        }
    }
}

#Preview("Serenity Content") {
    SerenityContentView()
        .environment(DataManager.shared)
}
