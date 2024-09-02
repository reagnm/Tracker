//
//  Sidebar3BView.swift
//  Tracker
//
//  Created by Christian Norton on 9/1/24.
//

import Foundation
import SwiftUI

struct SidebarView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ContentView()) {
                    Label("Welcome", systemImage: "star")
                }
                
                Spacer()
                
                Text("DASHBOARD")
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                Group{
                    NavigationLink(destination: ContentView()) {
                        Label("Home", systemImage: "house")
                    }
                    NavigationLink(destination: ContentView()) {
                        Label("Websites", systemImage: "globe")
                    }
                    NavigationLink(destination: ContentView()) {
                        Label("Domains", systemImage: "link")
                    }
                    NavigationLink(destination: ContentView()) {
                        Label("Templates", systemImage: "rectangle.stack")
                    }
                }
                
                Spacer()
                
                Text(
                    NSFullUserName()
                        .split(separator:" ").first
                        .map(String.init) ?? NSUserName()
                )
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                Group {
                    NavigationLink(destination: ContentView()) {
                        Label("My Account", systemImage: "person")
                    }
                    NavigationLink(destination: ContentView()) {
                        Label("Notifications", systemImage: "bell")
                    }
                    NavigationLink(destination: ContentView()) {
                        Label("Settings", systemImage: "gear")
                    }
                }
                
                Spacer()
                
                Divider()
                NavigationLink(destination: ContentView()) {
                    Label("Sign Out", systemImage: "arrow.backward")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Explore")
            .frame(minWidth: 150, idealWidth: 250, maxWidth: 300)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar, label: {
                        Image(systemName: "sidebar.left")
                    })
                }
            }
            
            ContentView()
        }
    }
}

// Toggle Sidebar Function
func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
