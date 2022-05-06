//
//  EmojiCategory.swift
//  ISEmojiView
//
//  Created by Beniamin Sarkisyan on 01/08/2018.
//

import Foundation

public class EmojiCategorys {
    
    // MARK: - Public variables
    
    var category: Category!
    var emojis: [Emojis]!
    
    // MARK: - Initial functions
    
    public init(category: Category, emojis: [Emojis]) {
        self.category = category
        self.emojis = emojis
    }
    
}
