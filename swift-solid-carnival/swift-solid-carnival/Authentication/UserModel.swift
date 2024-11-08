//
//  UserModel.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/3/24.
//

import Foundation

struct UserModel: Codable, Equatable {
    var uid: String?
    var email: String
    var password: String?

    private enum CodingKeys: String, CodingKey {
        case uid
        case email
        case password
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decodeIfPresent(String.self, forKey: .uid)
        email = try container.decode(String.self, forKey: .email)
        password = try container.decodeIfPresent(String.self, forKey: .password)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
    }
    
    init(uid: String = "", email: String = "", password: String = "") {
        self.uid = uid
        self.email = email
        self.password = password
    }
}
