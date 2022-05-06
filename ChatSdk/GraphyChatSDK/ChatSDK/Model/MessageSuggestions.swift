//
//  MessageSuggestions.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 11/10/21.
//

import Foundation

// MARK: - MessageSuggestions
struct MessageSuggestions: Codable {
    let suggestions: [String]?
    let userActive: Bool?

    enum CodingKeys: String, CodingKey {
        case userActive = "user_active"
        case suggestions
    }
}
