//
//  WelcomeCard.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/09/21.
//

import Foundation
import UIKit

enum WelcomeCardType {
    case conversation
    case thread
    case mention
    case polite
    case notification
    case shareImage
    
    var icon: UIImage {
        switch self {
        case .conversation:
            return AppAssets.conversationsIcon
        case .thread:
            return AppAssets.threadIcon
        case .mention:
            return AppAssets.mentionIcon
        case .polite:
            return AppAssets.politeIcon
        case .notification:
            return AppAssets.welcomeNotifIcon
        case .shareImage:
            return AppAssets.welcomeShareImageIcon
        }
    }
    
    func title(type: ChannelType) -> String {
        switch self {
        case .conversation:
            if AppUtil.isInstructor() {
                return type.instructorConversationText
            } else {
                return type.leanerConversationText
            }
        case .thread:
            return AppStrings.startThread
        case .mention:
            return AppStrings.mentionSymbol
        case .polite:
            return AppStrings.politeRespectful
        case .notification:
            return AppStrings.neverMissNotificaiton
        case .shareImage:
            return AppStrings.shareImage
        }
    }
}


enum ChannelType: String, Codable {
    
    case general
    case announcements
    case random
    
    var leanerConversationText: String {
        switch self {
        case .general:
            return AppStrings.conversationsAndShareUpdates
            
        case .announcements:
            return AppStrings.getToKnowMajorUpdate
            
        case .random:
            return AppStrings.randomChitChats
        }
    }
    
    var instructorConversationText: String {
        switch self {
        case .general:
            return AppStrings.conversationsAndShareUpdates
            
        case .announcements:
            return AppStrings.shareMajorUpdates
            
        case .random:
            return AppStrings.randomChitChats
        }
    }
    var welcomeCardArray: [WelcomeCardType] {
        switch self {
        case .general:
            return [.conversation, . thread, .mention, .polite]
        case .announcements:
            if AppUtil.isInstructor() {
                return [.conversation, .thread, .mention, .notification]
            } else {
                return [.conversation, .thread, .polite]
            }
        case .random:
            return [.conversation, .thread, .mention, .polite]
        }
    }
    
    var welcomeMessageTitle: String {
        switch self {
        case .general:
            return AppStrings.welcomeMessageGeneralChannel
            
        case .announcements:
            if AppUtil.isInstructor() {
                return AppStrings.instructorWelcomeMessageAnnouncementChannel
            } else {
                return AppStrings.learnerWelcomeMessageAnnouncementChannel
            }

        case .random:
            if AppUtil.isInstructor() {
                return AppStrings.instructorWelcomeMessageRandomChannel
            } else {
                return AppStrings.learnerWelcomeMessageRandomChannel
            }
        }
    }
    
    var welcomeMessageCellArray: [WelcomeCardType] {
        switch self {
        case .general:
            return [.thread, .mention, .shareImage, .polite]
        case .announcements:
            if AppUtil.isInstructor() {
                return [.conversation, .thread, .mention, .notification]
            } else {
                return [.thread, .mention, .notification]
            }
        case .random:
            return [.thread, .mention, .shareImage, .polite]
        }
    }
}
