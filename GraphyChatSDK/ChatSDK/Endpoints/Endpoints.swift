//
//  Endpoints.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 28/06/21.
//

import Foundation

class Endpoints {
    
    static let baseURL = Configuration.baseURLString
    static let chatBaseURL = Configuration.chatBaseURLString
    static let chatUploadBaseURL = Configuration.chatUploadBaseURLString
    static let baseV2URL = Configuration.baseV2URLString
    static let chatBaseV2URL = Configuration.chatbaseV2URLString
    static let analyticsBaseURL = Configuration.analyticsBaseURL
    static let patch = "|PATCH"
    static let post = "|POST"
    static let get = "|GET"
    static let put = "|PUT"
    static let delete = "|DELETE"
    
    static let authRefreshToken = baseURL + "auth/token/refresh" + post
    
    // Community Url's
    
    static let channels = chatBaseV2URL + "workspaces/{workspaceExternalUUID}/entities/{entity_uuid}/channels" + get
    
    static let messages = chatBaseURL + "workspaces/{workspaceExternalUUID}/entities/{entityExternalUUID}/channels/{channelUUID}/messages" + get
    
    static let channelDetails = chatBaseV2URL + "workspaces/{workspaceSubDomain}/entities/{entity_uuid}/channels/{channelSlug}" + get
    
    static let channelMessages = chatBaseURL + "workspaces/{workspaceExternalUUID}/entities/{entityExternalUUID}/channels/{channelUUID}/messages" + get
    
    static let messageReplies = chatBaseURL + "workspaces/{workspaceExternalUUID}/entities/{entityExternalUUID}/channels/{channelUUID}/messages/{messageUUID}/replies" + get
    
    static let channelRecentFiles = chatBaseURL + "channel/{channelUUID}/files" + get
    
    static let channelMembers = baseURL + "/web/courses/{course_uuid}/members" + get

    static let notificationInfo = baseURL + "/auth/app/info" + post
    
    static let communities = baseURL + "/mobile/communities" + get
    
    static let logout = baseURL + "/auth/logout" + post
    
    static let uploadChatImage = chatUploadBaseURL + "upload-file" + post
    
    static let mentionUsers = chatBaseURL + "channel/{channelUUID}/members/search" + get
    
    static let messageSuggestions = chatBaseURL + "workspaces/{workspaceExternalUUID}/entities/{entityExternalUUID}/channels/{channelUUID}/message-suggestions" + get
    
    static let courseUnreadCount = chatBaseURL + "workspaces/{workspaceSubDomain}/total-unread-messages-in-course" + get
    
    static let messageDelete = chatBaseURL + "workspaces/{workspaceExternalUUID}/entities/{entityExternalUUID}/channels/{channelUUID}/messages/{messageUUID}" + delete
    
    // Redesign Url's
    static let landingPage = baseV2URL + "/mobile/school/landing-page" + get
    
    static let videoLibrary = baseV2URL + "/mobile/school/video-library" + get
    
    static let liveSessions = baseV2URL + "/mobile/school/livesessions" + get
    
    static let courses = baseV2URL + "/mobile/courses" + get
    
    static let modules = baseV2URL + "/mobile/course/{course_uuid}/modules" + get
    
    static let moduleDetail = baseV2URL + "/mobile/course/{course_uuid}/modules/{course_module_uuid}" + get
    
    static let moduleResources = baseV2URL + "/mobile/course/{course_uuid}/modules/{course_module_uuid}/resources" + get
    
    static let coursePurchaseDetail = baseURL + "/mobile/courses/{course_slug}/detail" + get
    
    static let sessionDetail = baseURL + "/mobile/school/livesessions/{sessionUUID}" + get
    
    static let courseSessionDetail = baseURL + "/mobile/lessons/{sessionUUID}" + get
    
    static let courseDetail = baseV2URL + "/mobile/course/{course_slug}" + get
    
    // send magic link OTP
    static let magicLinkOTP = baseURL + "/auth/magic-link-login" + post
    // verify magic link OTP
    static let verifyMagicLinkOTP = baseURL + "/auth/otp/verify" + post
    // social login
    static let socialLogin = baseURL + "/auth/social-login" + post
    
    // user communities list
    static let communitiesList = baseURL + "/user/schools" + get
    // search communities
    static let searchCommunities = baseURL + "/mobile/school/search" + get
    // subscribe to community
    static let subscribeToCommunity = baseURL + "/user/schools/subscribe" + post
    
    // fetch learner schedules
    static let fetchLearnerSchedules = baseV2URL + "/mobile/school/schedule" + get
    // fetch learner course schedule
    static let fetchLearnerCourseSchedules = baseV2URL + "/mobile/course/{course_uuid}/schedule" + get
    
    // user info get
    static let getUserInfo = baseURL + "/auth/info" + get
    // user info update
    static let updateUserInfo = baseURL + "/auth/info" + patch
    
    // create user consent
    static let createUserConsent = baseURL + "/user/consent" + post
    
    // delete user account
    static let deleteUserAccount = baseURL + "/user/account-delete" + post
    
    // verify delete account otp
    static let verifyOTPForDeleteAccount = baseURL + "/user/account-delete/otp/verify" + post
    
    static let updatePNGImage = baseURL + "/assets/presigned_url" + post
    
    // get school info
    static let getSchoolInfo = baseURL + "/mobile/school/info" + get
    
    // Instructor Dashboard
    static let schoolRevenue = baseURL + "/mobile/school/revenue" + get
    
    static let schoolTransaction = baseURL + "/mobile/school/transactions" + get
    
    static let subscriberOverview = baseURL + "/mobile/school/subscriber-overview" + get
    
    static let schoolSubscribers = baseURL + "/mobile/school/subscribers" + get
    
    static let schoolCourseMembers = baseURL + "/mobile/school/course-members" + get
    
    static let transactionRefund = baseURL + "/payments/{payment_uuid}/refund" + post
    
    static let coursesList = baseURL + "/mobile/courses" + get
    
    static let trackWatchTime = analyticsBaseURL + "/track" + post

    static let getUserProfileDetails = baseURL + "/user/profiles/{profile_username}" + get
    
    static let getUserMemberships = baseURL + "/user/{user_uuid}/memberships" + get
    
    static let updateUserProfileDetails = baseURL + "/user/profiles/{profile_username}" + patch
    
    // Open Channel
    static let invitationModal = chatBaseV2URL + "workspaces/{subdomain}/entities/{entityExternalUUID}/invitation-modal" + get
    
    static let schoolMembers = baseV2URL + "/mobile/school/members" + get
    
    static let updateInvitationModal = chatBaseV2URL + "workspaces/{subdomain}/entities/{entityExternalUUID}/invitation-modal" + patch
}
