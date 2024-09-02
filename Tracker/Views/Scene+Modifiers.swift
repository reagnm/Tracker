//
//  Scene+Modifiers.swift
//  Tracker
//
//  Created by Christian Norton on 9/1/24.
//

import Foundation
import SwiftUI
import SwiftUIHidden
import Swiftagram

public struct HiddenSceneModifier<S: Scene> {
    
    // Property to hold the scene
    private let scene: S

    // Public initializer
    public init(scene: S) {
        self.scene = scene
    }
    
    // Method to apply a blurred background using a ShapeStyle (Material)
    @available(iOS, unavailable)
    public func windowBackground(_ shape: some ShapeStyle) -> some Scene {
        // Assuming you want to return the scene with the background applied
        return scene // Adjust this line based on your application logic
    }

    @available(iOS, unavailable)
    public func defaultVisibility(_ visibility: Visibility) -> some Scene {
        return scene // Adjust this line based on your application logic
    }

    @available(iOS, unavailable)
    public func windowShouldClose(_ perform: @escaping () -> Bool) -> some Scene {
        return scene // Adjust this line based on your application logic
    }
}

#if canImport(AppKit)
    // Provide a more flexible function that works with HiddenSceneModifier
public func WindowType<S: Scene>(_ material: Material, content: () -> S) -> some Scene {
    HiddenSceneModifier(scene: content())
        .windowBackground(material)
}
#endif

extension Text {
    /// Combine a collection of texts.
    ///
    /// - parameters: A collection of `Text`s.
    /// - returns: A valid `Text`.
    static func combine(_ texts: Text...) -> Text {
        combine(texts)
    }

    /// Combine a collection of texts.
    ///
    /// - parameters: A collection of `Text`s.
    /// - returns: A valid `Text`.
    static func combine(_ texts: [Text]) -> Text {
        guard let first = texts.first else {
            fatalError("`texts` should not be empty")
        }
        return texts.dropFirst().reduce(first) { $0+$1 }
    }
}

extension User {
    var userName: String {
        return self.username
    }
    
    var userUUID: Int? {
        return self.uuid
    }
}

extension Secret {
    /// Compute the token.
    var token: String? { try? JSONEncoder().encode(self).base64EncodedString() }
}

extension String {
    var toUInt8: UInt8 {
        return self.utf8.first ?? 0
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
