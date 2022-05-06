//
//  NSNotification+Helpers.swift
//  Graphy
//
//  Created by Raj Dhakate on 01/09/21.
//

import Foundation

extension Notification.Name {
    static let localUserDataUpdate = Notification.Name("LocalUserDataUpdate")
    static let profileDataUpdate = Notification.Name("ProfileDataUpdate")
    static let reloadHomeScreenSection = Notification.Name("ReloadHomeScreenSection")
    static let collectionViewHeightUpdate = Notification.Name("collectionViewHeightUpdate")
    static let reloadHomePageControl = Notification.Name("reloadHomePageControl")
}
