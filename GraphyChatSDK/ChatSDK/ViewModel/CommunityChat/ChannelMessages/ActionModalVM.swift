//
//  ActionModalVM.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 05/07/21.
//

import Foundation

class ActionModalVM {
    
    internal var messageActionData = [ChatMessageActions]()
    private var showDeleteMessageAction: Bool = false
    public var panmodalHeight = 140.0
    internal func setupData(isFromThread: Bool = false, communityType: CommunityType) {
        
        if isFromThread {
            setupThreadActionData()
        } else {
            panmodalHeight = 200.0
            setupMessagesActionData()
            
            // Check for delete message Action
            if communityType == .school && AppUtil.isInstructor() {
                panmodalHeight += 60.0
                messageActionData.append(ChatMessageActions(image: AppAssets.deleteMessageIcon, action: "Delete message"))
            }
        }
    }
    
    private func setupMessagesActionData() {
        messageActionData = [
            ChatMessageActions(image: AppAssets.replyThreadIcon, action: "Reply in thread"),
            ChatMessageActions(image: AppAssets.copyTextIcon, action: "Copy text")
//            ChatMessageActions(image: R.image.copyLinkIcon(), action: "Copy link to message")
        ]
    }
    
    private func setupThreadActionData(showDeleteMessageAction: Bool = false) {
        messageActionData = [
            ChatMessageActions(image: AppAssets.copyTextIcon, action: "Copy text")
        ]
    }
    
    var numberOfRows: Int {
        return messageActionData.count
    }
    
    internal func getCellViewModel(at indexPath: IndexPath) -> ChatMessageActions {
        return messageActionData[indexPath.item]
    }
}
