//
//  CustomPatternCreatorView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

/// View for creating custom breathing patterns
struct CustomPatternCreatorView: View {
    let onSave: (String, BreathingTiming, BreathingColorScheme) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var patternName = ""
    @State private var inhaleTime: Double = 4.0
    @State private var holdTime: Double = 4.0
    @State private var exhaleTime: Double = 4.0
    @State private var pauseTime: Double = 1.0
    @State private var selectedColorScheme: BreathingColorScheme = .blue
    @State private var showingPreview = false
    
    private var currentTiming: BreathingTiming {
        BreathingTiming(
            inhale: inhaleTime,
            hold: holdTime,
            exhale: exhaleTime,
            pause: pauseTime
        )
    }
    
    private var isValid: Bool {
        !patternName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        currentTiming.isValid
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView
                    
                    // Pattern name input
                    nameInputSection
                    
                    // Timing controls
                    timingControlsSection
                    
                    // Color scheme selector
                    colorSchemeSection
                    
                    // Preview section
                    previewSection
                    
                    // Pattern info
                    patternInfoSection
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("Custom Pattern")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePattern()
                    }
                    .disabled(!isValid)
                }
            }
            .sheet(isPresented: $showingPreview) {
                PatternPreviewView(
                    timing: currentTiming,
                    colorScheme: selectedColorScheme
                )
            }
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "waveform.path")
                .font(.system(size: 40))
                .foregroundColor(ColorSchemeManager.primaryColor(for: selectedColorScheme))
            
            Text("Create Your Perfect Breathing Pattern")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Text("Design a custom breathing rhythm that matches your unique needs and preferences.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Name Input Section
    
    private var nameInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Pattern Name")
                .font(.headline)
                .fontWeight(.medium)
            
            TextField("Enter a name for your pattern", text: $patternName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.done)
        }
    }
    
    // MARK: - Timing Controls Section
    
    private var timingControlsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Breathing Timing")
                .font(.headline)
                .fontWeight(.medium)
            
            Text("Adjust each phase duration to create your ideal breathing rhythm.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(spacing: 20) {
                TimingSlider(
                    title: "Inhale",
                    value: $inhaleTime,
                    range: 1...20,
                    color: .blue,
                    icon: "arrow.up.circle.fill"
                )
                
                TimingSlider(
                    title: "Hold",
                    value: $holdTime,
                    range: 0...30,
                    color: .purple,
                    icon: "pause.circle.fill"
                )
                
                TimingSlider(
                    title: "Exhale",
                    value: $exhaleTime,
                    range: 1...30,
                    color: .green,
                    icon: "arrow.down.circle.fill"
                )
                
                TimingSlider(
                    title: "Pause",
                    value: $pauseTime,
                    range: 0...10,
                    color: .orange,
                    icon: "minus.circle.fill"
                )
            }
        }
    }
    
    // MARK: - Color Scheme Section
    
    private var colorSchemeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Visual Theme")
                .font(.headline)
                .fontWeight(.medium)
            
            Text("Choose colors that resonate with your breathing practice.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(BreathingColorScheme.allCases, id: \.self) { scheme in
                    ColorSchemeOption(
                        scheme: scheme,
                        isSelected: selectedColorScheme == scheme,
                        onTap: { selectedColorScheme = scheme }
                    )
                }
            }
        }
    }
    
    // MARK: - Preview Section
    
    private var previewSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Preview")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button("Full Preview") {
                    showingPreview = true
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            // Mini preview
            VStack(spacing: 16) {
                BreathingOrbPreview(colorScheme: selectedColorScheme)
                    .scaleEffect(1.5)
                
                Text("Total cycle: \(String(format: "%.1f", currentTiming.totalDuration))s")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
    }
    
    // MARK: - Pattern Info Section
    
    private var patternInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pattern Summary")
                .font(.headline)
                .fontWeight(.medium)
            
            VStack(spacing: 8) {
                PatternInfoRow(
                    label: "Inhale",
                    value: "\(String(format: "%.1f", inhaleTime))s",
                    color: .blue
                )
                
                if holdTime > 0 {
                    PatternInfoRow(
                        label: "Hold",
                        value: "\(String(format: "%.1f", holdTime))s",
                        color: .purple
                    )
                }
                
                PatternInfoRow(
                    label: "Exhale",
                    value: "\(String(format: "%.1f", exhaleTime))s",
                    color: .green
                )
                
                if pauseTime > 0 {
                    PatternInfoRow(
                        label: "Pause",
                        value: "\(String(format: "%.1f", pauseTime))s",
                        color: .orange
                    )
                }
                
                Divider()
                
                PatternInfoRow(
                    label: "Total Cycle",
                    value: "\(String(format: "%.1f", currentTiming.totalDuration))s",
                    color: .primary,
                    isHighlighted: true
                )
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
    }
    
    // MARK: - Private Methods
    
    private func savePattern() {
        let trimmedName = patternName.trimmingCharacters(in: .whitespacesAndNewlines)
        onSave(trimmedName, currentTiming, selectedColorScheme)
        dismiss()
    }
}

// MARK: - Supporting Views

struct TimingSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(String(format: "%.1f", value))s")
                    .font(.body.monospacedDigit())
                    .foregroundColor(.secondary)
                    .frame(width: 50, alignment: .trailing)
            }
            
            Slider(value: $value, in: range, step: 0.5)
                .accentColor(color)
        }
    }
}

struct ColorSchemeOption: View {
    let scheme: BreathingColorScheme
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Circle()
                    .fill(ColorSchemeManager.backgroundGradient(for: scheme))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 2)
                    )
                
                Text(scheme.displayName)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PatternInfoRow: View {
    let label: String
    let value: String
    let color: Color
    let isHighlighted: Bool
    
    init(label: String, value: String, color: Color, isHighlighted: Bool = false) {
        self.label = label
        self.value = value
        self.color = color
        self.isHighlighted = isHighlighted
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(isHighlighted ? .body.weight(.medium) : .body)
                .foregroundColor(color)
            
            Spacer()
            
            Text(value)
                .font(isHighlighted ? .body.weight(.medium).monospacedDigit() : .body.monospacedDigit())
                .foregroundColor(isHighlighted ? .primary : .secondary)
        }
    }
}

// MARK: - Pattern Preview View

struct PatternPreviewView: View {
    let timing: BreathingTiming
    let colorScheme: BreathingColorScheme
    
    @Environment(\.dismiss) private var dismiss
    @State private var currentPhase: BreathingPhase = .ready
    @State private var isAnimating = false
    @State private var orbScale: Double = 1.0
    @State private var orbOpacity: Double = 0.8
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorSchemeManager.backgroundGradient(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Text("Pattern Preview")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Text(currentPhase.instruction)
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .animation(.easeInOut(duration: 0.5), value: currentPhase)
                    
                    BreathingOrbView(
                        colorScheme: colorScheme,
                        phase: currentPhase,
                        scale: orbScale,
                        opacity: orbOpacity,
                        particleOffset: .zero
                    )
                    
                    Text("Cycle Duration: \(String(format: "%.1f", timing.totalDuration))s")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Button(isAnimating ? "Stop Preview" : "Start Preview") {
                        if isAnimating {
                            stopPreview()
                        } else {
                            startPreview()
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.white.opacity(0.2))
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onDisappear {
            stopPreview()
        }
    }
    
    private func startPreview() {
        isAnimating = true
        runBreathingCycle()
    }
    
    private func stopPreview() {
        isAnimating = false
        currentPhase = .ready
        orbScale = 1.0
        orbOpacity = 0.8
    }
    
    private func runBreathingCycle() {
        guard isAnimating else { return }
        
        // Inhale phase
        currentPhase = .inhale
        withAnimation(.easeInOut(duration: timing.inhale)) {
            orbScale = 1.4
            orbOpacity = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timing.inhale) {
            guard self.isAnimating else { return }
            
            // Hold phase
            if self.timing.hold > 0 {
                self.currentPhase = .hold
                
                DispatchQueue.main.asyncAfter(deadline: .now() + self.timing.hold) {
                    self.exhalePhase()
                }
            } else {
                self.exhalePhase()
            }
        }
    }
    
    private func exhalePhase() {
        guard isAnimating else { return }
        
        currentPhase = .exhale
        withAnimation(.easeInOut(duration: timing.exhale)) {
            orbScale = 0.8
            orbOpacity = 0.6
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timing.exhale) {
            guard self.isAnimating else { return }
            
            // Pause phase
            if self.timing.pause > 0 {
                self.currentPhase = .pause
                withAnimation(.easeInOut(duration: self.timing.pause)) {
                    self.orbScale = 1.0
                    self.orbOpacity = 0.7
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + self.timing.pause) {
                    self.runBreathingCycle() // Repeat cycle
                }
            } else {
                self.runBreathingCycle() // Repeat cycle
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CustomPatternCreatorView { name, timing, colorScheme in
        print("Saving pattern: \(name), \(timing), \(colorScheme)")
    }
}
