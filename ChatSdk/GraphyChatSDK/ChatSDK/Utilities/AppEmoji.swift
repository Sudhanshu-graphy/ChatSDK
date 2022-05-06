//
//  AppEmoji.swift
//  Graphy
//
//  Created by Raj Dhakate on 24/08/21.
//

import Foundation

enum AppEmoji {
    static let defaultEmojiUnicode = "1F30E"
    
    static var defaultEmojiString: String {
        defaultEmojiUnicode.unicodeToEmoji()
    }
}
