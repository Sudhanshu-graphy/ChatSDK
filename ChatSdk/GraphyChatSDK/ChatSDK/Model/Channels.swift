//
//  Channels.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 29/06/21.
//

import Foundation

// MARK: - Channles
struct Channels: Codable {
    let count: Int?
    let results: [ChannelData]?
}

// MARK: - Result
struct ChannelData: Codable {
    let title, slug: String?
    let totalUnreadMessages: Int?
    enum CodingKeys: String, CodingKey {
        case title, slug
        case totalUnreadMessages = "total_unread_messages"
    }
}
