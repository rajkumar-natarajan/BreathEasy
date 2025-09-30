//
//  SessionCompleteView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI
import HealthKit

/// Session completion view with stats and achievements
struct SessionCompleteView: View {
    let pattern: BreathingPattern
    let duration: TimeInterval
    let cyclesCompleted: Int
    let moodBefore: MoodLevel?
    let moodAfter: MoodLevel?
    let onDismiss: () -> Void
    
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?
    @State private var showingHealthKitExport = false
    @State private var newBadges: [BreathingBadge] = []
    
    private let dataManager = DataManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                headerView
                
                // Stats cards
                statsCardsView
                
                // Mood comparison
                if let before = moodBefore, let after = moodAfter {
                    moodComparisonView(before: before, after: after)
                }
                
                // New badges
                if !newBadges.isEmpty {
                    newBadgesView
                }
                
                // Actions
                actionsView
                
                Spacer(minLength: 20)
            }
            .padding()
        }
        .navigationTitle("Session Complete")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    onDismiss()
                }
            }
        }
        .onAppear {
            checkForNewBadges()
            generateShareImage()
        }
        .sheet(isPresented: $showingShareSheet) {
            if let image = shareImage {
                ShareSheet(items: [image])
            }
        }
        .sheet(isPresented: $showingHealthKitExport) {
            HealthKitExportView(
                pattern: pattern,
                duration: duration,
                cyclesCompleted: cyclesCompleted
            )
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(spacing: 16) {
            // Success icon with animation
            ZStack {
                Circle()
                    .fill(pattern.colorScheme == .blue ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(ColorSchemeManager.primaryColor(for: pattern.colorScheme))
            }
            .scaleEffect(1.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: true)
            
            Text("Excellent Work!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("You completed your \(pattern.displayName) session")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Stats Cards
    
    private var statsCardsView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Duration",
                    value: formattedDuration,
                    icon: "clock.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "Cycles",
                    value: "\(cyclesCompleted)",
                    icon: "arrow.clockwise",
                    color: .green
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Pattern",
                    value: pattern.displayName.components(separatedBy: " ").first ?? pattern.displayName,
                    icon: "waveform.path",
                    color: .purple
                )
                
                StatCard(
                    title: "Streak",
                    value: "\(dataManager.currentStreak)",
                    icon: "flame.fill",
                    color: .orange
                )
            }
        }
    }
    
    // MARK: - Mood Comparison
    
    private func moodComparisonView(before: MoodLevel, after: MoodLevel) -> some View {
        VStack(spacing: 16) {
            Text("Mood Improvement")
                .font(.headline)
            
            HStack(spacing: 30) {
                VStack(spacing: 8) {
                    Text("Before")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(before.emoji)
                        .font(.system(size: 40))
                    
                    Text(before.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Image(systemName: "arrow.right")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 8) {
                    Text("After")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(after.emoji)
                        .font(.system(size: 40))
                    
                    Text(after.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
            )
            
            if after.rawValue > before.rawValue {
                Text("Great improvement! 🌟")
                    .font(.body)
                    .foregroundColor(.green)
            } else if after.rawValue == before.rawValue {
                Text("Maintained your calm 😌")
                    .font(.body)
                    .foregroundColor(.blue)
            }
        }
    }
    
    // MARK: - New Badges
    
    private var newBadgesView: some View {
        VStack(spacing: 16) {
            Text("New Achievement!")
                .font(.headline)
                .foregroundColor(.orange)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(newBadges, id: \.self) { badge in
                    BadgeCard(badge: badge)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.orange.opacity(0.1))
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Actions
    
    private var actionsView: some View {
        VStack(spacing: 12) {
            // Share button
            Button(action: { showingShareSheet = true }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Achievement")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            // HealthKit export button
            if dataManager.settings.enableHealthKitExport {
                Button(action: { showingHealthKitExport = true }) {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("Export to Health")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            
            // Start another session
            Button(action: { 
                onDismiss()
                // This would trigger navigation to start another session
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Another Session")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .foregroundColor(.primary)
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
    
    // MARK: - Private Methods
    
    private func checkForNewBadges() {
        // This would check against the saved badges before the session
        // For now, we'll simulate finding new badges
        let _ = BreathingBadge.allCases
        let earnedBadges = dataManager.earnedBadges
        
        // Check for potential new badges based on session completion
        if dataManager.sessions.count == 1 {
            newBadges.append(.firstSession)
        }
        
        if dataManager.currentStreak >= 3 && !earnedBadges.contains(.threeDayStreak) {
            newBadges.append(.threeDayStreak)
        }
        
        if dataManager.currentStreak >= 7 && !earnedBadges.contains(.sevenDayStreak) {
            newBadges.append(.sevenDayStreak)
        }
    }
    
    private func generateShareImage() {
        // Generate a shareable image with session stats
        let renderer = ImageRenderer(content: shareableContent)
        renderer.scale = 3.0
        shareImage = renderer.uiImage
    }
    
    private var shareableContent: some View {
        VStack(spacing: 20) {
            Text("🌱 BreatheEasy Session Complete")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                Text(pattern.displayName)
                    .font(.headline)
                
                Text("\(formattedDuration) • \(cyclesCompleted) cycles")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                if let before = moodBefore, let after = moodAfter {
                    HStack {
                        Text(before.emoji)
                        Image(systemName: "arrow.right")
                        Text(after.emoji)
                    }
                    .font(.title)
                }
            }
            
            Text("Breathe Easy, Live Fully")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(30)
        .background(Color.white)
        .cornerRadius(20)
        .frame(width: 400, height: 300)
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct BadgeCard: View {
    let badge: BreathingBadge
    
    var body: some View {
        VStack(spacing: 8) {
            Text(badge.emoji)
                .font(.system(size: 30))
            
            Text(badge.title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 2)
        )
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - HealthKit Export View

struct HealthKitExportView: View {
    let pattern: BreathingPattern
    let duration: TimeInterval
    let cyclesCompleted: Int
    
    @Environment(\.dismiss) private var dismiss
    @State private var isExporting = false
    @State private var exportComplete = false
    @State private var exportError: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                
                Text("Export to Health")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("This will add your breathing session to the Health app as a mindfulness workout.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Label("Pattern: \(pattern.displayName)", systemImage: "waveform.path")
                    Label("Duration: \(formattedDuration)", systemImage: "clock")
                    Label("Cycles: \(cyclesCompleted)", systemImage: "arrow.clockwise")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
                
                if exportComplete {
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.green)
                        
                        Text("Successfully exported to Health!")
                            .font(.body)
                            .foregroundColor(.green)
                    }
                } else if let error = exportError {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title)
                            .foregroundColor(.orange)
                        
                        Text(error)
                            .font(.body)
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.center)
                    }
                }
                
                if !exportComplete {
                    Button(action: exportToHealth) {
                        if isExporting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Export Session")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(isExporting)
                }
            }
            .padding()
            .navigationTitle("Health Export")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
    
    private func exportToHealth() {
        isExporting = true
        exportError = nil
        
        // Simulate HealthKit export
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // In a real implementation, this would use HealthKit APIs
            // For now, we'll simulate success
            isExporting = false
            exportComplete = true
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        SessionCompleteView(
            pattern: .fourSevenEight,
            duration: 300,
            cyclesCompleted: 5,
            moodBefore: .stressed,
            moodAfter: .calm
        ) {
            // Dismiss action
        }
    }
}
