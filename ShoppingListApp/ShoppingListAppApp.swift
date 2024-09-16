//
//  ShoppingListAppApp.swift
//  ShoppingListApp
//
//  Created by Anıl on 16.09.2024.
//

import SwiftUI

@main
struct ShoppingListAppApp: App {
    init() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("Notification permission granted.")
                } else if let error = error {
                    print("Notification permission denied: \(error.localizedDescription)")
                }
            }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
