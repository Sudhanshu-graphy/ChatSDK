//
//  MessageVM.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 06/07/21.
//

import Foundation

class MessageVM {
    
    private var messageData: ChannelMessagesData
    internal var reloadTableView: (() -> Void)?
    private let socketHelper = SocketHelper.shared
    private var channelUUID: String = ""
    
    init(data: ChannelMessagesData, channelUUID: String) {
        self.channelUUID = channelUUID
        self.messageData = data
        NotificationCenter.default.addObserver(self, selector: #selector(emojiEventReceived(notification:)),
                                               name: .emojiEventReceived,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    internal var numberOfItem: Int {
        return 1
    }
    
    internal func getCellViewModel(at indexPath: IndexPath) -> ChannelMessagesData {
        return messageData
    }
    
    internal var messageUUID: String {
        return messageData.uuid ?? ""
    }
    
    internal func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: .emojiEventReceived, object: nil)
    }
}


// MARK: SocketHelperDelegate
extension MessageVM {
    @objc private func emojiEventReceived(notification: NSNotification) {
        if let socketEvent = notification.userInfo?["socketEvent"] as? Reaction {
            if socketEvent.channelUUID == self.channelUUID {
                if socketEvent.messageUUID == messageData.uuid {
                    if let firstIndex =  messageData.reactions?.firstIndex(where: {$0.user?.uuid == socketEvent.user?.uuid && $0.unicode == socketEvent.unicode}) {
                        messageData.reactions?.remove(at: firstIndex)
                    } else {
                        messageData.reactions?.append(socketEvent)
                    }
                    self.reloadTableView?()
                }
            }
        }
    }
}
