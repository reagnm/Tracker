//
//  ContentView.swift
//  Tracker
//
//  Created by reagan m on 9/1/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // ViewModel that manages Users
    @ObservedObject var instaAPI: InstaAPI
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(instaAPI.Users) { user in
                    Text(user.username) // Directly use the username
                }
                .onDelete(perform: instaAPI.deleteUsers)
            }
        } detail: {
            Text("Select a user")
        }
#if os(macOS)
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
        .toolbar {
#if os(iOS)
            ToolbarUser(placement: .navigationBarTrailing) {
                EditButton()
            }
            
            ToolbarUser {
                Button(action: addUser) {
                    Label("Add User", systemImage: "plus")
                }
            }
#endif
            detail: do {
                Text("Select an User")
            }
        }
    }
    
    init(_ instaAPI: InstaAPI) {
        self.instaAPI = instaAPI
    }
}

extension User {
    func toUInt8Array() -> [UInt8] {
        var byteArray: [UInt8] = []
        
        // Convert username to Data and then to [UInt8]
        if let usernameData = username.data(using: .utf8) {
            byteArray.append(contentsOf: usernameData)
        }
        
        // Convert UUID to Data and then to [UInt8] if it exists
        if let uuid = uuid {
            var uuidValue = uuid
            let uuidData = Data(bytes: &uuidValue, count: MemoryLayout<Int>.size)
            byteArray.append(contentsOf: uuidData)
        }
        
        return byteArray
    }
}

extension Array where Element == User {
    func toUInt8Array() -> [UInt8] {
        return self.flatMap { $0.toUInt8Array() }
    }
}

#Preview {
    let users = [User("john_doe", 12345)]
    let instaAPI = InstaAPI(Data(users.toUInt8Array()))
    ContentView(instaAPI)
        .modelContainer(for: User.self, inMemory: true)
}

