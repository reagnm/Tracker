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
                ForEach(Users) { User in
                    NavigationLink {
                        Text("User at \(User.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(User.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
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

    private func addUser() {
        withAnimation {
            let newUser = User(timestamp: Date())
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
