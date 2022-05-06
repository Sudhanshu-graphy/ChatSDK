//
//  AppStrings.swift
//  GraphyChatSDK
//
//  Created by Sudhanshu Dwivedi on 04/05/22.
//

import Foundation

enum AppStrings {
    static let termsConditions = "Terms & Conditions"
    static let privacyPolicy = "Privacy Policy"
    static let faqs = "FAQs"
    static let transactionURL = "https://api.graphyapp.in/v1/mobile/school/transactions"
    static let avatarChangesSuccess = "Avatar successfully updated"
    static let profileUpdatedSuccess = "Profile successfully updated"
    static let recordingIsProcessing = "We are processing the recording..."
    static let addedToCommunityText = "You’ve been added to \(LocalData.savedSchools?.first?.title ?? "")’s community!"
    static let startThread = "Start threads to organise discussions"
    static let mentionSymbol = "Mention someone specific by typing the “@” symbol"
    static let politeRespectful = "Remember to be polite and respectful"
    static let neverMissNotificaiton = "Never miss out with notifications"
    static let conversationsAndShareUpdates = "Your place to have conversation and share updates."
    static let getToKnowMajorUpdate = "Get to know about any major update"
    static let randomChitChats = "Have random relaxed chit-chats"
    static let shareMajorUpdates = "Share major updates"
    static let welcomeMessageGeneralChannel = "Welcome to General channel. Your place to have conversation and share updates."
    static let instructorWelcomeMessageAnnouncementChannel = "Welcome to Announcements channel. Share major updates with members."
    static let learnerWelcomeMessageAnnouncementChannel = "Welcome to Announcements channel. Get to know of any major updates."
    static let instructorWelcomeMessageRandomChannel = "Welcome to Random channel. Use this channel to have random relaxed chit-chats"
    static let learnerWelcomeMessageRandomChannel = "Welcome to Random channel. Have random relaxed chit-chats."
    static let shareImage = "Share images, videos and docs"
    static let helloEveryone = "👋 Hello, everyone"
    static let introduceOurselves = "Hey, welcome to the community, lets start with introducing ourselves"
    static let welcomeToCourse = "Hi all, welcome to the my course community. Feel free to interact and ask questions here"
}

