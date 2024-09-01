//
//  User.swift
//  Tracker
//
//  Created by reagan m on 9/1/24.
//

import Foundation
import SwiftData

@Model
final class User {
    var username: String?
    var uuid: Int
    
    init(_ username: String?, _ uuid: Int) {
        self.username = username
        self.uuid = uuid
    }
}
