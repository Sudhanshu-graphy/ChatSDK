//
//  OpenChannelInvitation.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 12/11/21.
//

import Foundation

// MARK: - OpenChannelInvitation
struct OpenChannelInvitation: Codable {
    let modal: InvitationModal?
    let learners: [Learner]?
    let count: Int?
    
    enum InvitationModal: String, Codable {
        case show
        case hidden
    }
}

// MARK: - Learner
struct Learner: Codable {
    let uuid, firstName, lastName, avatar: String?

    enum CodingKeys: String, CodingKey {
        case uuid
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}
