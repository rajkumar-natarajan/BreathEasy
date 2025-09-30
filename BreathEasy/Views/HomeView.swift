//
//  HomeView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Main home screen with pattern selection and session controls
struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var showingSession = false
    @State private var sessionViewModel = SessionViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with greeting and streak
                    headerView
                    
                    // Daily motivation
                    motivationCard
                    
                    // Quick mood check-in
                    moodCheckInCard
                    
                    // Breathing patterns carousel
                    patternsCarousel
                    
                    // Session duration selector
                    durationSelector
                    
                    // Start session button
                    startSessionButton
                    
                    // Today's progress
                    todaysProgressView
                    
                    // Recommendations
                    if let recommendation = viewModel.getPersonalizedRecommendation() {
                        recommendationCard(recommendation)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("BreatheEasy")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .foregroundColor(.primary)
                    }
                }
            }
            .fullScreenCover(isPresented: $showingSession) {
                SessionView(
                    viewModel: sessionViewModel,
                    pattern: viewModel.selectedPattern,
                    duration: viewModel.sessionDuration,
                    moodBefore: viewModel.currentMood
                )
            }
            .sheet(isPresented: $viewModel.showingCustomPatternCreator) {
                CustomPatternCreatorView { name, timing, colorScheme in
                    viewModel.createCustomPattern(
                        name: name,
                        timing: timing,
                        colorScheme: colorScheme
                    )
                }
            }
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(greetingText)
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Ready for mindful breathing?")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Streak counter
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(viewModel.currentStreak)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Text("day streak")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange.opacity(0.1))
            )
        }
    }
    
    // MARK: - Motivation Card
    
    private var motivationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "quote.opening")
                    .foregroundColor(.blue)
                    .font(.title3)
                
                Text("Daily Inspiration")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
            }
            
            Text(viewModel.getDailyMotivation())
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.05))
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
    
    // MARK: - Mood Check-in Card
    
    private var moodCheckInCard: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "heart.circle.fill")
                    .foregroundColor(.pink)
                    .font(.title3)
                
                Text("How are you feeling?")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
                
                if viewModel.currentMood != nil {
                    Button("Clear") {
                        viewModel.clearCurrentMood()
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            
            if let currentMood = viewModel.currentMood {
                HStack {
                    Text(currentMood.emoji)
                        .font(.title)
                    Text(currentMood.description)
                        .font(.body)
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.pink.opacity(0.1))
                )
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                    ForEach(MoodLevel.allCases, id: \.self) { mood in
                        Button(action: {
                            viewModel.setCurrentMood(mood)
                        }) {
                            VStack(spacing: 4) {
                                Text(mood.emoji)
                                    .font(.title2)
                                Text(mood.description)
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    // MARK: - Patterns Carousel
    
    private var patternsCarousel: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Breathing Patterns")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button(action: { viewModel.showCustomPatternCreator() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                        Text("Custom")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.availablePatterns) { patternItem in
                        PatternCard(
                            pattern: patternItem,
                            isSelected: viewModel.selectedPattern == patternItem.pattern,
                            onTap: {
                                viewModel.selectPattern(patternItem.pattern)
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
    
    // MARK: - Duration Selector
    
    private var durationSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session Duration")
                .font(.headline)
                .fontWeight(.medium)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.durationOptions, id: \.duration) { option in
                        DurationChip(
                            duration: option.duration,
                            display: option.display,
                            isSelected: viewModel.sessionDuration == option.duration,
                            onTap: {
                                viewModel.setSessionDuration(option.duration)
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Start Session Button
    
    private var startSessionButton: some View {
        Button(action: startSession) {
            HStack {
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Start Breathing")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Text("\(viewModel.selectedPattern.displayName) • \(formatDuration(viewModel.sessionDuration))")
                        .font(.caption)
                        .opacity(0.8)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.body)
                    .opacity(0.6)
            }
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: ColorSchemeManager.gradientColors(for: viewModel.selectedPattern.colorScheme)),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
        }
        .disabled(!viewModel.canStartSession())
    }
    
    // MARK: - Today's Progress
    
    private var todaysProgressView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Progress")
                .font(.headline)
                .fontWeight(.medium)
            
            HStack(spacing: 20) {
                ProgressStatView(
                    title: "Sessions",
                    value: "\(viewModel.todaySessionCount)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                ProgressStatView(
                    title: "Weekly",
                    value: "\(viewModel.weeklyStats.sessionsCount)",
                    icon: "calendar",
                    color: .blue
                )
                
                if let favoritePattern = viewModel.weeklyStats.favoritePattern {
                    ProgressStatView(
                        title: "Favorite",
                        value: favoritePattern.displayName.components(separatedBy: " ").first ?? "Pattern",
                        icon: "heart.fill",
                        color: .pink
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    // MARK: - Recommendation Card
    
    private func recommendationCard(_ recommendation: PatternRecommendation) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                    .font(.title3)
                
                Text("Recommended for You")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(recommendation.pattern.displayName)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(recommendation.reason)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Button("Try This Pattern") {
                viewModel.selectPattern(recommendation.pattern)
            }
            .font(.caption)
            .foregroundColor(.blue)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.yellow.opacity(0.05))
                .stroke(Color.yellow.opacity(0.2), lineWidth: 1)
        )
    }
    
    // MARK: - Private Methods
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<22:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        
        if seconds == 0 {
            return "\(minutes) min"
        } else {
            return "\(minutes):\(String(format: "%02d", seconds))"
        }
    }
    
    private func startSession() {
        sessionViewModel = SessionViewModel()
        showingSession = true
    }
}

// MARK: - Supporting Views

struct PatternCard: View {
    let pattern: PatternDisplayItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(pattern.displayName)
                            .font(.headline)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)
                        
                        Text(timingDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                }
                
                // Mini breathing orb preview
                HStack {
                    BreathingOrbPreview(colorScheme: pattern.pattern.colorScheme)
                    
                    Spacer()
                }
            }
            .padding()
            .frame(width: 200, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .stroke(
                        isSelected ? ColorSchemeManager.primaryColor(for: pattern.pattern.colorScheme) : Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var timingDescription: String {
        let timing = pattern.timing
        return "\(Int(timing.inhale))s-\(Int(timing.hold))s-\(Int(timing.exhale))s-\(Int(timing.pause))s"
    }
}

struct BreathingOrbPreview: View {
    let colorScheme: BreathingColorScheme
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .fill(ColorSchemeManager.orbGradient(for: colorScheme, phase: .inhale))
            .frame(width: 40, height: 40)
            .scaleEffect(isAnimating ? 1.2 : 0.8)
            .opacity(isAnimating ? 0.9 : 0.6)
            .animation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

struct DurationChip: View {
    let duration: TimeInterval
    let display: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(display)
                .font(.body)
                .fontWeight(isSelected ? .medium : .regular)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.accentColor : Color(.systemGray5))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProgressStatView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
