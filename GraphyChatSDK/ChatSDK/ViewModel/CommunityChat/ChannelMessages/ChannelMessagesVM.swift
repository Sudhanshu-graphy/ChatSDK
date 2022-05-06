//
//  ChannelMessagesVM.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 30/06/21.
//

import Foundation
import ImageScout
import UIKit

class ChannelMessagesVM {
    
    internal var reloadTableView: (() -> Void)?
    internal var firstreloadTableView: (() -> Void)?
    internal var showError: ((String) -> Void)?
    internal var showLoading: (() -> Void)?
    internal var hideLoading: (() -> Void)?
    internal var showEmptyMessageState: (() -> Void)?
    internal var performBatchUpdate: (() -> Void)?
    internal var scrollToTop: (() -> Void)?
    internal var configureData: (() -> Void)?
    private let socketHelper = SocketHelper.shared
    private var messagesCount = 0
    private var channelMessagesSection = [[ChannelMessagesData]]()
    private var channelMessages = [ChannelMessagesData]()
    private var allMessagesLoaded = false
    private var channelDetail : ChannelDetails?
    private let imageFetcher = ImageScout()
    private var isActive = false
    public var showPrefilledView: (() -> Void)?
    private var suggestedMessages: MessageSuggestions?
    private var messageSuggestionLoaded = false
    private var communityType: CommunityType = .courses
    internal var channelName = ""
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(socketEventReceived(notification:)),
                                               name: .socketEventReceived,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(emojiEventReceived(notification:)),
                                               name: .emojiEventReceived,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageDeleteEventReceived(notification:)),
                                               name: .messageDeletedEventReceived,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    internal func sendMessages(message: String, channel_uuid: String, mentions: [String]) {
        socketHelper.sendMessages(event: .SEND_MESSAGE, message: message,
                                  channel_uuid: channel_uuid, mentions: mentions)
        socketHelper.showError = { (error) in
            self.showError?(error)
        }
    }
    
    internal func getData(offsetDate: String = "",
                          entityUUID: String,
                          channelUUID: String, type: ChannelType?, communityType: CommunityType) {
        showLoading?()
        self.communityType = communityType
        ChannelMessagesAPI.getChannelMessages(
            workspaces: LocalData.schoolUUID ?? "",
            entities: entityUUID,
            channelUUID: channelUUID,
            limit : 30, offsetDate: offsetDate) { [weak self] response in
                
                self?.hideLoading?()
                if response.status == .success, let data = response.json {
                    if (data.results?.count ?? 0) > 0 {
                        if let resultData = data.results {
                            self?.messagesCount = data.count ?? 0
                            self?.channelMessages += resultData
                            self?.checkForPrefilledMessages(offsetDate: offsetDate, type: type)
                        }
                    } else {
                        self?.allMessagesLoaded = true
                        self?.checkForPrefilledMessages(offsetDate: offsetDate, type: type)
                    }
                } else {
                    if let errorMessage = response.errorMsg {
                        self?.showError?(errorMessage)
                    } else {
                        self?.hideLoading?()
                    }
                }
            }
    }
    
    internal func getCellViewModel(at indexPath: IndexPath) -> ChannelMessagesData {
        return channelMessagesSection[indexPath.section][indexPath.row]
    }
    
    internal func numberOfRows(at section: Int) -> Int {
        return channelMessagesSection[section].count
    }
    
    internal var totalMessagesCount: Int {
        return messagesCount
    }
    
    internal var totalSections: Int {
        return channelMessagesSection.count
    }
    
    internal func getSectionViewModel(at section: Int) -> [ChannelMessagesData] {
        return channelMessagesSection[section]
    }
    
    fileprivate func attemptToAssembleGroupedMessages(
        with data: [ChannelMessagesData],
        completion : ([[ChannelMessagesData]]) -> Void) {
            var messagesData = [[ChannelMessagesData]]()
            let groupedMessages = Dictionary(grouping: data) { (element) -> Date in
                let date = element.createdAt?.messageDate().reduceToMonthDayYear()
                return date ?? Date()
            }
            
            let sortedKeys = groupedMessages.keys.sorted()
            sortedKeys.forEach { (key) in
                let values = groupedMessages[key]
                messagesData.append(values ?? [])
            }
            completion(messagesData.reversed())
        }
    
    private func createMessagesSection(completion: @escaping (Bool) -> Void) {
        var messages = [ChannelMessagesData]()
        for value in channelMessages {
            if !messages.contains(where: {($0.uuid == value.uuid)}) {
                messages.append(value)
            }
        }
        channelMessages = messages
        self.attemptToAssembleGroupedMessages(with: channelMessages) { data in
            self.channelMessagesSection = data
            completion(true)
        }
    }
    
    internal var totalDisplayedMessages: Int {
        return channelMessagesSection.flatMap { $0 }.count
    }
    
    internal var allMessagesDisplayed: Bool {
        return allMessagesLoaded
    }
    
    internal func refreshData(type: ChannelType?) {
        self.channelMessages.removeAll()
        self.getData(entityUUID: self.entityUUID, channelUUID: self.channelUUID, type: type, communityType: self.communityType)
    }
    
    internal func getChannelData(channelSlug: String, entityUUID: String) {
        ChannelsDetailsAPI.getChannelDetails(workspaceSubDomain: LocalData.savedSchools?.first?.subdomain ?? "", entityUUID:  entityUUID, channelSlug: channelSlug) { [weak self] response in
            if response.status == .success, let data = response.json {
                self?.channelDetail = data
                LocalData.schoolUUID = data.workspaceExternalUUID
                self?.channelName = data.title ?? ""
                self?.configureData?()
            } else {
                if let errorMessage = response.errorMsg {
                    self?.showError?(errorMessage)
                } else {
                    self?.hideLoading?()
                }
            }
        }
    }
    
    internal var channelUUID: String {
        return self.channelDetail?.uuid ?? ""
    }
    
    internal var entityUUID: String {
        return self.channelDetail?.entityExternalUUID ?? ""
    }
    
    internal func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: .socketEventReceived, object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: .emojiEventReceived, object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: .messageDeletedEventReceived, object: nil)
    }
    
    internal var canPost: Bool {
        return (self.channelDetail?.canPost == 1) ? true : false
    }
    
    internal func uploadImages(channelSlug: String, courseUUID: String, courseName: String, images: [UploadfileData], message: String,
                               channel_uuid: String, mentions: [String], channelType: String) {
        var imageData = [Any]()
        let imageDispatchGroup = DispatchGroup()
        for value in images {
            imageDispatchGroup.enter()
            if let image = value.image {
                ChannelMessagesAPI.uploadChannelImage(image: image) { response in
                    if response.status == .success,
                       let data = response.json?.first?.url {
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
            self.socketHelper.sendMessages(event: .SEND_MESSAGE,
                                           message: message,
                                           channel_uuid: channel_uuid,
                                           images: imageData, mentions: mentions)
            self.hideLoading?()
        }
    }
    
    private func getMessageSuggestions(completion: @escaping () -> Void) {
        // If suggestions message API is already called, then don't call an API again or if community type - Open Channels i.e school
        if messageSuggestionLoaded || self.communityType == .school {
            completion()
        } else {
            ChannelMessagesAPI.getMessageSuggestions(workspaces: LocalData.schoolUUID ?? "", entities: entityUUID, channelUUID: channelUUID) { [weak self] response in
                guard let self = self else { return }
                self.messageSuggestionLoaded = true
                if response.status == .success, let data = response.json {
                    self.suggestedMessages = data
                    if data.userActive == nil || data.userActive == false {
                        // isActive - false it means a user has never send a message on the channel
                        self.isActive = false
                        self.showPrefilledView?()
                    } else {
                        self.isActive = true
                    }
                }
                completion()
            }
        }
    }
    
    private func checkForPrefilledMessages(offsetDate: String, type: ChannelType?) {
        self.getMessageSuggestions { [weak self] in
            guard let self = self else { return }
            if self.channelMessages.count == 0 {
                self.showEmptyMessageState?()
                self.allMessagesLoaded = true
            } else if self.channelMessages.count > 0 && self.isActive {
                self.setMessagesSection(offsetDate: offsetDate)
            } else if self.channelMessages.count > 0 && !self.isActive {
                if AppUtil.isInstructor()  && self.communityType != .school {
                    self.channelMessages.insert(ChannelMessagesData(id: nil, uuid: AppUtil.deviceId, message: "", createdAt: self.channelMessages.first?.createdAt, rootmessageUUID: nil, reactionCount: nil, replyCount: nil, assetCount: nil, user: nil, mentions: nil, metadata: nil, reactions: nil, firstReply: nil, showWelcomeMessage: true, isPrivate: false), at: 0)
                } else if let type = type, type != .announcements && self.communityType != .school {
                    self.channelMessages.insert(ChannelMessagesData(id: nil, uuid: AppUtil.deviceId, message: "", createdAt: self.channelMessages.first?.createdAt, rootmessageUUID: nil, reactionCount: nil, replyCount: nil, assetCount: nil, user: nil, mentions: nil, metadata: nil, reactions: nil, firstReply: nil, showWelcomeMessage: true, isPrivate: false), at: 0)
                }
                self.setMessagesSection(offsetDate: offsetDate)
            }
        }
    }
    
    private func setMessagesSection(offsetDate: String) {
        self.createMessagesSection(completion: { success in
            if success {
                if offsetDate.isEmpty {
                    self.firstreloadTableView?()
                } else {
                    self.reloadTableView?()
                }
            }
        })
    }
    
    public func showWelcomeMessage(indexPath: IndexPath, channelType: ChannelType?) -> Bool {
        if AppUtil.isInstructor() {
            
            return channelMessagesSection[indexPath.section][indexPath.row].showWelcomeMessage ?? false
        } else if !AppUtil.isInstructor() {
            return channelMessagesSection[indexPath.section][indexPath.row].showWelcomeMessage ?? false
        } else {
            return false
        }
    }
    
    public func showOpenChannelWelcomeMessage(indexPath: IndexPath, channelType: ChannelType?) -> Bool {
        let data = self.getCellViewModel(at: indexPath)
        if let message = data.message, let isPrivate = data.isPrivate,
           message == "welcome_message", isPrivate {
            return true
        } else {
            return false
        }
    }
    
    public func getPrefilledMessage() -> [String]? {
        if let messages = suggestedMessages {
            return messages.suggestions
        }
        return nil
    }
    
    public func deleteMessage(indexPath: IndexPath) {
        let data = getCellViewModel(at: indexPath)
        let messageUUID = data.uuid ?? ""
        
        ChannelMessagesAPI.deleteMessage(workspaces: LocalData.schoolUUID ?? "", entities: entityUUID, channelUUID: channelUUID, messageUUID: messageUUID) { [weak self] response in
            guard let self = self else { return }
            self.messageSuggestionLoaded = true
            if let errorMessage = response.errorMsg {
                self.showError?(errorMessage)
            }
        }
    }
    
    public func getHelloButtonText(type: ChannelType) -> String {
        return suggestedMessages?.suggestions?.first ?? ""
    }
}

// MARK: SocketHelperDelegate
extension ChannelMessagesVM {
    @objc private func socketEventReceived(notification: NSNotification) {
        if let socketEvent = notification.userInfo?["socketEvent"] as? SocketEventData {
            if socketEvent.channel?.uuid == self.channelUUID {
                if let data = socketEvent.message {
                    if let index = channelMessages.firstIndex(where: { $0.uuid == data.rootmessageUUID}) {
                        let replyCount = channelMessages[index].replyCount ?? 0
                        channelMessages[index].replyCount = replyCount + 1
                        createMessagesSection { success in
                            if success {
                                self.reloadTableView?()
                            }
                        }
                    } else if data.rootmessageUUID == nil {
                        channelMessages.insert(data, at: 0)
                        createMessagesSection { success in
                            if success {
                                self.performBatchUpdate?()
                                if socketEvent.message?.user?.externalUUID == LocalData.loggedInUser?.UUID {
                                    self.scrollToTop?()
                                }
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
                if let index = channelMessages.firstIndex(where: { $0.uuid == socketEvent.messageUUID}) {
                    if channelMessages[index].reactions != nil {
                        if let firstIndex =  channelMessages[index].reactions?.firstIndex(where: {$0.user?.uuid == socketEvent.user?.uuid && $0.unicode == socketEvent.unicode}) {
                            channelMessages[index].reactions?.remove(at: firstIndex)
                        } else {
                            channelMessages[index].reactions?.append(socketEvent)
                        }
                    } else {
                        var reactionData = [Reaction]()
                        reactionData.append(socketEvent)
                        channelMessages[index].reactions = reactionData
                    }
                    createMessagesSection { success in
                        if success {
                            self.reloadTableView?()
                        }
                    }
                }
            }
        }
    }
    
    @objc private func messageDeleteEventReceived(notification: NSNotification) {
        if let socketEvent = notification.userInfo?["socketEvent"] as? Reaction {
            if socketEvent.channelUUID == self.channelUUID {
                if let index = channelMessages.firstIndex(where: { $0.uuid == socketEvent.messageUUID}) {
                    self.channelMessages.remove(at: index)
                    self.createMessagesSection { [weak self] success in
                        guard let self = self else { return }
                        if success {
                            self.reloadTableView?()
                        }
                    }
                }
            }
        }
    }
}
