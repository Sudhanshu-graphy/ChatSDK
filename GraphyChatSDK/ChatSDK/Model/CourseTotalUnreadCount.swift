//
//  CourseTotalUnreadCount.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 19/10/21.
//

import Foundation

// MARK: - CourseTotalUnread
struct CourseTotalUnreadCount: Codable {
    let results: [UnreadCount]?
}

// MARK: - Result
struct UnreadCount: Codable {
    let slug: String?
    let totalUnreadMessages: Int?

    enum CodingKeys: String, CodingKey {
        case slug
        case totalUnreadMessages = "total_unread_messages"
    }
}
