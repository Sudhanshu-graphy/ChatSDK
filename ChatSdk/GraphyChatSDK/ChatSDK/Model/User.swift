//
//  User.swift
//  Graphy
//
//  Created by Rahul Kumar on 22/03/21.
//

import Foundation
import UIKit

enum UserRole: String, Codable {
    case learner
    case instructor
}

struct Token: Codable {
    var access: String?
    var refresh: String?
}

final class User: Codable, ObservableObject {
    var UUID, email, avatar, name, firstName, lastName, profileUsername: String?
    var token: Token?
    var school: School?
    var profileImage: UIImage?
    var isConsentRequired: Bool?
    
    enum CodingKeys: String, CodingKey {
        case UUID = "uuid"
        case email, avatar, name
        case token = "tokens"
        case school = "school_details"
        case firstName = "first_name"
        case lastName = "last_name"
        case isConsentRequired = "is_consent_required"
        case profileUsername = "profile_username"
    }
}
