//
//  Communities.swift
//  Graphy
//
//  Created by Rahul Kumar on 07/04/21.
//

import Foundation

struct Communities: Codable {
    var limit: Int?
    var offset: Int?
    var count: Int?
    var objects: [Community]?

    enum CodingKeys: String, CodingKey {
        case limit
        case offset
        case count
        case objects = "results"
    }
}

struct Community: Codable, Hashable, Identifiable {
    let id = UUID()
    var courseUUID: String?
    var courseTitle: String?
    var communityLink: String?
    var members: CommunityMembers?
    var courseSlug: String?
    var courseEmoji: String?
    enum CodingKeys: String, CodingKey {
        case courseUUID = "course_uuid"
        case courseTitle = "course_title"
        case communityLink = "community_link"
        case courseSlug = "course_slug"
        case members
        case courseEmoji = "course_emoji_unicode"
    }
}

struct CommunityMembers: Codable, Hashable {
    var count: Int?
    var names: [String]?
}

struct CommunitiesSearchResponse: Codable {
    let limit: Int?
    let offset: Int?
    let count: Int?
    
    let results: [School]?
    
    // search term
    let q: String?
}
