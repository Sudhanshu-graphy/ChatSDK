//
//  ChannelsViewModel.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 29/06/21.
//

import Foundation

class ChannelsListVM {
    
    private let socketHelper = SocketHelper.shared
    internal var channels = [ChannelData]()
    internal var reloadTableView: (() -> Void)?
    internal var showError: ((String) -> Void)?
    internal var showLoading: (() -> Void)?
    internal var hideLoading: (() -> Void)?
    internal var unreadCountDic = [String : Int]()
    internal var openedChannelSlug = ""
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(socketEventReceived(notification:)),
                                               name: .socketEventReceived, object: nil)
    }
    internal func getData(entityUUID: String) {
        showLoading?()
        ChannelsListAPI.getChannels(workspaces: LocalData.savedSchools?.first?.subdomain ?? "",
                                    entityUUID: entityUUID) { [weak self] response in
            guard let self = self else { return }
            self.hideLoading?()
            if response.status == .success, let data = response.json,
               let dataResult = data.results {
                self.channels = dataResult
                self.setUnreadCount()
                self.reloadTableView?()
            } else {
                if let errorMessage = response.errorMsg {
                    self.showError?(errorMessage)
                }
            }
        }
    }
    
    internal func joinChannel(entitySlug: String) {
        self.socketHelper.joinChannel(event: .JOIN_CHANNEL, entitySlug: entitySlug, entityExternalUUID: AppUtil.schoolUUID)
    }
    
    internal func getCellViewModel(at indexPath: IndexPath) -> ChannelData {
        return channels[indexPath.row]
    }
    
    internal func establishSocketConnection(entitySlug: String, entityExternalUUID: String) {
        if !socketHelper.isConnected {
            socketHelper.establishConnection()
        } else if socketHelper.isConnected {
            self.socketHelper.joinChannel(event: .JOIN_CHANNEL,
                                          entitySlug: entitySlug, entityExternalUUID: entityExternalUUID)
        }
        
        socketHelper.connected = { [weak self] in
            guard let self = self else { return }
            self.socketHelper.joinChannel(event: .JOIN_CHANNEL,
                                          entitySlug: entitySlug, entityExternalUUID: entityExternalUUID)
        }
        
        socketHelper.showError = { [weak self](error) in
            guard let self = self else { return }
            self.showError?(error)
        }
    }

    var numberOfRows: Int {
        return channels.count
    }
    
    private func setUnreadCount() {
        for value in channels {
            if let key = value.slug {
                unreadCountDic[key] = value.totalUnreadMessages ?? 0
            }
        }
        self.reloadTableView?()
    }
    
    internal func getUnreadCountData() -> [String : Int] {
        return unreadCountDic
    }
    
    internal func updateChannelUnreadCount(channelSlug: String) {
        unreadCountDic[channelSlug] = 0
        self.reloadTableView?()
    }
}

// MARK: SocketHelperDelegate
extension ChannelsListVM {
    @objc private func socketEventReceived(notification: NSNotification) {
        if let socketEvent = notification.userInfo?["socketEvent"] as? SocketEventData {
            if socketEvent.message?.user?.externalUUID != LocalData.loggedInUser?.UUID {
                if let slug = socketEvent.channel?.slug {
                    if self.openedChannelSlug != slug {
                        let count = unreadCountDic[slug] ?? 0
                        unreadCountDic[slug] = count + 1
                        self.reloadTableView?()
                    }
                }
            }
        }
    }
}
