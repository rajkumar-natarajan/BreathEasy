//
//  SerenityLaunchScreen.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Elegant launch screen with blooming lotus animation
struct SerenityLaunchScreen: View {
    @State private var lotusScale: CGFloat = 0.5
    @State private var lotusOpacity: Double = 0.0
    @State private var taglineOpacity: Double = 0.0
    @State private var backgroundOffset: CGFloat = 0
    @State private var showContent: Bool = false
    
    let onLaunchComplete: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Animated background gradient
                SerenityDesignSystem.Colors.dawnGradient
                    .offset(y: backgroundOffset)
                    .ignoresSafeArea()
                
                // Floating particles
                FloatingParticles(screenSize: geometry.size)
                    .opacity(0.6)
                
                VStack(spacing: SerenityDesignSystem.Spacing.zen) {
                    Spacer()
                    
                    // Lotus Icon with breathing animation
                    ZStack {
                        // Outer glow
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 120, weight: .thin))
                            .foregroundStyle(
                                SerenityDesignSystem.Colors.crystalWhite.opacity(0.3)
                            )
                            .scaleEffect(lotusScale * 1.3)
                            .blur(radius: 8)
                        
                        // Main lotus
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 100, weight: .ultraLight))
                            .foregroundStyle(SerenityDesignSystem.Colors.crystalWhite)
                            .scaleEffect(lotusScale)
                            .opacity(lotusOpacity)
                            .shadow(
                                color: SerenityDesignSystem.Shadow.gentle,
                                radius: 20,
                                x: 0,
                                y: 10
                            )
                    }
                    .animation(
                        .easeOut(duration: SerenityDesignSystem.Animation.launch)
                        .delay(0.5),
                        value: lotusScale
                    )
                    
                    // App tagline
                    VStack(spacing: SerenityDesignSystem.Spacing.sm) {
                        Text("Breathe In Serenity")
                            .font(SerenityDesignSystem.Typography.hero)
                            .foregroundColor(SerenityDesignSystem.Colors.crystalWhite)
                            .multilineTextAlignment(.center)
                            .opacity(taglineOpacity)
                            .animation(
                                .easeOut(duration: SerenityDesignSystem.Animation.smooth)
                                .delay(1.5),
                                value: taglineOpacity
                            )
                        
                        Text("Find your calm, one breath at a time")
                            .font(SerenityDesignSystem.Typography.body)
                            .foregroundColor(SerenityDesignSystem.Colors.crystalWhite.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .opacity(taglineOpacity * 0.8)
                            .animation(
                                .easeOut(duration: SerenityDesignSystem.Animation.smooth)
                                .delay(2.0),
                                value: taglineOpacity
                            )
                    }
                    
                    Spacer()
                    
                    // Loading indicator
                    if !showContent {
                        LoadingBreath()
                            .opacity(taglineOpacity)
                    }
                    
                    Spacer()
                }
                .padding(SerenityDesignSystem.Spacing.xl)
            }
        }
        .onAppear {
            startLaunchSequence()
        }
    }
    
    private func startLaunchSequence() {
        // Animate background
        withAnimation(.easeInOut(duration: 3.0)) {
            backgroundOffset = -50
        }
        
        // Animate lotus
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            lotusScale = 1.0
            lotusOpacity = 1.0
        }
        
        // Animate tagline
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            taglineOpacity = 1.0
        }
        
        // Complete launch sequence
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            showContent = true
            withAnimation(.easeOut(duration: 0.5)) {
                onLaunchComplete()
            }
        }
    }
}

/// Breathing loading indicator with three orbiting particles
struct LoadingBreath: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .fill(SerenityDesignSystem.Colors.crystalWhite.opacity(0.6))
                    .frame(width: 8, height: 8)
                    .offset(x: 25)
                    .rotationEffect(.degrees(rotation + Double(index * 120)))
                    .scaleEffect(scale)
            }
        }
        .animation(
            .linear(duration: 2.0)
            .repeatForever(autoreverses: false),
            value: rotation
        )
        .animation(
            .easeInOut(duration: 1.0)
            .repeatForever(autoreverses: true),
            value: scale
        )
        .onAppear {
            rotation = 360
            scale = 1.2
        }
    }
}

#Preview("Launch Screen") {
    SerenityLaunchScreen {
        print("Launch completed")
    }
}
