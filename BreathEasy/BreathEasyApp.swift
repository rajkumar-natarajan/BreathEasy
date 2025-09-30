//
//  BreathEasyApp.swift
//  BreathEasy
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI
import UserNotifications
import AVFoundation

@main
struct BreathEasyApp: App {
    @State private var dataManager = DataManager.shared
    @State private var isLaunchScreenVisible = true
    
    init() {
        // Configure app on launch
        configureApp()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLaunchScreenVisible {
                    SerenityLaunchScreen(
                        onLaunchComplete: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isLaunchScreenVisible = false
                            }
                        }
                    )
                } else {
                    SerenityContentView()
                        .environment(dataManager)
                        .transition(.opacity)
                        .onAppear {
                            scheduleNotifications()
                        }
                }
            }
        }
    }
    
    private func configureApp() {
        // Initialize data manager to load existing data
        _ = DataManager.shared
        
        // Configure audio session for background compatibility
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    private func scheduleNotifications() {
        let settings = DataManager.shared.settings
        guard settings.enableNotifications else { return }
        
        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.scheduleDailyReminder(at: settings.reminderTime)
            }
        }
    }
    
    private func scheduleDailyReminder(at time: Date) {
        let center = UNUserNotificationCenter.current()
        
        // Remove existing notifications
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Breathe"
        content.body = "Take a moment for mindful breathing and find your center."
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "BREATHING_REMINDER"
        
        // Configure daily trigger
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "daily_breathing_reminder",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
}
