//
//  ContentView.swift
//  Tracker
//
//  Created by reagan m on 9/1/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var Users: [User]
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(Users) { user in
                    Text(user.username)
                }
                .onDelete(perform: deleteUsers)
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
        }
    } detail: {
        Text("Select an User")
    }
}

private func addUser(_ username: String, _ uuid: Int?) {
    withAnimation {
        let newUser = User(username, uuid)
        modelContext.insert(newUser)
    }
}

private func deleteUsers(offsets: IndexSet) {
    withAnimation {
        for index in offsets {
            modelContext.delete(Users[index])
        }
    }
}
}

#Preview {
    ContentView()
        .modelContainer(for: User.self, inMemory: true)
}
