//
//  EnhancedHomeView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct EnhancedHomeView: View {
    @Environment(DataManager.self) private var dataManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedPattern: BreathingPatternStruct?
    @State private var showingSession = false
    @State private var showingPatternCreator = false
    @State private var enhancedColorScheme = EnhancedColorScheme.shared
    @State private var sessionViewModel = SessionViewModel()
    
    private let gridColumns = [
        GridItem(.flexible(), spacing: nil),
        GridItem(.flexible(), spacing: nil)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: DesignTokens.Spacing.xxl) {
                    // Welcome Header
                    welcomeSection
                    
                    // Quick Stats
                    quickStatsSection
                    
                    // Breathing Patterns
                    patternsSection
                    
                    // Recent Sessions
                    if !dataManager.recentSessions.isEmpty {
                        recentSessionsSection
                    }
                }
                .padding(DesignTokens.Spacing.lg)
            }
            .background(enhancedColorScheme.backgroundGradient)
            .navigationTitle("BreathEasy")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(false)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarItems(
                trailing: Button {
                    showingPatternCreator = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(enhancedColorScheme.primaryColor)
                }
            )
        }
        .sheet(isPresented: $showingSession) {
            if let pattern = selectedPattern,
               let breathingPattern = pattern.toBreathingPattern() {
                SessionView(
                    viewModel: sessionViewModel,
                    pattern: breathingPattern,
                    duration: 300, // 5 minutes default
                    moodBefore: nil
                )
            }
        }
        .sheet(isPresented: $showingPatternCreator) {
            CustomPatternCreatorView { name, timing, colorScheme in
                // Create and save the custom pattern
                let customPattern = CustomBreathingPattern(
                    name: name,
                    timing: timing,
                    colorScheme: colorScheme,
                    dateCreated: Date()
                )
                dataManager.saveCustomPattern(customPattern)
            }
        }
    }
    
    // MARK: - View Components
    
    private var welcomeSection: some View {
        ModernCard(backgroundColor: enhancedColorScheme.cardBackgroundColor) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        Text("Welcome back!")
                            .font(DesignTokens.Typography.title2)
                            .foregroundColor(.primary)
                        
                        Text("Take a moment to breathe and center yourself.")
                            .font(DesignTokens.Typography.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundColor(enhancedColorScheme.primaryColor)
                        .scaleEffect(1.2)
                }
                
                // Quick Action Button
                ModernButton(
                    title: "Quick Session",
                    subtitle: "Start a 5-minute breathing session",
                    icon: "play.circle.fill",
                    backgroundColor: enhancedColorScheme.primaryColor
                ) {
                    if let defaultPattern = dataManager.breathingPatterns.first?.toBreathingPattern() {
                        selectedPattern = dataManager.breathingPatterns.first
                        showingSession = true
                    }
                }
            }
        }
    }
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Today's Progress")
                .font(DesignTokens.Typography.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: DesignTokens.Spacing.md) {
                ModernStatCard(
                    title: "Sessions",
                    value: "\(dataManager.todaySessions.count)",
                    icon: "checkmark.circle.fill",
                    color: .green,
                    trend: dataManager.todaySessions.count > 0 ? .up("+\(dataManager.todaySessions.count)") : nil
                )
                
                ModernStatCard(
                    title: "Minutes",
                    value: "\(dataManager.todayMinutes)",
                    icon: "clock.fill",
                    color: enhancedColorScheme.primaryColor,
                    trend: dataManager.todayMinutes > 0 ? .neutral("\(dataManager.todayMinutes)m") : nil
                )
            }
            
            HStack(spacing: DesignTokens.Spacing.md) {
                ModernStatCard(
                    title: "Streak",
                    value: "\(dataManager.currentStreak)",
                    icon: "flame.fill",
                    color: .orange,
                    trend: dataManager.currentStreak > 0 ? .up("\(dataManager.currentStreak) days") : nil
                )
                
                ModernStatCard(
                    title: "This Week",
                    value: "\(dataManager.weekSessions.count)",
                    icon: "calendar",
                    color: .purple,
                    trend: .neutral("7 days")
                )
            }
        }
    }
    
    private var patternsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            HStack {
                Text("Breathing Patterns")
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("See All") {
                    // Navigate to all patterns
                }
                .font(DesignTokens.Typography.callout)
                .foregroundColor(enhancedColorScheme.primaryColor)
            }
            
            LazyVGrid(columns: gridColumns, spacing: DesignTokens.Spacing.lg) {
                ForEach(dataManager.breathingPatterns) { pattern in
                    EnhancedPatternCard(
                        pattern: pattern,
                        colorScheme: enhancedColorScheme
                    ) {
                        selectedPattern = pattern
                        showingSession = true
                    }
                }
            }
        }
    }
    
    private var recentSessionsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Recent Sessions")
                .font(DesignTokens.Typography.headline)
                .foregroundColor(.primary)
            
            ModernCard(backgroundColor: enhancedColorScheme.cardBackgroundColor) {
                VStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(Array(dataManager.recentSessions.prefix(3)), id: \.id) { session in
                        EnhancedSessionCard(session: session, colorScheme: enhancedColorScheme)
                        
                        if session.id != dataManager.recentSessions.prefix(3).last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Enhanced Supporting Views

struct EnhancedPatternCard: View {
    let pattern: BreathingPatternStruct
    let colorScheme: EnhancedColorScheme
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            ModernCard(
                backgroundColor: colorScheme.cardBackgroundColor,
                shadowEnabled: true
            ) {
                VStack(spacing: DesignTokens.Spacing.md) {
                    // Pattern Icon with animated background
                    ZStack {
                        Circle()
                            .fill(patternColor.opacity(0.15))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: patternIcon)
                            .font(.title2)
                            .foregroundColor(patternColor)
                    }
                    
                    VStack(spacing: DesignTokens.Spacing.xs) {
                        Text(pattern.name)
                            .font(DesignTokens.Typography.headline)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text(patternDescription)
                            .font(DesignTokens.Typography.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Pattern timing preview
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(patternColor.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                }
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(DesignTokens.Animation.quick) {
                isPressed = pressing
            }
        }, perform: {})
        .buttonStyle(PlainButtonStyle())
    }
    
    private var patternColor: Color {
        switch pattern.name.lowercased() {
        case let name where name.contains("4-7-8"):
            return .blue
        case let name where name.contains("box"):
            return .green
        case let name where name.contains("triangle"):
            return .purple
        case let name where name.contains("coherent"):
            return .orange
        default:
            return colorScheme.primaryColor
        }
    }
    
    private var patternIcon: String {
        switch pattern.name.lowercased() {
        case let name where name.contains("4-7-8"):
            return "moon.zzz.fill"
        case let name where name.contains("box"):
            return "square.fill"
        case let name where name.contains("triangle"):
            return "triangle.fill"
        case let name where name.contains("coherent"):
            return "heart.fill"
        default:
            return "lungs.fill"
        }
    }
    
    private var patternDescription: String {
        "Inhale \(pattern.inhaleCount)s • Hold \(pattern.holdCount)s • Exhale \(pattern.exhaleCount)s"
    }
}

struct EnhancedSessionCard: View {
    let session: BreathingSession
    let colorScheme: EnhancedColorScheme
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            // Status indicator
            ZStack {
                Circle()
                    .fill(.green.opacity(0.15))
                    .frame(width: 32, height: 32)
                
                Image(systemName: "checkmark")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }
            
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(session.patternName)
                    .font(DesignTokens.Typography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(session.startTime, style: .time)
                    .font(DesignTokens.Typography.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: DesignTokens.Spacing.xs) {
                Text("\(Int(session.duration / 60))min")
                    .font(DesignTokens.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(colorScheme.primaryColor)
                
                Text("\(session.completedCycles) cycles")
                    .font(DesignTokens.Typography.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    EnhancedHomeView()
        .environment(DataManager.shared)
}
