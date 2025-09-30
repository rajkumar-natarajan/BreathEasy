//
//  EnhancedColorScheme.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Enhanced color scheme manager with modern iOS design system
@Observable
class EnhancedColorScheme {
    static let shared = EnhancedColorScheme()
    
    var selectedScheme: ColorSchemeType = .adaptive
    
    enum ColorSchemeType: String, CaseIterable {
        case adaptive = "Adaptive"
        case ocean = "Ocean"
        case forest = "Forest"
        case sunset = "Sunset"
        case lavender = "Lavender"
        case minimal = "Minimal"
        
        var displayName: String { rawValue }
        
        var primaryColor: Color {
            switch self {
            case .adaptive:
                return Color.accentColor
            case .ocean:
                return Color(red: 0.2, green: 0.6, blue: 0.9)
            case .forest:
                return Color(red: 0.2, green: 0.7, blue: 0.4)
            case .sunset:
                return Color(red: 0.9, green: 0.5, blue: 0.2)
            case .lavender:
                return Color(red: 0.6, green: 0.5, blue: 0.9)
            case .minimal:
                return Color.primary
            }
        }
        
        var secondaryColor: Color {
            switch self {
            case .adaptive:
                return Color.secondary
            case .ocean:
                return Color(red: 0.4, green: 0.8, blue: 1.0)
            case .forest:
                return Color(red: 0.4, green: 0.8, blue: 0.6)
            case .sunset:
                return Color(red: 1.0, green: 0.7, blue: 0.4)
            case .lavender:
                return Color(red: 0.8, green: 0.7, blue: 1.0)
            case .minimal:
                return Color.secondary
            }
        }
        
        var backgroundGradient: LinearGradient {
            switch self {
            case .adaptive:
                return LinearGradient(
                    colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .ocean:
                return LinearGradient(
                    colors: [
                        Color(red: 0.85, green: 0.95, blue: 1.0),
                        Color(red: 0.9, green: 0.97, blue: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .forest:
                return LinearGradient(
                    colors: [
                        Color(red: 0.9, green: 0.98, blue: 0.92),
                        Color(red: 0.95, green: 0.99, blue: 0.96)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .sunset:
                return LinearGradient(
                    colors: [
                        Color(red: 1.0, green: 0.95, blue: 0.9),
                        Color(red: 1.0, green: 0.97, blue: 0.94)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .lavender:
                return LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.93, blue: 1.0),
                        Color(red: 0.97, green: 0.96, blue: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .minimal:
                return LinearGradient(
                    colors: [Color(.systemBackground)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        
        var cardBackgroundColor: Color {
            switch self {
            case .adaptive:
                return Color(.systemBackground)
            case .ocean:
                return Color.white.opacity(0.9)
            case .forest:
                return Color.white.opacity(0.9)
            case .sunset:
                return Color.white.opacity(0.9)
            case .lavender:
                return Color.white.opacity(0.9)
            case .minimal:
                return Color(.secondarySystemBackground)
            }
        }
        
        var breathingOrbColors: [Color] {
            switch self {
            case .adaptive:
                return [Color.accentColor, Color.accentColor.opacity(0.6)]
            case .ocean:
                return [
                    Color(red: 0.2, green: 0.6, blue: 0.9),
                    Color(red: 0.4, green: 0.8, blue: 1.0),
                    Color(red: 0.6, green: 0.9, blue: 1.0)
                ]
            case .forest:
                return [
                    Color(red: 0.2, green: 0.7, blue: 0.4),
                    Color(red: 0.4, green: 0.8, blue: 0.6),
                    Color(red: 0.6, green: 0.9, blue: 0.8)
                ]
            case .sunset:
                return [
                    Color(red: 0.9, green: 0.5, blue: 0.2),
                    Color(red: 1.0, green: 0.7, blue: 0.4),
                    Color(red: 1.0, green: 0.8, blue: 0.6)
                ]
            case .lavender:
                return [
                    Color(red: 0.6, green: 0.5, blue: 0.9),
                    Color(red: 0.8, green: 0.7, blue: 1.0),
                    Color(red: 0.9, green: 0.8, blue: 1.0)
                ]
            case .minimal:
                return [Color.primary, Color.secondary]
            }
        }
        
        var shadowColor: Color {
            switch self {
            case .adaptive, .minimal:
                return Color.black.opacity(0.1)
            default:
                return primaryColor.opacity(0.15)
            }
        }
    }
    
    // MARK: - Methods
    
    func setColorScheme(_ scheme: ColorSchemeType) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedScheme = scheme
        }
    }
    
    // MARK: - Computed Properties
    
    var primaryColor: Color {
        selectedScheme.primaryColor
    }
    
    var secondaryColor: Color {
        selectedScheme.secondaryColor
    }
    
    var backgroundGradient: LinearGradient {
        selectedScheme.backgroundGradient
    }
    
    var cardBackgroundColor: Color {
        selectedScheme.cardBackgroundColor
    }
    
    var breathingOrbColors: [Color] {
        selectedScheme.breathingOrbColors
    }
    
    var shadowColor: Color {
        selectedScheme.shadowColor
    }
}

// MARK: - Modern Design Tokens

struct DesignTokens {
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 28
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title1 = Font.title.weight(.semibold)
        static let title2 = Font.title2.weight(.semibold)
        static let title3 = Font.title3.weight(.medium)
        static let headline = Font.headline.weight(.semibold)
        static let body = Font.body
        static let callout = Font.callout
        static let subheadline = Font.subheadline
        static let footnote = Font.footnote
        static let caption = Font.caption
        static let caption2 = Font.caption2
    }
    
    // MARK: - Animation
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let medium = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let spring = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.8)
        static let bouncy = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.6)
    }
    
    // MARK: - Shadow
    struct Shadow {
        static let small = (color: Color.black.opacity(0.1), radius: CGFloat(4), x: CGFloat(0), y: CGFloat(2))
        static let medium = (color: Color.black.opacity(0.15), radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4))
        static let large = (color: Color.black.opacity(0.2), radius: CGFloat(16), x: CGFloat(0), y: CGFloat(8))
    }
}

// MARK: - View Extensions

extension View {
    func modernShadow(_ style: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = DesignTokens.Shadow.medium) -> some View {
        self.shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
    
    func modernCard(
        backgroundColor: Color = Color(.systemBackground),
        cornerRadius: CGFloat = DesignTokens.CornerRadius.lg,
        shadowEnabled: Bool = true
    ) -> some View {
        self
            .padding(DesignTokens.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .conditionalShadow(enabled: shadowEnabled)
    }
    
    func pressableScale() -> some View {
        self.scaleEffect(1.0)
            .onTapGesture {}
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(DesignTokens.Animation.quick) {
                    // Scale effect handled by parent view
                }
            }, perform: {})
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                ForEach(EnhancedColorScheme.ColorSchemeType.allCases, id: \.self) { scheme in
                    VStack {
                        Text(scheme.displayName)
                            .font(DesignTokens.Typography.headline)
                        
                        HStack {
                            Rectangle()
                                .fill(scheme.primaryColor)
                                .frame(width: 50, height: 50)
                                .cornerRadius(DesignTokens.CornerRadius.sm)
                            
                            Rectangle()
                                .fill(scheme.secondaryColor)
                                .frame(width: 50, height: 50)
                                .cornerRadius(DesignTokens.CornerRadius.sm)
                        }
                    }
                    .modernCard()
                }
            }
            .padding()
        }
        .background(EnhancedColorScheme.shared.backgroundGradient)
        .navigationTitle("Color Schemes")
    }
}
