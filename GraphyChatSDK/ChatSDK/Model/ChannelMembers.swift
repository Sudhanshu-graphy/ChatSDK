//
//  ChannelMembers.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 07/07/21.
//

import Foundation


// MARK: - Element
typealias Members = [ChannelMembers]

struct ChannelMembersRoot: Codable {
    let count, offset, limit: Int?
    let results: [ChannelMembers]?
}

// MARK: - Result
struct ChannelMembers: Codable {
    let uuid: String?
    var userDetails: UserDetails?
    let role: Role?

    enum CodingKeys: String, CodingKey {
        case uuid
        case userDetails = "user_details"
        case role
    }
}

enum Role: String, Codable {
    case learner
    case instructor
}
