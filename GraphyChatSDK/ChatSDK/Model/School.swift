//
//  School.swift
//  Graphy
//
//  Created by Rahul Kumar on 22/02/21.
//

import Foundation
import UIKit

enum SchoolOwnership: String, Codable, CaseIterable {
    case individual
    case organization
    
    var description: String {
        switch self {
        case .individual:
            return "I’m an individual creator looking to start my online school with Graphy"
        case .organization:
            return "We are a group looking to start our online school with Graphy"
        }
    }
}

struct School: Codable, Hashable {
    var UUID: String?
    var subdomain: String
    var title: String?
    var bio: String?
    var cover: String?
    var email: String?
    var ownership: SchoolOwnership?
    var topics: [String]?
    var country: String?
    var isPaymentEnabled: Bool?
    var userRoles: [UserRole]?
    var isCommunityEnabled: Bool?
    var isOpenCommunityEnabled: Bool?
    var totalLearners: String?
    enum CodingKeys: String, CodingKey {
        case UUID = "uuid"
        case subdomain
        case email
        case title
        case bio
        case ownership
        case topics
        case country
        case isPaymentEnabled = "is_payment_enabled"
        case userRoles = "roles"
        case cover
        case isCommunityEnabled = "is_community_enabled"
        case isOpenCommunityEnabled = "is_open_community_enabled"
        case totalLearners = "total_learners"
    }
}

struct SchoolSubdomainAvailable: Codable {
    var isAvailable: Bool?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case isAvailable = "is_available"
        case message
    }
}

struct Schools: Codable {
    var count: Int?
    var offset: Int?
    var limit: Int?
    var list: [School]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case offset
        case limit
        case list = "results"
    }
}

final class SchoolDetails: Codable, ObservableObject {
    var title: String?
    var bio: String?
    var ownership: SchoolOwnership?
    var displayImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case title
        case bio
        case ownership
    }
}
