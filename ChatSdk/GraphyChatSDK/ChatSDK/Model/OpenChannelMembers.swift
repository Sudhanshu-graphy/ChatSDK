//
//  OpenChannelMembers.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 17/11/21.
//

import Foundation
import UIKit

// MARK: - OpenChannelMembers
struct OpenChannelMembersResult: Codable {
    let count, offset, limit: Int?
    let results: [OpenChannelMembers]?
}

// MARK: - Result
struct OpenChannelMembers: Codable {
    let uuid: String?
    let userDetails: UserDetails?
    let role: String?

    enum CodingKeys: String, CodingKey {
        case uuid
        case userDetails = "user_details"
        case role
    }
}

// MARK: - UserDetails
struct UserDetails: Codable {
    let uuid, firstName, lastName: String?
    let avatar: String?
    let profileUsername: String?
    let socialAccounts: [SocialAccount]?

    enum CodingKeys: String, CodingKey {
        case uuid
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
        case profileUsername = "profile_username"
        case socialAccounts = "social_accounts"
    }
}

// MARK: - SocialAccount
struct SocialAccount: Codable {
    let platformType: PlatformType?
    let username: String?

    enum CodingKeys: String, CodingKey {
        case platformType = "platform_type"
        case username
    }
    
    enum PlatformType: String, Codable {
        case facebook, instagram, pinterest, linkedin, snapchat, twitter, youtube, website
    }
}
