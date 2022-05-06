//
//  MessageEmojiVM.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 05/07/21.
//

import Foundation

class MessageEmojiVM {
    
    internal var emojiData = [[Reaction]]()
    private let socketHelper = SocketHelper.shared

    init(data: [Reaction]) {
        self.setupEmojiData(data: data)
    }
    
    private func setupEmojiData(data: [Reaction]) {
        let dic = Dictionary(grouping: data, by: { $0.emojiName ?? "" })
        let sortedKeys = dic.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = dic[key]
            emojiData.append(values ?? [])
        }
    }
    
    internal var numberOfItems: Int {
        return emojiData.count
    }
    
    internal func getCellViewModel(at indexPath: IndexPath) -> [Reaction] {
        return emojiData[indexPath.item]
    }
    
    internal func isToShowAddEmoji(at indexPath: IndexPath) -> Bool {
        if indexPath.item == emojiData.count {
            return true
        }
        return false
    }
    
    internal func sendEmoji(emojiName: String, messageUUID: String, unicode: String) {
        socketHelper.sendEmoji(event: .SEND_REACTION, emojiName: "\(emojiName)", messageUUID: messageUUID, unicode: unicode)
    }
    
    internal func getEmojiData() -> [[Reaction]] {
        return emojiData
    }
    
    internal func getAllUsername(at indexPath: IndexPath) -> String {
        var userName = [String]()
        let data = emojiData[indexPath.item]
        for index in 0...data.count - 1 {
            let firstName = data[index].user?.firstName ?? ""
            let secondName = data[index].user?.lastName ?? ""
            let fullName = firstName + " " + secondName
            if !fullName.isEmpty {
                userName.append(fullName)
            }
        }
        return userName.joined(separator: ", ")
    }
}
