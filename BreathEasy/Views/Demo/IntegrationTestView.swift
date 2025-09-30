//
//  IntegrationTestView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Simple test view to verify integration
struct IntegrationTestView: View {
    @State private var enhancedColorScheme = EnhancedColorScheme.shared
    private let dataManager = DataManager.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Test Modern Card
                    ModernCard {
                        Text("Integration Test")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    
                    // Test Data Manager
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Data Manager Test")
                            .font(.headline)
                        Text("Patterns: \(dataManager.breathingPatterns.count)")
                        Text("Sessions: \(dataManager.todaySessions.count)")
                        Text("Minutes: \(dataManager.todayMinutes)")
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // Test Color Scheme
                    HStack {
                        ForEach(enhancedColorScheme.breathingOrbColors.indices, id: \.self) { index in
                            Circle()
                                .fill(enhancedColorScheme.breathingOrbColors[index])
                                .frame(width: 30, height: 30)
                        }
                    }
                    
                    // Test Pattern Cards
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(dataManager.breathingPatterns.prefix(2)) { pattern in
                            VStack {
                                Text(pattern.name)
                                    .font(.caption)
                                Text("\(pattern.inhaleCount)-\(pattern.holdCount)-\(pattern.exhaleCount)")
                                    .font(.caption2)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
            .background(enhancedColorScheme.backgroundGradient)
            .navigationTitle("Integration Test")
        }
    }
}

#Preview {
    IntegrationTestView()
}
