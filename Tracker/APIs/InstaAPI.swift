//
//  File.swift
//  Tracker
//
//  Created by reagan m on 9/1/24.
//

import Foundation
import Swiftagram
import SwiftUI
import SwiftData
import CryptoKit

@MainActor
final class InstaAPI: ObservableObject {
    @Environment(\.modelContext) var modelContext
    @ObservedObject var storageManager = StorageManager()
    @Published private var userData: Data?
    @Query(sort: \User.username) var usernames: [User]
    
    private let symmetricKeyName = "symmetricEncryptionKey"
    private var encryptionKey: SymmetricKey

    init() {
        // Initialize the encryptionKey with a placeholder value
        encryptionKey = SymmetricKey(size: .bits256) // Temporary placeholder
        
        // After initializing, set up the encryptionKey properly
        configureEncryptionKey()
    }
    
    private func configureEncryptionKey() {
        if let existingKey = storageManager.retrieveSymmetricKey(forKey: symmetricKeyName) {
            encryptionKey = existingKey
        } else {
            encryptionKey = SymmetricKey(size: .bits256)
            storageManager.storeSymmetricKey(encryptionKey, forKey: symmetricKeyName)
        }
    }

    func getSymmetricKey() -> SymmetricKey? {
        return encryptionKey
    }

    var Users: [User] {
        get {
            guard let userData = userData else { return [] }
            guard let decryptedData = try? decrypt(data: userData) else { return [] }
            if let decodedMirrorUsers = try? JSONDecoder().decode([MirrorUser].self, from: decryptedData) {
                return decodedMirrorUsers.map { $0.toUser() }
            }
            return []
        }
        set {
            let mirrorUsers = newValue.map { MirrorUser(username: $0.username, uuid: $0.uuid) }
            do {
                let encodedData = try JSONEncoder().encode(mirrorUsers)
                let encryptedData = try encrypt(data: encodedData)
                userData = encryptedData
            } catch {
                print("Failed to encode and encrypt users: \(error)")
            }
        }
    }
    
    func decrypt(data: Data) -> Data? {
        guard let key = getSymmetricKey() else {
            print("Symmetric key not available")
            return nil
        }
        
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return decryptedData
        } catch {
            print("Decryption failed: \(error)")
            return nil
        }
    }
    
    func encrypt(data: Data) -> Data {
        guard let key = getSymmetricKey() else {
            fatalError("Symmetric key not available")
        }
        
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined!
        } catch {
            fatalError("Encryption failed: \(error)")
        }
    }

    func deleteUsers(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(Users[index])
                Users.remove(at: index)
            }
        }
    }
}
