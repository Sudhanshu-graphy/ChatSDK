//
//  Notifications.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 30/08/21.
//

import Foundation

extension NSNotification.Name {
    static let socketEventReceived = NSNotification.Name("SocketEventReceived")
    static let emojiEventReceived = NSNotification.Name("emojiEventReceived")
    static let dismissPlayerView = NSNotification.Name("dismissPlayerView")
    static let showShareNudge = NSNotification.Name("showShareNudge")
    static let updateHomeFeed = NSNotification.Name("updateHomeFeed")
    static let switchToCommunity = NSNotification.Name("switchToCommunity")
    static let messageDeletedEventReceived = NSNotification.Name("MessageDeletedEventReceived")
    static let watchTimeModule = NSNotification.Name("WatchTimeModule")
}
