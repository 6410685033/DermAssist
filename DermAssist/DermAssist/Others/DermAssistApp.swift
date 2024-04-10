//
//  DermAssistApp.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import SwiftUI
import FirebaseCore


@main
struct DermAssistApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
