//
//  GutsyApp.swift
//  Gutsy
//
//  Created by Naima Khan on 06/05/2026.
//

import SwiftUI
import SwiftData

@main
struct GutsyApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        .modelContainer(for: MealLog.self)
    }
}
