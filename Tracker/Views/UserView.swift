//
//  UserView.swift
//  Tracker
//
//  Created by Christian Norton on 9/1/24.
//

import Foundation
import SwiftUI
import SwiftData
import Swiftagram

struct UserView: View {
    var user: User
    
    var body: some View {
        HStack {
            ForEach([user.username], id: \.self) { attribute in
                Text(attribute)
            }
        }
    }
    
    init(_ user: User) {
        self.user = user
    }
}
