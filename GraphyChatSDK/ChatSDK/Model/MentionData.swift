//
//  mentionData.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 05/08/21.
//

import Foundation

// MARK: - MentionUserElement
public struct MentionUserData: Codable {
    let uuid, firstName, lastName, externalUUID: String?
    let avatar: String?
    let isEducator: Int?

    enum CodingKeys: String, CodingKey {
        case uuid
        case firstName = "first_name"
        case lastName = "last_name"
        case externalUUID = "external_uuid"
        case isEducator = "is_educator"
        case avatar
    }
}

typealias MentionUser = [MentionUserData]
