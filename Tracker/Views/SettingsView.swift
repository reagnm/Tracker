//
//  SettingsView.swift
//  Tracker
//
//  Created by Christian Norton on 9/1/24.
//

import Foundation
import SwiftUI
import Setting
import Swiftagram
import SwiftUIHidden

struct SettingsView: View {
#if os(macOS)
    @available(macOS 11.0, *)
    @Environment(\.openSettings) var openSettings
    @Environment(\.modelContext) var modelContext
    @State private(set) var isOn: Bool = false
    @Binding var showingSettings: Bool
    @State private var isHovered: Bool = false
    
    var body: some View {
        Button(action: {
            showingSettings.toggle()
        }) {
            Label("", systemImage: "gearshape")
                .labelStyle(IconOnlyLabelStyle())
                .frame(width: 50, height: 50)
                .background(HoverEffectView())
                .scaleEffect(1.5)
                .rotationEffect(.degrees(isHovered ? 360 : 0))
                .animation(.linear(duration: 0.6), value: isHovered)
                .onHover { hovering in
                    isHovered = hovering
                }
        }
    }
    init() {
        _showingSettings = Binding.constant(false)
    }
#else
    
    var body: some View {
        @AppStorageCodable(wrappedValue: [], "AccountSecret") var AccountSecret: [Secret]?
        
        SettingStack {
            SettingPage(title: "Preferences") {
                SettingGroup(header: NSFullUserName().split(separator:" ").first.map(String.init)) {
                    SettingPage(title: "Account") {
                        SettingToggle(title: "Connected", isOn: $isOn)
                    }
                    .previewIcon("person.crop.circle")
                }
            }
        }
    }
#endif
}

@propertyWrapper
struct AppStorageCodable<T: Codable> {
    private let key: String
    private let storage: UserDefaults
    
    init(wrappedValue: T?, _ key: String, store: UserDefaults = .standard) {
        self.key = key
        self.storage = store
        self.wrappedValue = wrappedValue
    }
    
    var wrappedValue: T? {
        get {
            guard let data = storage.data(forKey: key) else { return nil }
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value
        }
        set {
            if let newValue = newValue {
                let data = try? JSONEncoder().encode(newValue)
                storage.set(data, forKey: key)
            } else {
                storage.removeObject(forKey: key)
            }
        }
    }
}

struct HoverEffectView: View {
    @State private var isHovered = false
    
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .overlay(
                isHovered ? Text("").foregroundColor(.primary) : nil
            )
            .onHover { hovering in
                withAnimation {
                    isHovered = hovering
                }
            }
    }
}

struct MovingDashPhaseButton: View {
    @State private var isMovingAround = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 27)
            .frame(width: 160, height: 54)
            .foregroundStyle(.indigo.gradient)
        RoundedRectangle(cornerRadius: 27)
            .strokeBorder(
                style: StrokeStyle(
                    lineWidth: 4,
                    lineCap: .round,
                    lineJoin: .round,
                    dash: [40,400],
                    dashPhase: isMovingAround ? 220 : -220
                )
            )
            .frame(width: 160, height:54)
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(
                        colors: [.indigo, .white, .purple, .mint, .white, .orange, .indigo]
                    ),
                    startPoint: .trailing,
                    endPoint: .leading
                )
            )
    }
}
