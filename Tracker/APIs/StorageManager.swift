//
//  StorageManager.swift
//  Tracker
//
//  Created by Christian Norton on 9/1/24.
//

import Foundation
import SwiftData
import SwiftUI
import Combine
import CryptoKit

class StorageManager: ObservableObject {
    private let SM = StorageManager.ObjectWillChangePublisher()

        @Published var apiData: Data

        init(_ apiData: Data? = nil) {
            // Initialize apiData with a default value first
            self.apiData = Data()

            // Now call a method to perform the actual initialization
            self.initialize(apiData)
        }
        
        private func initialize(_ apiData: Data?) {
            // Attempt to retrieve the stored data using the key
            if let storedDataString = retrieve(key: "apiDataKey"),
               let storedData = Data(base64Encoded: storedDataString) {
                self.apiData = storedData
            } else {
                // If stored data doesn't exist, use the provided apiData or fallback to an empty Data object
                self.apiData = apiData ?? Data()
                
                // If initializing with the fallback data, store it immediately
                let initialDataString = self.apiData.base64EncodedString()
                store(key: "apiDataKey", value: initialDataString)
            }
        }
        
        private func store(key: String, value: String) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: value.data(using: .utf8)!
            ]
            SecItemAdd(query as CFDictionary, nil)
        }
        
        private func retrieve(key: String) -> String? {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnData as String: kCFBooleanTrue!,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            var item: CFTypeRef?
            if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
                if let data = item as? Data {
                    return String(data: data, encoding: .utf8)
                }
            }
            return nil
        }
        
        func storeSymmetricKey(_ key: SymmetricKey, forKey keyName: String) {
            let keyData = key.withUnsafeBytes { Data(Array($0)) }
            let keyString = keyData.base64EncodedString()
            store(key: keyName, value: keyString)
        }
        
        func retrieveSymmetricKey(forKey keyName: String) -> SymmetricKey? {
            guard let keyString = retrieve(key: keyName),
                  let keyData = Data(base64Encoded: keyString) else {
                return nil
            }
            return SymmetricKey(data: keyData)
        }
    }
