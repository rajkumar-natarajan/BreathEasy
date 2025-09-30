//
//  ColorSchemeSettingsView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct ColorSchemeSettingsView: View {
    @State private var enhancedColorScheme = EnhancedColorScheme.shared
    @Environment(\.dismiss) private var dismiss
    
    private let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignTokens.Spacing.xxl) {
                    // Header
                    headerSection
                    
                    // Current selection preview
                    currentSelectionPreview
                    
                    // Color scheme options
                    colorSchemeGrid
                    
                    // Preview section
                    previewSection
                }
                .padding(DesignTokens.Spacing.lg)
            }
            .background(enhancedColorScheme.backgroundGradient)
            .navigationTitle("Themes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(enhancedColorScheme.primaryColor)
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Choose Your Theme")
                .font(DesignTokens.Typography.title2)
                .foregroundColor(.primary)
            
            Text("Personalize your breathing experience with beautiful color themes that match your mood and preferences.")
                .font(DesignTokens.Typography.body)
                .foregroundColor(.secondary)
        }
    }
    
    private var currentSelectionPreview: some View {
        ModernCard(backgroundColor: enhancedColorScheme.cardBackgroundColor) {
            VStack(spacing: DesignTokens.Spacing.lg) {
                HStack {
                    Text("Current Theme")
                        .font(DesignTokens.Typography.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(enhancedColorScheme.selectedScheme.displayName)
                        .font(DesignTokens.Typography.callout)
                        .fontWeight(.medium)
                        .foregroundColor(enhancedColorScheme.primaryColor)
                }
                
                // Color palette preview
                HStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach(enhancedColorScheme.breathingOrbColors.indices, id: \.self) { index in
                        Circle()
                            .fill(enhancedColorScheme.breathingOrbColors[index])
                            .frame(width: 24, height: 24)
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    private var colorSchemeGrid: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Available Themes")
                .font(DesignTokens.Typography.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: gridColumns, spacing: DesignTokens.Spacing.lg) {
                ForEach(EnhancedColorScheme.ColorSchemeType.allCases, id: \.self) { scheme in
                    ColorSchemeCard(
                        scheme: scheme,
                        isSelected: enhancedColorScheme.selectedScheme == scheme,
                        currentScheme: enhancedColorScheme
                    ) {
                        withAnimation(DesignTokens.Animation.medium) {
                            enhancedColorScheme.setColorScheme(scheme)
                        }
                    }
                }
            }
        }
    }
    
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            Text("Preview")
                .font(DesignTokens.Typography.headline)
                .foregroundColor(.primary)
            
            ModernCard(backgroundColor: enhancedColorScheme.cardBackgroundColor) {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    // Mini breathing orb preview
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        enhancedColorScheme.breathingOrbColors.first?.opacity(0.8) ?? .blue.opacity(0.8),
                                        enhancedColorScheme.breathingOrbColors.last?.opacity(0.4) ?? .blue.opacity(0.4),
                                        .clear
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 40
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .stroke(enhancedColorScheme.primaryColor, lineWidth: 3)
                            .frame(width: 90, height: 90)
                    }
                    
                    VStack(spacing: DesignTokens.Spacing.sm) {
                        Text("Breathe In")
                            .font(DesignTokens.Typography.headline)
                            .foregroundColor(enhancedColorScheme.primaryColor)
                        
                        Text("Slowly breathe in through your nose")
                            .font(DesignTokens.Typography.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Sample stats
                    HStack {
                        ModernStatCard(
                            title: "Sessions",
                            value: "5",
                            icon: "checkmark.circle.fill",
                            color: .green,
                            trend: nil
                        )
                        
                        ModernStatCard(
                            title: "Minutes",
                            value: "23",
                            icon: "clock.fill",
                            color: enhancedColorScheme.primaryColor,
                            trend: nil
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct ColorSchemeCard: View {
    let scheme: EnhancedColorScheme.ColorSchemeType
    let isSelected: Bool
    let currentScheme: EnhancedColorScheme
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            ModernCard(
                backgroundColor: scheme.cardBackgroundColor,
                cornerRadius: DesignTokens.CornerRadius.lg,
                shadowEnabled: !isSelected,
                borderColor: isSelected ? currentScheme.primaryColor : nil
            ) {
                VStack(spacing: DesignTokens.Spacing.md) {
                    // Theme name
                    HStack {
                        Text(scheme.displayName)
                            .font(DesignTokens.Typography.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.body)
                                .foregroundColor(currentScheme.primaryColor)
                        }
                    }
                    
                    // Color preview
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        ForEach(scheme.breathingOrbColors.indices, id: \.self) { index in
                            Circle()
                                .fill(scheme.breathingOrbColors[index])
                                .frame(width: 16, height: 16)
                        }
                        
                        Spacer()
                    }
                    
                    // Mini gradient preview
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                        .fill(scheme.backgroundGradient)
                        .frame(height: 24)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                                .stroke(Color(.separator), lineWidth: 0.5)
                        )
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
}

// MARK: - Preview

#Preview {
    ColorSchemeSettingsView()
}
