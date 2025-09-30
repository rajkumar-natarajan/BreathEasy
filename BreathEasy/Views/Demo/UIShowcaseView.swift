//
//  UIShowcaseView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Showcase view demonstrating all enhanced UI components
struct UIShowcaseView: View {
    @State private var enhancedColorScheme = EnhancedColorScheme.shared
    @State private var selectedPhase: BreathingPhase = .inhale
    @State private var progress: Double = 0.6
    
    private let samplePattern = BreathingPattern.fourSevenEight
    
    private let sampleSession = BreathingSession(
        pattern: .fourSevenEight,
        duration: 300,
        cyclesCompleted: 5
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignTokens.Spacing.xxl) {
                    // Header
                    headerSection
                    
                    // Modern Cards
                    modernCardsSection
                    
                    // Enhanced Breathing Orb
                    breathingOrbSection
                    
                    // Modern Buttons
                    modernButtonsSection
                    
                    // Stats Cards
                    statsCardsSection
                    
                    // Pattern Cards
                    patternCardsSection
                    
                    // Color Scheme Preview
                    colorSchemeSection
                }
                .padding(DesignTokens.Spacing.lg)
            }
            .background(enhancedColorScheme.backgroundGradient)
            .navigationTitle("UI Showcase")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(EnhancedColorScheme.ColorSchemeType.allCases, id: \.self) { scheme in
                            Button(scheme.displayName) {
                                withAnimation(DesignTokens.Animation.medium) {
                                    enhancedColorScheme.setColorScheme(scheme)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "paintbrush.fill")
                            .foregroundColor(enhancedColorScheme.primaryColor)
                    }
                }
            }
        }
    }
    
    // MARK: - Section Views
    
    private var headerSection: some View {
        ModernCard(backgroundColor: enhancedColorScheme.cardBackgroundColor) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        Text("BreathEasy UI Showcase")
                            .font(DesignTokens.Typography.title2)
                            .foregroundColor(.primary)
                        
                        Text("Experience the modern design improvements")
                            .font(DesignTokens.Typography.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "sparkles")
                        .font(.title)
                        .foregroundColor(enhancedColorScheme.primaryColor)
                }
            }
        }
    }
    
    private var modernCardsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Modern Cards")
                .font(DesignTokens.Typography.headline)
                .foregroundColor(.primary)
            
            ModernCard(backgroundColor: enhancedColorScheme.cardBackgroundColor) {
                Text("This is a modern card with enhanced shadows and rounded corners")
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(.primary)
            }
            
            ModernCard(
                backgroundColor: enhancedColorScheme.primaryColor.opacity(0.1),
                borderColor: enhancedColorScheme.primaryColor
            ) {
                Text("Card with colored background and border")
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var breathingOrbSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Enhanced Breathing Orb")
                .font(DesignTokens.Typography.headline)
                .foregroundColor(.primary)
            
            ModernCard(backgroundColor: enhancedColorScheme.cardBackgroundColor) {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    EnhancedBreathingOrbView(
                        phase: selectedPhase,
                        pattern: samplePattern,
                        progress: progress,
                        colorScheme: enhancedColorScheme
                    )
                    .frame(height: 300)
                    
                    // Phase controls
                    HStack {
                        ForEach([BreathingPhase.inhale, .hold, .exhale, .pause], id: \.self) { phase in
                            Button(phase.rawValue.capitalized) {
                                withAnimation(DesignTokens.Animation.medium) {
                                    selectedPhase = phase
                                }
                            }
                            .padding(.horizontal, DesignTokens.Spacing.md)
                            .padding(.vertical, DesignTokens.Spacing.sm)
                            .background(
                                selectedPhase == phase ? enhancedColorScheme.primaryColor : Color.secondary.opacity(0.2)
                            )
                            .foregroundColor(selectedPhase == phase ? .white : .primary)
                            .cornerRadius(DesignTokens.CornerRadius.sm)
                        }
                    }
                }
            }
        }
    }
    
    private var modernButtonsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Modern Buttons")
                .font(DesignTokens.Typography.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: DesignTokens.Spacing.md) {
                ModernButton(
                    title: "Start Session",
                    subtitle: "Begin your breathing practice",
                    icon: "play.circle.fill",
                    backgroundColor: enhancedColorScheme.primaryColor
                ) {
                    // Action
                }
                
                ModernButton(
                    title: "View History",
                    subtitle: "See your progress over time",
                    icon: "chart.line.uptrend.xyaxis",
                    backgroundColor: .secondary.opacity(0.1),
                    foregroundColor: .primary
                ) {
                    // Action
                }
            }
        }
    }
    
    private var statsCardsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Stats Cards")
                .font(DesignTokens.Typography.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: DesignTokens.Spacing.md) {
                ModernStatCard(
                    title: "Sessions",
                    value: "12",
                    icon: "checkmark.circle.fill",
                    color: .green,
                    trend: .up("+3")
                )
                
                ModernStatCard(
                    title: "Minutes",
                    value: "45",
                    icon: "clock.fill",
                    color: enhancedColorScheme.primaryColor,
                    trend: .neutral("today")
                )
            }
            
            HStack(spacing: DesignTokens.Spacing.md) {
                ModernStatCard(
                    title: "Streak",
                    value: "7",
                    icon: "flame.fill",
                    color: .orange,
                    trend: .up("7 days")
                )
                
                ModernStatCard(
                    title: "Average",
                    value: "8.5",
                    icon: "star.fill",
                    color: .yellow,
                    trend: .down("-0.2")
                )
            }
        }
    }
    
    private var patternCardsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Pattern Cards")
                .font(DesignTokens.Typography.headline)
                .foregroundColor(.primary)
            
            let patterns = [
                BreathingPatternStruct(from: .fourSevenEight),
                BreathingPatternStruct(from: .box),
                BreathingPatternStruct(from: .diaphragmatic),
                BreathingPatternStruct(from: .resonant)
            ]
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DesignTokens.Spacing.md) {
                ForEach(patterns) { pattern in
                    EnhancedPatternCard(
                        pattern: pattern,
                        colorScheme: enhancedColorScheme
                    ) {
                        // Action
                    }
                }
            }
        }
    }
    
    private var colorSchemeSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Color Schemes")
                .font(DesignTokens.Typography.headline)
                .foregroundColor(.primary)
            
            ModernCard(backgroundColor: enhancedColorScheme.cardBackgroundColor) {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    HStack {
                        Text("Current Theme: \(enhancedColorScheme.selectedScheme.displayName)")
                            .font(DesignTokens.Typography.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    
                    // Color palette
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        ForEach(enhancedColorScheme.breathingOrbColors.indices, id: \.self) { index in
                            Circle()
                                .fill(enhancedColorScheme.breathingOrbColors[index])
                                .frame(width: 32, height: 32)
                        }
                        
                        Spacer()
                    }
                    
                    // Background gradient preview
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                        .fill(enhancedColorScheme.backgroundGradient)
                        .frame(height: 60)
                        .overlay(
                            Text("Background Gradient")
                                .font(DesignTokens.Typography.caption)
                                .foregroundColor(.secondary)
                        )
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    UIShowcaseView()
}
