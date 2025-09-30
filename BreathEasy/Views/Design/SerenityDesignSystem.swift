//
//  SerenityDesignSystem.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Comprehensive design system for BreatheEasy app following "Serenity Flow" principles
/// Inspired by nature's tranquil elements with psychological principles for calm and stress relief
struct SerenityDesignSystem {
    
    // MARK: - Color Palette
    /// Peaceful color palette inspired by nature's tranquil elements
    struct Colors {
        // Primary Colors
        static let softSkyBlue = Color(hex: "#A7C7E7")      // Primary accent color
        static let sageGreen = Color(hex: "#B2D8B2")        // Progress and CTAs
        static let lavenderMist = Color(hex: "#D7BDE2")     // Mood indicators
        static let oceanTeal = Color(hex: "#87CEEB")        // Haptic cues
        
        // Neutral Backgrounds
        static let warmOffWhite = Color(hex: "#F8F9FA")     // Light mode background
        static let deepCharcoal = Color(hex: "#2C3E50")     // Dark mode background
        static let softGray = Color(hex: "#E8F0FE")         // Card backgrounds
        
        // Supporting Colors
        static let mutedRose = Color(hex: "#E8DAB2")        // Error/Warning states
        static let crystalWhite = Color(hex: "#FFFFFF")     // Pure elements
        static let midnight = Color(hex: "#1A1A2E")         // Deep dark elements
        
        // Gradient Combinations
        static let dawnGradient = LinearGradient(
            colors: [softSkyBlue, lavenderMist],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let serenityGradient = LinearGradient(
            colors: [sageGreen.opacity(0.6), oceanTeal.opacity(0.4)],
            startPoint: .top,
            endPoint: .bottom
        )
        
        static let breathGradient = LinearGradient(
            colors: [softSkyBlue.opacity(0.8), sageGreen.opacity(0.6)],
            startPoint: .center,
            endPoint: .bottom
        )
        
        // Dark Mode Variants
        static let darkDawnGradient = LinearGradient(
            colors: [Color(hex: "#1E3A8A"), Color(hex: "#064E3B")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Typography
    /// SF Pro font system with zen-inspired spacing
    struct Typography {
        // Headers - SF Pro Display
        static let hero = Font.system(size: 48, weight: .thin, design: .default)
        static let largeTitle = Font.system(size: 32, weight: .thin, design: .default)
        static let title1 = Font.system(size: 28, weight: .light, design: .default)
        static let title2 = Font.system(size: 24, weight: .light, design: .default)
        static let title3 = Font.system(size: 20, weight: .regular, design: .default)
        
        // Body - SF Pro Text
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let bodyEmphasized = Font.system(size: 17, weight: .medium, design: .default)
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
        
        // Special - Breathing Phase Labels
        static let breathPhase = Font.system(size: 48, weight: .thin, design: .default)
        static let breathTimer = Font.system(size: 24, weight: .light, design: .default)
    }
    
    // MARK: - Spacing & Layout
    /// Organic spacing system based on multiples of 8pt
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
        
        // Special Zen Spacing
        static let zen: CGFloat = 40      // For breathing space
        static let flow: CGFloat = 56     // For natural flow
        static let serenity: CGFloat = 72 // For profound calm
    }
    
    // MARK: - Corner Radius
    /// Rounded forms for organic feel
    struct CornerRadius {
        static let small: CGFloat = 12
        static let medium: CGFloat = 20
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
        static let pill: CGFloat = 50
        static let circle: CGFloat = 999
    }
    
    // MARK: - Shadows & Elevation
    /// Neumorphic shadows for floating feel
    struct Shadow {
        static let gentle = Color.black.opacity(0.05)
        static let soft = Color.black.opacity(0.08)
        static let medium = Color.black.opacity(0.12)
        static let elevated = Color.black.opacity(0.16)
        
        static let gentleRadius: CGFloat = 4
        static let softRadius: CGFloat = 8
        static let mediumRadius: CGFloat = 12
        static let elevatedRadius: CGFloat = 20
    }
    
    // MARK: - Animation Durations
    /// Breath-like transitions
    struct Animation {
        static let quick: Double = 0.2
        static let smooth: Double = 0.3
        static let breath: Double = 0.5
        static let slow: Double = 0.8
        static let meditative: Double = 1.2
        static let launch: Double = 2.0
        
        // Breathing Animations
        static let inhale: Double = 4.0
        static let hold: Double = 1.0
        static let exhale: Double = 6.0
        static let pause: Double = 1.0
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
