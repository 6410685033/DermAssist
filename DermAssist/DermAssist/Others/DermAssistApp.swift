//
//  DermAssistApp.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import SwiftUI
import FirebaseCore
import FirebaseAnalytics

@main
struct DermAssistApp: App {
    init() {
        FirebaseApp.configure()
        FirebaseAnalytics.Analytics.setAnalyticsCollectionEnabled(true)
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
