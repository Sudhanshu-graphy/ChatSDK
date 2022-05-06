//
//  ChannelDetails.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 29/06/21.
//

import Foundation

// MARK: - ChannelDetails
struct ChannelDetails: Codable {
    let id: Int?
    let uuid, title, slug: String?
    let totalMessageCount, canPost: Int?
    let channelDetailsDescription, entityExternalUUID, workspaceExternalUUID, createdAt: String?
    let totalMembers: Int?

    enum CodingKeys: String, CodingKey {
        case id, uuid, title, slug
        case totalMessageCount = "total_message_count"
        case channelDetailsDescription = "description"
        case entityExternalUUID = "entity_external_uuid"
        case workspaceExternalUUID = "workspace_external_uuid"
        case totalMembers = "total_members"
        case createdAt = "created_at"
        case canPost = "can_post"
    }
}
