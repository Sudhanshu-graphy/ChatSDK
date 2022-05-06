//
//  OpenChannels.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 29/10/21.
//

import Foundation

// MARK: - OpenChannelResult
struct OpenChannelsResult: Codable {
    let count: Int?
    let results: [OpenChannelData]?
}

// MARK: - Result
struct OpenChannelData: Codable {
    let uuid, title, slug: String?
    let totalUnreadMessages, canPost: Int?
    let visited: Bool?
    var userDetails: OpenChannelUserDetails?

    enum CodingKeys: String, CodingKey {
        case uuid, title, slug
        case totalUnreadMessages = "total_unread_messages"
        case canPost = "can_post"
        case visited, userDetails
    }
}

struct OpenChannelUserDetails: Codable {
    let user: ChannelUser?
    let message: String?
    let metadata: Metadata?
    let mentions: Mentions?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case user, message, metadata, mentions
        case createdAt = "created_at"
    }
}
