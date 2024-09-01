//
//  Sidebar3BView.swift
//  Tracker
//
//  Created by Christian Norton on 9/1/24.
//

import Foundation
import SwiftUI

struct Sidebar3BView: View {
    @Binding var showingSettings: Bool
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                Spacer()
                NavigationLink(destination: SettingsView()) {
                    Label("Preferences", systemImage: "person.crop.circle")
                }
                .padding(.bottom, 10)
                .frame(width: 100)
                .background(Color.clear)
                .padding(.top, 50)
                #if(ios)
                .fullScreenCover(isPresented: $showingSettings) {
                    SettingsView()
                }
                #endif
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(8)
            .padding()
            .background(Color.white)
            .ignoresSafeArea()
        }
    }
}
