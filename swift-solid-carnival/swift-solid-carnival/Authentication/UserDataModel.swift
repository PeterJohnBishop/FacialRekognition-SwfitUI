//
//  UserDataModel.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/7/24.
//

import Foundation
import SwiftData

@Model
final class UserData: Codable, Equatable {
    
    var displayName: String
    var email: String
    var profileImg: String
    
    init(displayName: String = "", email: String = "", profileImg: String = "") {
        self.displayName = displayName
        self.email = email
        self.profileImg = profileImg
    }
    
    // Decodable conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try container.decode(String.self, forKey: .displayName)
        email = try container.decode(String.self, forKey: .email)
        profileImg = try container.decode(String.self, forKey: .profileImg)
    }
    
    // Encodable conformance
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(email, forKey: .email)
        try container.encode(profileImg, forKey: .profileImg)
    }
    
    // CodingKeys for encoding and decoding
    private enum CodingKeys: String, CodingKey {
        case displayName
        case email
        case profileImg
    }
    
    // Equatable conformance
    static func == (lhs: UserData, rhs: UserData) -> Bool {
        return lhs.displayName == rhs.displayName &&
               lhs.email == rhs.email &&
               lhs.profileImg == rhs.profileImg
    }
}

