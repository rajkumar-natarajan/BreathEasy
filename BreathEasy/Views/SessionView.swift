//
//  SessionView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// Main session view for guided breathing exercises
struct SessionView: View {
    @Bindable var viewModel: SessionViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    
    let pattern: BreathingPattern
    let duration: TimeInterval
    let moodBefore: MoodLevel?
    
    @State private var showingMoodAfterSelector = false
    @State private var moodAfter: MoodLevel?
    @State private var showingSessionComplete = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                ColorSchemeManager.backgroundGradient(for: pattern.colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                        .padding(.top)
                    
                    Spacer()
                    
                    // Main breathing area
                    breathingAreaView
                    
                    Spacer()
                    
                    // Controls
                    controlsView
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            setupSession()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            handleScenePhaseChange(newPhase)
        }
        .onChange(of: viewModel.currentPhase) { oldPhase, newPhase in
            if newPhase == .completed {
                handleSessionCompletion()
            }
        }
        .sheet(isPresented: $showingMoodAfterSelector) {
            moodAfterSelectorView
        }
        .sheet(isPresented: $showingSessionComplete) {
            sessionCompleteView
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Button("Cancel") {
                    viewModel.stopSession()
                    dismiss()
                }
                .foregroundColor(.white.opacity(0.8))
                .font(.body)
                
                Spacer()
                
                Text(pattern.displayName)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(viewModel.sessionTimeRemaining)
                    .font(.body.monospacedDigit())
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.horizontal)
            
            // Progress bar
            ProgressView(value: viewModel.sessionProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: .white.opacity(0.8)))
                .scaleEffect(y: 2)
                .padding(.horizontal)
        }
    }
    
    // MARK: - Breathing Area View
    
    private var breathingAreaView: some View {
        VStack(spacing: 30) {
            // Phase instruction
            Text(viewModel.currentPhaseInstruction)
                .font(.largeTitle)
                .fontWeight(.light)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .animation(.easeInOut(duration: 0.5), value: viewModel.currentPhase)
            
            // Breathing orb
            BreathingOrbView(
                colorScheme: pattern.colorScheme,
                phase: viewModel.currentPhase,
                scale: viewModel.orbScale,
                opacity: viewModel.orbOpacity,
                particleOffset: viewModel.particleOffset
            )
            
            // Phase timer
            if viewModel.isSessionActive && viewModel.currentPhase != .ready && viewModel.currentPhase != .completed {
                VStack(spacing: 8) {
                    Text("Phase Progress")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    ProgressView(value: viewModel.phaseProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .white.opacity(0.9)))
                        .frame(width: 200)
                    
                    Text(viewModel.phaseTimeRemainingFormatted + "s")
                        .font(.caption.monospacedDigit())
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            // Cycle counter
            if viewModel.isSessionActive && viewModel.currentCycle > 0 {
                Text("Cycle \(viewModel.currentCycle)")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
    
    // MARK: - Controls View
    
    private var controlsView: some View {
        HStack(spacing: 40) {
            // Pause/Resume button
            if viewModel.canPause {
                Button(action: { viewModel.pauseSession() }) {
                    Image(systemName: "pause.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(.white.opacity(0.2)))
                }
            } else if viewModel.canResume {
                Button(action: { viewModel.resumeSession() }) {
                    Image(systemName: "play.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(.white.opacity(0.2)))
                }
            }
            
            // Stop button
            if viewModel.isSessionActive {
                Button(action: {
                    viewModel.stopSession()
                    dismiss()
                }) {
                    Image(systemName: "stop.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(.white.opacity(0.2)))
                }
            }
        }
    }
    
    // MARK: - Mood After Selector
    
    private var moodAfterSelectorView: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("How do you feel now?")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Rate your current mood after this breathing session")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                    ForEach(MoodLevel.allCases, id: \.self) { mood in
                        MoodSelectionButton(
                            mood: mood,
                            isSelected: moodAfter == mood
                        ) {
                            moodAfter = mood
                        }
                    }
                }
                
                Spacer()
                
                Button("Continue") {
                    if let mood = moodAfter {
                        viewModel.setMoodAfter(mood)
                    }
                    showingMoodAfterSelector = false
                    showingSessionComplete = true
                }
                .buttonStyle(.borderedProminent)
                .disabled(moodAfter == nil)
            }
            .padding()
            .navigationTitle("Session Complete")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium])
    }
    
    // MARK: - Session Complete View
    
    private var sessionCompleteView: some View {
        NavigationView {
            SessionCompleteView(
                pattern: pattern,
                duration: viewModel.elapsedTime,
                cyclesCompleted: viewModel.currentCycle,
                moodBefore: moodBefore,
                moodAfter: moodAfter
            ) {
                dismiss()
            }
        }
        .presentationDetents([.large])
    }
    
    // MARK: - Private Methods
    
    private func setupSession() {
        viewModel.configureSession(
            pattern: pattern,
            duration: duration
        )
        
        if let mood = moodBefore {
            viewModel.setMoodBefore(mood)
        }
        
        // Start session after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            viewModel.startSession()
        }
    }
    
    private func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .background:
            if viewModel.isSessionActive && !viewModel.isPaused {
                viewModel.pauseSession()
            }
        case .active:
            // Session can be manually resumed by user
            break
        case .inactive:
            break
        @unknown default:
            break
        }
    }
    
    private func handleSessionCompletion() {
        // Small delay before showing mood selector
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if moodBefore != nil {
                showingMoodAfterSelector = true
            } else {
                showingSessionComplete = true
            }
        }
    }
}

// MARK: - Mood Selection Button

struct MoodSelectionButton: View {
    let mood: MoodLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(mood.emoji)
                    .font(.system(size: 40))
                
                Text(mood.description)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.accentColor.opacity(0.3) : Color.gray.opacity(0.1))
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    SessionView(
        viewModel: SessionViewModel(),
        pattern: .fourSevenEight,
        duration: 300,
        moodBefore: .neutral
    )
}
