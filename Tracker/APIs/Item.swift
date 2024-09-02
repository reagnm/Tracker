//
//  User.swift
//  Tracker
//
//  Created by reagan m on 9/1/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class TrackedUser {
    @Attribute(.unique) var id: Int? {
        username.hashValue
    }
    var username: String
    var uuid: Int?
    var pfpImg: Data?
    
    init(username: String, uuid: Int? = nil, pfpImg: Data?) {
        self.username = username
        self.uuid = uuid
        self.pfpImg = pfpImg
    }
}

extension TrackedUser {
    subscript(key: String) -> Any? {
        switch key.lowercased() {
        case "username":
            return self.username
        case "uuid":
            return self.uuid
        case "pfpimg":
            return self.pfpImg
        default:
            return nil
        }
    }
}

@Model
class User {
    @Attribute(.unique) var username: String
    var uuid: Int?
    
    init(_ username: String, _ uuid: Int?) {
        self.username = username
        self.uuid = uuid
    }
}

struct MirrorUser: Identifiable, Codable {
    var id: Int {
        return uuid ?? -1
    }
    var username: String
    var uuid: Int?

    init(username: String, uuid: Int? = nil) {
        self.username = username
        self.uuid = uuid
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.uuid = try container.decodeIfPresent(Int.self, forKey: .uuid)
    }

    func toUser() -> User {
        return User(username,id)
    }

    enum CodingKeys: String, CodingKey {
        case username
        case uuid
    }
}
