//
//  SettingsView.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI
import UserNotifications

/// Settings view for app configuration and preferences
struct SettingsView: View {
    private let dataManager = DataManager.shared
    @State private var settings = DataManager.shared.settings
    @State private var showingNotificationPermissionAlert = false
    @State private var showingHealthKitPermissionAlert = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationStack {
            List {
                // Audio & Haptics Section
                audioHapticsSection
                
                // Visual & Accessibility Section
                visualAccessibilitySection
                
                // Notifications Section
                notificationsSection
                
                // Health Integration Section
                healthIntegrationSection
                
                // Language Section
                languageSection
                
                // Data Management Section
                dataManagementSection
                
                // About Section
                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                settings = dataManager.settings
            }
        }
        .alert("Notification Permission Required", isPresented: $showingNotificationPermissionAlert) {
            Button("Go to Settings") {
                openSystemSettings()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enable notifications for BreathEasy in Settings to receive daily reminders.")
        }
        .alert("HealthKit Permission Required", isPresented: $showingHealthKitPermissionAlert) {
            Button("Grant Permission") {
                requestHealthKitPermission()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("BreathEasy would like to export your breathing session data to the Health app.")
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
    
    // MARK: - Sections
    
    private var audioHapticsSection: some View {
        Section {
            Toggle("Sound Cues", isOn: $settings.enableSoundCues)
            
            Toggle("Haptic Feedback", isOn: $settings.enableHaptics)
            
            if settings.enableHaptics {
                Picker("Haptic Intensity", selection: $settings.hapticIntensity) {
                    ForEach(AppSettings.HapticIntensity.allCases, id: \.self) { intensity in
                        Text(intensity.displayName).tag(intensity)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        } header: {
            Text("Audio & Haptics")
        }
        .onChange(of: settings.enableSoundCues) { _, _ in
            dataManager.updateSettings(settings)
        }
        .onChange(of: settings.enableHaptics) { _, _ in
            dataManager.updateSettings(settings)
        }
        .onChange(of: settings.hapticIntensity) { _, _ in
            dataManager.updateSettings(settings)
        }
    }
    
    private var visualAccessibilitySection: some View {
        Section {
            Picker("Color Theme", selection: $settings.colorScheme) {
                ForEach(BreathingColorScheme.allCases, id: \.self) { scheme in
                    HStack {
                        Circle()
                            .fill(ColorSchemeManager.primaryColor(for: scheme))
                            .frame(width: 16, height: 16)
                        Text(scheme.displayName)
                    }
                    .tag(scheme)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Toggle("Reduce Motion", isOn: $settings.enableReducedMotion)
            
            Toggle("High Contrast", isOn: $settings.enableHighContrast)
        } header: {
            Text("Visual & Accessibility")
        } footer: {
            Text("Accessibility options help make breathing exercises more comfortable for everyone.")
        }
        .onChange(of: settings.colorScheme) { _, _ in
            dataManager.updateSettings(settings)
        }
        .onChange(of: settings.enableReducedMotion) { _, _ in
            dataManager.updateSettings(settings)
        }
        .onChange(of: settings.enableHighContrast) { _, _ in
            dataManager.updateSettings(settings)
        }
    }
    
    private var notificationsSection: some View {
        Section {
            Toggle("Daily Reminders", isOn: $settings.enableNotifications)
                .onChange(of: settings.enableNotifications) { oldValue, newValue in
                    if newValue {
                        requestNotificationPermission()
                    }
                    dataManager.updateSettings(settings)
                }
            
            if settings.enableNotifications {
                DatePicker(
                    "Reminder Time",
                    selection: $settings.reminderTime,
                    displayedComponents: .hourAndMinute
                )
                .onChange(of: settings.reminderTime) { _, _ in
                    dataManager.updateSettings(settings)
                }
            }
        } header: {
            Text("Reminders")
        } footer: {
            Text("Get gentle reminders to practice breathing exercises daily.")
        }
    }
    
    private var healthIntegrationSection: some View {
        Section {
            Toggle("Export to Health", isOn: $settings.enableHealthKitExport)
                .onChange(of: settings.enableHealthKitExport) { oldValue, newValue in
                    if newValue {
                        requestHealthKitPermission()
                    }
                    dataManager.updateSettings(settings)
                }
            
            NavigationLink("Health Data Details") {
                HealthDataView()
            }
        } header: {
            Text("Health Integration")
        } footer: {
            Text("Export breathing session data to Apple Health for comprehensive wellness tracking.")
        }
    }
    
    private var languageSection: some View {
        Section {
            Picker("Language", selection: $settings.preferredLanguage) {
                ForEach(AppSettings.AppLanguage.allCases, id: \.self) { language in
                    Text(language.displayName).tag(language)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: settings.preferredLanguage) { _, _ in
                dataManager.updateSettings(settings)
            }
        } header: {
            Text("Language")
        }
    }
    
    private var dataManagementSection: some View {
        Section {
            NavigationLink {
                DataExportView()
            } label: {
                Label("Export Data", systemImage: "square.and.arrow.up")
            }
            
            NavigationLink {
                DataPrivacyView()
            } label: {
                Label("Privacy Policy", systemImage: "lock.shield")
            }
            
            Button {
                clearAllData()
            } label: {
                Label("Clear All Data", systemImage: "trash")
                    .foregroundColor(.red)
            }
        } header: {
            Text("Data Management")
        }
    }
    
    private var aboutSection: some View {
        Section {
            Button {
                showingAbout = true
            } label: {
                Label("About BreathEasy", systemImage: "info.circle")
            }
            
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundColor(.secondary)
            }
        } header: {
            Text("About")
        }
    }
    
    // MARK: - Helper Methods
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if !granted {
                    settings.enableNotifications = false
                    showingNotificationPermissionAlert = true
                }
                dataManager.updateSettings(settings)
            }
        }
    }
    
    private func requestHealthKitPermission() {
        // HealthKit permission logic would go here
        // For now, just update the settings
        dataManager.updateSettings(settings)
    }
    
    private func openSystemSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func clearAllData() {
        dataManager.clearAllData()
    }
}

// MARK: - Supporting Views

struct DataExportView: View {
    var body: some View {
        Text("Data Export functionality would be implemented here")
            .navigationTitle("Export Data")
    }
}

struct DataPrivacyView: View {
    var body: some View {
        Text("Privacy Policy content would be implemented here")
            .navigationTitle("Privacy Policy")
    }
}

struct HealthDataView: View {
    var body: some View {
        Text("Health Data details would be implemented here")
            .navigationTitle("Health Data")
    }
}

struct AboutView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("BreathEasy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your personal breathing companion")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text("Version 1.0.0")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
