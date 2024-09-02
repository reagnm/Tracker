//
//  ContentView.swift
//  Tracker
//
//  Created by reagan m on 9/1/24.
//

import SwiftUI
import SwiftData
import SwiftUIHidden

struct ContentView: View {
    @ObservedObject var instaAPI: InstaAPI
    @Environment(\.modelContext) var modelContext
    @State var selectedUserID: String? = nil
    @State public var showingSettings = false
    
    
    var body: some View {
        NavigationSplitView {
            List(instaAPI.usernames, id: \.id) { username in
                Text(username.username)
            }.environment(\.modelContext, modelContext)
        } detail: {
            if let selectedUser = instaAPI.Users.first {
                UserView(selectedUser).environment(\.modelContext, modelContext)
                Text("Select a user to view details")
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environment(\.modelContext, modelContext)
        }
    }
    
    init(_ instaAPI: InstaAPI? = nil) {
        self.instaAPI = instaAPI ?? InstaAPI()
        }
}

#Preview {
    let users = [User("john_doe", 12345)]
    let instaAPI = InstaAPI()
    ContentView(instaAPI)
        .modelContainer(for: User.self, inMemory: true)
}

