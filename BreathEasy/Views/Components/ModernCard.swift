//
//  ModernCard.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Modern iOS 18-style card component with enhanced visual design
struct ModernCard<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let shadowEnabled: Bool
    let borderColor: Color?
    
    init(
        backgroundColor: Color = Color(.systemBackground),
        cornerRadius: CGFloat = 16,
        shadowEnabled: Bool = true,
        borderColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowEnabled = shadowEnabled
        self.borderColor = borderColor
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor ?? Color.clear, lineWidth: borderColor != nil ? 1 : 0)
                    )
            )
            .conditionalShadow(enabled: shadowEnabled)
    }
}

/// Enhanced button with modern iOS design
struct ModernButton: View {
    let title: String
    let subtitle: String?
    let icon: String?
    let backgroundColor: Color
    let foregroundColor: Color
    let cornerRadius: CGFloat
    let action: () -> Void
    
    @State private var isPressed = false
    
    init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        backgroundColor: Color = .accentColor,
        foregroundColor: Color = .white,
        cornerRadius: CGFloat = 16,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.title2)
                        .fontWeight(.medium)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .opacity(0.8)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.body)
                    .fontWeight(.medium)
                    .opacity(0.6)
            }
            .foregroundColor(foregroundColor)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
        }
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
        }, perform: {})
        .buttonStyle(PlainButtonStyle())
    }
}

/// Modern progress indicator with enhanced styling
struct ModernProgressView: View {
    let progress: Double
    let lineWidth: CGFloat
    let color: Color
    let backgroundColor: Color
    
    init(
        progress: Double,
        lineWidth: CGFloat = 8,
        color: Color = .accentColor,
        backgroundColor: Color = Color(.systemGray5)
    ) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.color = color
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
    }
}

/// Enhanced stat card with modern design
struct ModernStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: StatTrend?
    
    enum StatTrend {
        case up(String)
        case down(String)
        case neutral(String)
        
        var color: Color {
            switch self {
            case .up: return .green
            case .down: return .red
            case .neutral: return .secondary
            }
        }
        
        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .neutral: return "minus"
            }
        }
        
        var text: String {
            switch self {
            case .up(let text), .down(let text), .neutral(let text):
                return text
            }
        }
    }
    
    var body: some View {
        ModernCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                        .frame(width: 28, height: 28)
                    
                    Spacer()
                    
                    if let trend = trend {
                        HStack(spacing: 4) {
                            Image(systemName: trend.icon)
                                .font(.caption)
                                .foregroundColor(trend.color)
                            
                            Text(trend.text)
                                .font(.caption)
                                .foregroundColor(trend.color)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(value)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// MARK: - Helper Extensions

extension View {
    @ViewBuilder
    func conditionalShadow(enabled: Bool) -> some View {
        if enabled {
            self.shadow(
                color: Color.black.opacity(0.1),
                radius: 8,
                x: 0,
                y: 2
            )
        } else {
            self
        }
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            ModernCard {
                Text("Modern Card Example")
                    .font(.headline)
            }
            
            ModernButton(
                title: "Start Breathing",
                subtitle: "4-7-8 Pattern • 5 minutes",
                icon: "play.circle.fill"
            ) {
                // Action
            }
            
            HStack {
                ModernStatCard(
                    title: "Sessions Today",
                    value: "3",
                    icon: "checkmark.circle.fill",
                    color: .green,
                    trend: .up("+1")
                )
                
                ModernStatCard(
                    title: "Weekly Streak",
                    value: "7",
                    icon: "flame.fill",
                    color: .orange,
                    trend: .neutral("7 days")
                )
            }
        }
        .padding()
    }
}
