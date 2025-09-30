//
//  ContentView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Main app content view with tab navigation
struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var showingOnboarding = false
    
    private let dataManager = DataManager.shared
    
    enum Tab: String, CaseIterable {
        case home = "Home"
        case history = "History"
        case achievements = "Achievements"
        
        var systemImage: String {
            switch self {
            case .home:
                return "house.fill"
            case .history:
                return "chart.line.uptrend.xyaxis"
            case .achievements:
                return "trophy.fill"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView()
                .tabItem {
                    Image(systemName: Tab.home.systemImage)
                    Text(Tab.home.rawValue)
                }
                .tag(Tab.home)
            
            // History Tab
            HistoryView()
                .tabItem {
                    Image(systemName: Tab.history.systemImage)
                    Text(Tab.history.rawValue)
                }
                .tag(Tab.history)
            
            // Achievements Tab
            AchievementsView()
                .tabItem {
                    Image(systemName: Tab.achievements.systemImage)
                    Text(Tab.achievements.rawValue)
                }
                .tag(Tab.achievements)
        }
        .accentColor(ColorSchemeManager.primaryColor(for: dataManager.settings.colorScheme))
        .onAppear {
            checkFirstLaunch()
        }
        .sheet(isPresented: $showingOnboarding) {
            OnboardingView {
                showingOnboarding = false
            }
        }
    }
    
    private func checkFirstLaunch() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "has_launched_before")
        if !hasLaunchedBefore {
            showingOnboarding = true
            UserDefaults.standard.set(true, forKey: "has_launched_before")
        }
    }
}

// MARK: - Achievements View

struct AchievementsView: View {
    private let dataManager = DataManager.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Progress overview
                    progressOverviewView
                    
                    // Badge collections
                    badgeCollectionsView
                    
                    // Statistics
                    statisticsView
                }
                .padding()
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var progressOverviewView: some View {
        VStack(spacing: 16) {
            Text("Your Journey")
                .font(.headline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                ProgressCircle(
                    title: "Badges Earned",
                    current: dataManager.earnedBadges.count,
                    total: BreathingBadge.allCases.count,
                    color: .orange
                )
                
                ProgressCircle(
                    title: "Current Streak",
                    current: dataManager.currentStreak,
                    total: max(30, dataManager.longestStreak),
                    color: .blue,
                    suffix: " days"
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private var badgeCollectionsView: some View {
        VStack(spacing: 16) {
            Text("Badges")
                .font(.headline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                ForEach(BreathingBadge.allCases, id: \.self) { badge in
                    BadgeView(
                        badge: badge,
                        isEarned: dataManager.earnedBadges.contains(badge)
                    )
                }
            }
        }
    }
    
    private var statisticsView: some View {
        VStack(spacing: 16) {
            Text("Statistics")
                .font(.headline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                StatisticRow(
                    title: "Total Sessions",
                    value: "\(dataManager.totalSessionsCount)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                StatisticRow(
                    title: "Total Time",
                    value: formatTimeInterval(dataManager.totalTimeSpent),
                    icon: "clock.fill",
                    color: .blue
                )
                
                StatisticRow(
                    title: "Longest Streak",
                    value: "\(dataManager.longestStreak) days",
                    icon: "flame.fill",
                    color: .orange
                )
                
                StatisticRow(
                    title: "Favorite Pattern",
                    value: getFavoritePattern(),
                    icon: "heart.fill",
                    color: .pink
                )
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func getFavoritePattern() -> String {
        let patternCounts = Dictionary(grouping: dataManager.sessions, by: { $0.pattern })
            .mapValues { $0.count }
        
        return patternCounts.max(by: { $0.value < $1.value })?.key.displayName ?? "None"
    }
}

// MARK: - Supporting Views

struct ProgressCircle: View {
    let title: String
    let current: Int
    let total: Int
    let color: Color
    let suffix: String
    
    init(title: String, current: Int, total: Int, color: Color, suffix: String = "") {
        self.title = title
        self.current = current
        self.total = total
        self.color = color
        self.suffix = suffix
    }
    
    private var progress: Double {
        guard total > 0 else { return 0 }
        return Double(current) / Double(total)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 2) {
                    Text("\(current)")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    if suffix.isEmpty {
                        Text("/\(total)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            if !suffix.isEmpty {
                Text(suffix)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct BadgeView: View {
    let badge: BreathingBadge
    let isEarned: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(badge.emoji)
                .font(.system(size: 30))
                .opacity(isEarned ? 1.0 : 0.3)
            
            Text(badge.title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(isEarned ? .primary : .secondary)
            
            Text(badge.description)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding()
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isEarned ? Color.green.opacity(0.1) : Color(.systemGray6))
                .stroke(isEarned ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .scaleEffect(isEarned ? 1.0 : 0.95)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isEarned)
    }
}

struct StatisticRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .frame(width: 24)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Onboarding View

struct OnboardingView: View {
    let onComplete: () -> Void
    
    @State private var currentPage = 0
    private let pages = OnboardingPage.allPages
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Controls
            VStack(spacing: 20) {
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.accentColor : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                
                // Navigation buttons
                HStack {
                    if currentPage > 0 {
                        Button("Back") {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(currentPage == pages.count - 1 ? "Get Started" : "Next") {
                        if currentPage == pages.count - 1 {
                            onComplete()
                        } else {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let imageName: String
    let description: String
    
    static let allPages = [
        OnboardingPage(
            title: "Welcome to BreatheEasy",
            subtitle: "Your offline breathing companion",
            imageName: "lungs.fill",
            description: "Practice mindful breathing anywhere, anytime. No internet required, no data shared."
        ),
        OnboardingPage(
            title: "Guided Breathing",
            subtitle: "Visual and haptic guidance",
            imageName: "waveform.path",
            description: "Follow the gentle animations and feel the rhythm with haptic feedback synchronized to your breathing."
        ),
        OnboardingPage(
            title: "Track Your Progress",
            subtitle: "Build healthy habits",
            imageName: "chart.line.uptrend.xyaxis",
            description: "Monitor your sessions, mood improvements, and build streaks. All data stays private on your device."
        ),
        OnboardingPage(
            title: "Your Privacy Matters",
            subtitle: "100% offline and secure",
            imageName: "hand.raised.fill",
            description: "Everything happens on your device. No accounts, no tracking, no data collection. Just you and your breath."
        )
    ]
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
