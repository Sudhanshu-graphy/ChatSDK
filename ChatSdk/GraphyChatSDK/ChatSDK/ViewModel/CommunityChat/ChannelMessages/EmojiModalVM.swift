//
//  EmojiModalVM.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 05/07/21.
//

import Foundation

class EmojiModalVM {
    
    internal var emojiData = [EmojiData]()
    private let socketHelper = SocketHelper.shared

    init() {
        setupEmojiData()
    }
    
    private func setupEmojiData() {
        emojiData = [
            EmojiData(emoji: "👍", image: AppAssets.thumbsUpEmoji),
            EmojiData(emoji: "🔥", image: AppAssets.fireEmoji),
            EmojiData(emoji: "😂", image: AppAssets.joyEmoji),
            EmojiData(emoji: "😁", image: AppAssets.smileEmoji),
            EmojiData(emoji: "🙌", image: AppAssets.raisedHandEmoji),
            EmojiData(emoji: "", image: AppAssets.addEmojiIcon)
        ]
    }
    
    var numberOfItems: Int {
        return emojiData.count
    }
    
    internal func getCellViewModel(at indexPath: IndexPath) -> EmojiData {
        return emojiData[indexPath.item]
    }
    
    internal func sendEmoji(emojiName: String, messageUUID: String, unicode: String) {
        socketHelper.sendEmoji(event: .SEND_REACTION, emojiName: ":\(emojiName):",
                               messageUUID: messageUUID, unicode: unicode)
    }
}
