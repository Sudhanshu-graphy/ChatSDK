//
//  MessageReplies.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 02/07/21.
//

import Foundation
import ImageScout
import UIKit

class MessagesRepliesVM {
    
    private var repliesMessages = [ChannelMessagesData]()
    internal var reloadTableView: (() -> Void)?
    internal var firstreloadTableView: (() -> Void)?
    internal var showError: ((String) -> Void)?
    internal var showLoading: (() -> Void)?
    internal var hideLoading: (() -> Void)?
    internal var performBatchUpdate: (() -> Void)?
    internal var scrollToBottom: (() -> Void)?
    private let socketHelper = SocketHelper.shared
    private var channelUUID: String = ""
    private let imageFetcher = ImageScout()

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(socketEventReceived(notification:)),
                                               name: .socketEventReceived,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(emojiEventReceived(notification:)),
                                               name: .emojiEventReceived,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    internal func sendReply(message: String,
                            channel_uuid: String,
                            root_message_uuid: String, mentions: [String]) {
        socketHelper.sendReplyMessage(event: .SEND_MESSAGE,
                                      message: message, channel_uuid: channel_uuid,
                                      root_message_uuid: root_message_uuid, mentions: mentions)
    }
    
    internal func getData(messageUUID: String, entityUUID: String,
                          channelUUID: String) {
        showLoading?()
        self.channelUUID = channelUUID
        MessageRepliesAPI.getMessageReplies(workspaces: LocalData.schoolUUID ?? "",
                                            entities: entityUUID,
                                            channelUUID: channelUUID,
                                            messageUUID: messageUUID) { [weak self] response in
            guard let self = self else { return }
            self.hideLoading?()
            if response.status == .success, let data = response.json {
                if let resultData = data.results {
                    self.repliesMessages += resultData
                }
                self.firstreloadTableView?()
            } else {
                if let errorMessage = response.errorMsg {
                    self.showError?(errorMessage)
                }
            }
        }
    }
    
    public func isValidIndex(indexPath: IndexPath) -> Bool {
        return indexPath.item >= 0 && indexPath.item < repliesMessages.count
    }
    
    internal func getCellViewModel(at indexPath: IndexPath) -> ChannelMessagesData? {
        if isValidIndex(indexPath: indexPath) {
            return repliesMessages[indexPath.row]
        }
        return nil
    }
    
    internal var numberOfRows: Int {
        return repliesMessages.count
    }
    
    internal func removeObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .socketEventReceived, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .emojiEventReceived, object: nil)
    }
    
    internal func uploadImages(channelSlug: String,
                               courseUUID: String,
                               courseName: String,
                               images: [UploadfileData],
                               message: String,
                               channel_uuid: String,
                               root_message_uuid: String,
                               mentions: [String], channelType: String) {
        var imageData = [Any]()
        let imageDispatchGroup = DispatchGroup()
        for value in images {
            imageDispatchGroup.enter()
            if let image = value.image {
                ChannelMessagesAPI.uploadChannelImage(image: image) { response in
                    if response.status == .success, let data = response.json?.first?.url {
                        let imageDic = ["url": data, "type": response.json?.first?.type ?? "", "size": response.json?.first?.size ?? 0] as [String : Any]
                        imageData.append(imageDic)
                        imageDispatchGroup.leave()
                    } else {
                        if let errorMessage = response.errorMsg {
                            self.showError?(errorMessage)
                            self.hideLoading?()
                        }
                    }
                }
            } else if let data = value.fileData {
                ChannelMessagesAPI.uploadChannelFile(fileName: value.fileName ?? "", filedata: data, mimeType: value.mimeType ?? "") { response in
                    if response.status == .success, let data = response.json?.first?.url {
                        let imageDic = ["url": data, "type": response.json?.first?.type ?? "", "size": response.json?.first?.size ?? 0] as [String : Any]
                        imageData.append(imageDic)
                        imageDispatchGroup.leave()
                    } else {
                        if let errorMessage = response.errorMsg {
                            self.showError?(errorMessage)
                            self.hideLoading?()
                        }
                    }
                }
            }
        }
        
        imageDispatchGroup.notify(queue: .main) {
            self.socketHelper.sendReplyMessage(event: .SEND_MESSAGE,
                                               message: message, channel_uuid: channel_uuid,
                                               root_message_uuid: root_message_uuid,
                                               images: imageData, mentions: mentions)
            self.hideLoading?()
        }
    }
}


// MARK: SocketHelperDelegate
extension MessagesRepliesVM {
    @objc private func socketEventReceived(notification: NSNotification) {
        if let socketEvent = notification.userInfo?["socketEvent"] as? SocketEventData {
            if socketEvent.channel?.uuid == self.channelUUID {
                if let data = socketEvent.message {
                    if repliesMessages.contains(where: {$0.uuid == data.uuid}) {
                        print("Message already exist")
                    } else if data.rootmessageUUID !=  nil {
                        repliesMessages.append(data)
                        if repliesMessages.count == 1 {
                            self.reloadTableView?()
                        } else {
                            self.performBatchUpdate?()
                            if socketEvent.message?.user?.externalUUID == LocalData.loggedInUser?.UUID {
                                self.scrollToBottom?()
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    @objc private func emojiEventReceived(notification: NSNotification) {
        if let socketEvent = notification.userInfo?["socketEvent"] as? Reaction {
            if socketEvent.channelUUID == self.channelUUID {
                if let index = repliesMessages.firstIndex(where: { $0.uuid == socketEvent.messageUUID}) {
                    if repliesMessages[index].reactions != nil {
                        if let firstIndex =  repliesMessages[index].reactions?.firstIndex(where: {$0.user?.uuid == socketEvent.user?.uuid && $0.unicode == socketEvent.unicode}) {
                            repliesMessages[index].reactions?.remove(at: firstIndex)
                        } else {
                            repliesMessages[index].reactions?.append(socketEvent)
                        }
                        
                    } else {
                        var reactionData = [Reaction]()
                        reactionData.append(socketEvent)
                        repliesMessages[index].reactions = reactionData
                    }
                    self.reloadTableView?()
                }
            }
            
        }
    }
    
}
