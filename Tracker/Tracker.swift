//
//  TrackerApp.swift
//  Tracker
//
//  Created by reagan m on 9/1/24.
//

import SwiftUI
import SwiftData
import SwiftUIHidden
import CryptoKit

@main
struct TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            SidebarView()
//            ContentView().modelContainer(for: [TrackedUser.self, User.self])
        }
    }
}
