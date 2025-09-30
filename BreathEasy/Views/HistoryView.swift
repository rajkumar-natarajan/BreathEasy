//
//  HistoryView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI
import Charts

/// History view showing past sessions and analytics
struct HistoryView: View {
    private let dataManager = DataManager.shared
    
    @State private var selectedTimeframe: Timeframe = .week
    @State private var selectedPattern: BreathingPattern? = nil
    @State private var showingFilterSheet = false
    
    enum Timeframe: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All Time"
        
        var dateRange: (start: Date, end: Date) {
            let calendar = Calendar.current
            let now = Date()
            
            switch self {
            case .week:
                let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
                return (weekStart, now)
            case .month:
                let monthStart = calendar.dateInterval(of: .month, for: now)?.start ?? now
                return (monthStart, now)
            case .year:
                let yearStart = calendar.dateInterval(of: .year, for: now)?.start ?? now
                return (yearStart, now)
            case .all:
                return (Date.distantPast, now)
            }
        }
    }
    
    private var filteredSessions: [BreathingSession] {
        let range = selectedTimeframe.dateRange
        var sessions = dataManager.getSessions(from: range.start, to: range.end)
        
        if let pattern = selectedPattern {
            sessions = sessions.filter { $0.pattern == pattern }
        }
        
        return sessions
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Summary cards
                    summaryCardsView
                    
                    // Charts section
                    chartsSection
                    
                    // Sessions list
                    sessionsListSection
                }
                .padding()
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showingFilterSheet = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingFilterSheet) {
                FilterSheet(
                    selectedTimeframe: $selectedTimeframe,
                    selectedPattern: $selectedPattern
                )
            }
        }
    }
    
    // MARK: - Summary Cards
    
    private var summaryCardsView: some View {
        VStack(spacing: 16) {
            // Timeframe selector
            timeframeSelectorView
            
            // Stats cards
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                SummaryCard(
                    title: "Sessions",
                    value: "\(filteredSessions.count)",
                    subtitle: selectedTimeframe.rawValue.lowercased(),
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                SummaryCard(
                    title: "Total Time",
                    value: formatTotalTime(filteredSessions.reduce(0) { $0 + $1.duration }),
                    subtitle: "mindful breathing",
                    icon: "clock.fill",
                    color: .blue
                )
                
                SummaryCard(
                    title: "Avg. Mood",
                    value: String(format: "%.1f", averageMoodImprovement),
                    subtitle: "improvement",
                    icon: "heart.fill",
                    color: .pink
                )
                
                SummaryCard(
                    title: "Best Streak",
                    value: "\(dataManager.longestStreak)",
                    subtitle: "days",
                    icon: "flame.fill",
                    color: .orange
                )
            }
        }
    }
    
    private var timeframeSelectorView: some View {
        Picker("Timeframe", selection: $selectedTimeframe) {
            ForEach(Timeframe.allCases, id: \.self) { timeframe in
                Text(timeframe.rawValue).tag(timeframe)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    // MARK: - Charts Section
    
    private var chartsSection: some View {
        VStack(spacing: 16) {
            if #available(iOS 16.0, *) {
                // Sessions over time chart
                if !filteredSessions.isEmpty {
                    sessionsOverTimeChart
                }
                
                // Pattern distribution chart
                if filteredSessions.count > 1 {
                    patternDistributionChart
                }
                
                // Mood trend chart
                if filteredSessions.filter({ $0.moodBefore != nil && $0.moodAfter != nil }).count > 1 {
                    moodTrendChart
                }
            } else {
                // Fallback for iOS 15
                Text("Charts require iOS 16+")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    @available(iOS 16.0, *)
    private var sessionsOverTimeChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sessions Over Time")
                .font(.headline)
                .fontWeight(.medium)
            
            Chart {
                ForEach(groupSessionsByDay(), id: \.date) { data in
                    BarMark(
                        x: .value("Date", data.date),
                        y: .value("Sessions", data.count)
                    )
                    .foregroundStyle(.blue.gradient)
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .stride(by: selectedTimeframe == .week ? .day : .weekOfYear)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                }
            }
            .chartYAxis {
                AxisMarks { mark in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    @available(iOS 16.0, *)
    private var patternDistributionChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pattern Usage")
                .font(.headline)
                .fontWeight(.medium)
            
            Chart {
                ForEach(getPatternCounts(), id: \.pattern) { data in
                    SectorMark(
                        angle: .value("Count", data.count),
                        innerRadius: .ratio(0.5),
                        outerRadius: .ratio(1.0)
                    )
                    .foregroundStyle(by: .value("Pattern", data.pattern.displayName))
                    .opacity(0.8)
                }
            }
            .frame(height: 200)
            .chartLegend(position: .bottom, alignment: .center, spacing: 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    @available(iOS 16.0, *)
    private var moodTrendChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mood Improvement Trend")
                .font(.headline)
                .fontWeight(.medium)
            
            Chart {
                ForEach(getMoodData(), id: \.date) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("Improvement", data.improvement)
                    )
                    .foregroundStyle(.pink.gradient)
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("Date", data.date),
                        y: .value("Improvement", data.improvement)
                    )
                    .foregroundStyle(.pink)
                }
            }
            .frame(height: 150)
            .chartYScale(domain: -2...2)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                }
            }
            .chartYAxis {
                AxisMarks { mark in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    // MARK: - Sessions List
    
    private var sessionsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Sessions")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
                
                if selectedPattern != nil {
                    Button("Clear Filter") {
                        selectedPattern = nil
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            
            if filteredSessions.isEmpty {
                emptyStateView
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(filteredSessions.prefix(10)) { session in
                        SessionRow(session: session)
                    }
                    
                    if filteredSessions.count > 10 {
                        Text("\(filteredSessions.count - 10) more sessions...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "wind")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            Text("No Sessions Found")
                .font(.headline)
                .fontWeight(.medium)
            
            Text("Start your first breathing session to see your progress here.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    // MARK: - Data Processing
    
    private var averageMoodImprovement: Double {
        let improvements: [Double] = filteredSessions.compactMap { session in
            guard let before = session.moodBefore?.rawValue,
                  let after = session.moodAfter?.rawValue else { return nil }
            return Double(after - before)
        }
        
        guard !improvements.isEmpty else { return 0.0 }
        return improvements.reduce(0, +) / Double(improvements.count)
    }
    
    private func formatTotalTime(_ totalSeconds: TimeInterval) -> String {
        let hours = Int(totalSeconds) / 3600
        let minutes = (Int(totalSeconds) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func groupSessionsByDay() -> [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredSessions) { session in
            calendar.startOfDay(for: session.date)
        }
        
        return grouped.map { (date: $0.key, count: $0.value.count) }
            .sorted { $0.date < $1.date }
    }
    
    private func getPatternCounts() -> [(pattern: BreathingPattern, count: Int)] {
        let grouped = Dictionary(grouping: filteredSessions) { $0.pattern }
        return grouped.map { (pattern: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
    }
    
    private func getMoodData() -> [(date: Date, improvement: Double)] {
        return filteredSessions.compactMap { session in
            guard let before = session.moodBefore?.rawValue,
                  let after = session.moodAfter?.rawValue else { return nil }
            return (date: session.date, improvement: Double(after - before))
        }.sorted { $0.date < $1.date }
    }
}

// MARK: - Supporting Views

struct SummaryCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct SessionRow: View {
    let session: BreathingSession
    
    var body: some View {
        HStack(spacing: 12) {
            // Pattern indicator
            Circle()
                .fill(ColorSchemeManager.primaryColor(for: session.pattern.colorScheme))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(session.pattern.displayName)
                        .font(.body)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(session.formattedDuration)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text(session.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if let before = session.moodBefore, let after = session.moodAfter {
                        HStack(spacing: 4) {
                            Text(before.emoji)
                            Image(systemName: "arrow.right")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text(after.emoji)
                        }
                        .font(.caption)
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
        )
    }
}

struct FilterSheet: View {
    @Binding var selectedTimeframe: HistoryView.Timeframe
    @Binding var selectedPattern: BreathingPattern?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Time Period") {
                    ForEach(HistoryView.Timeframe.allCases, id: \.self) { timeframe in
                        Button(action: { selectedTimeframe = timeframe }) {
                            HStack {
                                Text(timeframe.rawValue)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedTimeframe == timeframe {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                Section("Pattern Filter") {
                    Button(action: { selectedPattern = nil }) {
                        HStack {
                            Text("All Patterns")
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedPattern == nil {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    ForEach(BreathingPattern.allCases, id: \.self) { pattern in
                        Button(action: { selectedPattern = pattern }) {
                            HStack {
                                Text(pattern.displayName)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedPattern == pattern {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter Sessions")
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
}

// MARK: - Preview

#Preview {
    HistoryView()
}
