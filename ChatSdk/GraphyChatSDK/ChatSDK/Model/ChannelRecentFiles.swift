//
//  RecentFiles.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 07/07/21.
//

import Foundation

// MARK: - ChannelRecentFiles
struct ChannelRecentFiles: Codable {
    let count: Int?
    let results: [FilesData]?
}

// MARK: - Result
struct FilesData: Codable {
    let uuid: String?
    let type: FileType?
    let createdAt: String?
    let url: String?
    let title: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case uuid, type
        case createdAt = "created_at"
        case url, title, user
    }
}
