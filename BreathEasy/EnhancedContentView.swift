//
//  EnhancedContentView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Enhanced main app content view with modern tab navigation and theme support
struct EnhancedContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var showingSettings = false
    @State private var enhancedColorScheme = EnhancedColorScheme.shared
    
    private let dataManager = DataManager.shared
    
    enum Tab: String, CaseIterable {
        case home = "Home"
        case patterns = "Patterns"
        case history = "History"
        case settings = "Settings"
        
        var systemImage: String {
            switch self {
            case .home:
                return "house.fill"
            case .patterns:
                return "lungs.fill"
            case .history:
                return "chart.line.uptrend.xyaxis"
            case .settings:
                return "gearshape.fill"
            }
        }
        
        var selectedSystemImage: String {
            switch self {
            case .home:
                return "house.fill"
            case .patterns:
                return "lungs.fill"
            case .history:
                return "chart.line.uptrend.xyaxis.circle.fill"
            case .settings:
                return "gearshape.2.fill"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            EnhancedHomeView()
                .tabItem {
                    Image(systemName: selectedTab == .home ? Tab.home.selectedSystemImage : Tab.home.systemImage)
                    Text(Tab.home.rawValue)
                }
                .tag(Tab.home)
            
            // Patterns Tab
            PatternsLibraryView()
                .tabItem {
                    Image(systemName: selectedTab == .patterns ? Tab.patterns.selectedSystemImage : Tab.patterns.systemImage)
                    Text(Tab.patterns.rawValue)
                }
                .tag(Tab.patterns)
            
            // History Tab
            EnhancedHistoryView()
                .tabItem {
                    Image(systemName: selectedTab == .history ? Tab.history.selectedSystemImage : Tab.history.systemImage)
                    Text(Tab.history.rawValue)
                }
                .tag(Tab.history)
            
            // Settings Tab
            EnhancedSettingsView()
                .tabItem {
                    Image(systemName: selectedTab == .settings ? Tab.settings.selectedSystemImage : Tab.settings.systemImage)
                    Text(Tab.settings.rawValue)
                }
                .tag(Tab.settings)
        }
        .tint(enhancedColorScheme.primaryColor)
        .environment(dataManager)
        .preferredColorScheme(nil) // Allow system to manage light/dark mode
    }
}

// MARK: - Supporting Views

struct PatternsLibraryView: View {
    @Environment(DataManager.self) private var dataManager
    @State private var selectedPattern: BreathingPatternStruct?
    @State private var showingSession = false
    @State private var showingPatternCreator = false
    @State private var enhancedColorScheme = EnhancedColorScheme.shared
    @State private var sessionViewModel = SessionViewModel()
    
    private let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
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
                .padding(DesignTokens.Spacing.lg)
            }
            .background(enhancedColorScheme.backgroundGradient)
            .navigationTitle("Patterns")
            .navigationBarTitleDisplayMode(.large)
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
                EnhancedSessionView(
                    pattern: breathingPattern
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
}

struct EnhancedHistoryView: View {
    @Environment(DataManager.self) private var dataManager
    @State private var enhancedColorScheme = EnhancedColorScheme.shared
    @State private var selectedTimeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignTokens.Spacing.xxl) {
                    // Time range selector
                    timeRangeSelector
                    
                    // Overview stats
                    overviewStats
                    
                    // Progress chart
                    progressChart
                    
                    // Recent sessions
                    recentSessionsList
                }
                .padding(DesignTokens.Spacing.lg)
            }
            .background(enhancedColorScheme.backgroundGradient)
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var timeRangeSelector: some View {
        Picker("Time Range", selection: $selectedTimeRange) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(enhancedColorScheme.cardBackgroundColor)
        .cornerRadius(DesignTokens.CornerRadius.md)
    }
    
    private var overviewStats: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            ModernStatCard(
                title: "Total Sessions",
                value: "\(dataManager.allSessions.count)",
                icon: "checkmark.circle.fill",
                color: .green,
                trend: nil
            )
            
            ModernStatCard(
                title: "Total Minutes",
                value: "\(dataManager.totalMinutes)",
                icon: "clock.fill",
                color: enhancedColorScheme.primaryColor,
                trend: nil
            )
        }
    }
    
    private var progressChart: some View {
        ModernCard(backgroundColor: enhancedColorScheme.cardBackgroundColor) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                Text("Progress Overview")
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(.primary)
                
                // Placeholder for chart
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                    .fill(enhancedColorScheme.primaryColor.opacity(0.1))
                    .frame(height: 150)
                    .overlay(
                        Text("Chart Coming Soon")
                            .font(DesignTokens.Typography.subheadline)
                            .foregroundColor(.secondary)
                    )
            }
        }
    }
    
    private var recentSessionsList: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Recent Sessions")
                .font(DesignTokens.Typography.headline)
                .foregroundColor(.primary)
            
            ModernCard(backgroundColor: enhancedColorScheme.cardBackgroundColor) {
                VStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(Array(dataManager.recentSessions.prefix(10)), id: \.id) { session in
                        EnhancedSessionCard(session: session, colorScheme: enhancedColorScheme)
                        
                        if session.id != dataManager.recentSessions.prefix(10).last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
    }
}

struct EnhancedSettingsView: View {
    @State private var enhancedColorScheme = EnhancedColorScheme.shared
    @State private var showingColorSchemeSettings = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Button {
                        showingColorSchemeSettings = true
                    } label: {
                        HStack {
                            Image(systemName: "paintbrush.fill")
                                .foregroundColor(enhancedColorScheme.primaryColor)
                                .frame(width: 20)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Themes")
                                    .foregroundColor(.primary)
                                
                                Text(enhancedColorScheme.selectedScheme.displayName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Breathing") {
                    SettingsRow(
                        icon: "speaker.wave.2.fill",
                        title: "Sound Effects",
                        subtitle: "Enable breathing guidance sounds",
                        color: .blue
                    )
                    
                    SettingsRow(
                        icon: "iphone.radiowaves.left.and.right",
                        title: "Haptic Feedback",
                        subtitle: "Feel the rhythm",
                        color: .orange
                    )
                }
                
                Section("Data") {
                    SettingsRow(
                        icon: "icloud.fill",
                        title: "Sync Data",
                        subtitle: "Backup your progress",
                        color: .green
                    )
                    
                    SettingsRow(
                        icon: "trash.fill",
                        title: "Reset Data",
                        subtitle: "Clear all session data",
                        color: .red
                    )
                }
                
                Section("About") {
                    SettingsRow(
                        icon: "info.circle.fill",
                        title: "Version",
                        subtitle: "1.0.1",
                        color: .gray
                    )
                }
            }
            .background(enhancedColorScheme.backgroundGradient)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingColorSchemeSettings) {
            ColorSchemeSettingsView()
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    EnhancedContentView()
}
