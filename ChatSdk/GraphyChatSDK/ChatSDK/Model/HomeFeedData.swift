//
//  HomeFeedData.swift
//  HomeFeedData
//
//  Created by Sudhanshu Dwivedi on 16/08/21.
//

import Foundation
import UIKit

enum HomeFeedType: String, Codable, CaseIterable {
    case HappeningNow = "happening_now"
    case currentlyLive = "upcoming_live"
    case enrolledCourses = "enrolled_courses"
    case availableCourses = "available_courses"
    case schoolSessions = "school_sessions"
    case videoLibrary = "video_library"
    case homeFeedHeader = "homeFeedHeader"
    case stats = "stats"
    case none
}

// MARK: - HomeFeedData
struct HomeFeedData: Codable {
    let title, subdomain, uuid: String?
    let results: [HomeFeedResult]?
    let cover: String?
}

// MARK: - HomeFeedResult
struct HomeFeedResult: Codable {
    let title: String?
    let type: String?
    let count: Int?
    let results: [FeedResult]?
}

// MARK: - FeedResult
struct FeedResult: Codable {
    internal init(statType: String? = nil, value: Double? = nil, percentageChange: Double? = nil, dataType: StatDataType? = nil, currency: String? = nil, title: String? = nil, startAt: String? = nil, learningAsset: LearningAssets? = nil, metadata: HomeFeedMetadata? = nil, entityType: SessionType? = nil, resultDescription: String? = nil, uuid: String? = nil, trailers: [Trailer]? = nil, isAcceptingRegistrations: Bool? = nil, slug: String? = nil, amount: String? = nil, endAt: String? = nil, emojiUnicode: String? = nil, emojiBasePath: String? = nil, isPurchased: Bool? = nil, cover: String? = nil, coverContentType: String? = nil, accessType: AccessType? = nil) {
        self.statType = statType
        self.value = value
        self.percentageChange = percentageChange
        self.dataType = dataType
        self.currency = currency
        self.title = title
        self.startAt = startAt
        self.learningAsset = learningAsset
        self.metadata = metadata
        self.entityType = entityType
        self.resultDescription = resultDescription
        self.uuid = uuid
        self.trailers = trailers
        self.isAcceptingRegistrations = isAcceptingRegistrations
        self.slug = slug
        self.amount = amount
        self.endAt = endAt
        self.emojiUnicode = emojiUnicode
        self.emojiBasePath = emojiBasePath
        self.isPurchased = isPurchased
        self.cover = cover
        self.coverContentType = coverContentType
        self.accessType = accessType
    }
    
    let statType: String?
    let value: Double?
    let percentageChange: Double?
    let dataType: StatDataType?
    let currency: String?
    let title: String?
    let startAt: String?
    var learningAsset: LearningAssets?
    let metadata: HomeFeedMetadata?
    let entityType: SessionType?
    let resultDescription: String?
    let uuid: String?
    let trailers: [Trailer]?
    let isAcceptingRegistrations: Bool?
    let slug: String?
    let amount: String?
    let endAt: String?
    let emojiUnicode: String?
    let emojiBasePath: String?
    let isPurchased: Bool?
    let cover: String?
    let coverContentType: String?
    let accessType: AccessType?
    
    enum CodingKeys: String, CodingKey {
        case statType = "stat_type"
        case value
        case percentageChange = "percentage_change"
        case dataType = "data_type"
        case title, currency
        case startAt = "start_at"
        case learningAsset = "learning_asset"
        case metadata
        case entityType = "entity_type"
        case resultDescription = "description"
        case uuid, trailers
        case isAcceptingRegistrations = "is_accepting_registrations"
        case slug, amount
        case endAt = "end_at"
        case emojiUnicode = "emoji_unicode"
        case emojiBasePath = "emoji_base_path"
        case isPurchased = "is_purchased"
        case cover
        case coverContentType = "cover_content_type"
        case accessType = "access_type"
    }
}

// MARK: - LearningAssets
struct LearningAssets: Codable {
    var status: String
    var assetType: AssetTypes?
    var assetToken, assetExternalID, userUid, uuid: String?
    let assetURL: String?
    let thumbnail: String?
    let isRecorded: Bool?
    let isDownloadable: Bool?
    let downloadLink: String?
    var externalStreamURL: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case assetType = "asset_type"
        case assetToken = "asset_token"
        case assetExternalID = "asset_external_id"
        case userUid = "user_uid"
        case uuid
        case assetURL = "asset_url"
        case thumbnail
        case isRecorded = "is_recorded"
        case isDownloadable = "is_downloadable"
        case downloadLink = "download_link"
        case externalStreamURL = "external_stream_url"
    }
}

enum AssetTypes: String, Codable {
    case zoom
    case video = "video"
    case image = "image"
    case youtube = "youtube"
    case wistia = "wistia"
    case pdf = "pdf"
    case ppt = "ppt"
    case pgn = "pgn"
    case chessfile = "chessfile"
    case unacademyclx = "unacademyclx"
    case livestream = "livestream"
    case uploaded = "uploaded"
    case zip
    case rar
    case audio
    case link
    case none = ""
    case unknown
    
    var icon: String {
        var icon = ""
        switch self {
            
        case .video:
            icon = "videoResource"
            
        case .image:
            icon = "imageResource"
            
        case .pdf:
            icon = "pdfResource"
            
        case .ppt:
            icon = "pptResource"
            
        case .pgn:
            icon = "pgnResource"
            
        case .unacademyclx, .livestream, .uploaded:
            icon = "videoResource"
            
        case .zip:
            icon = "fileResource"
            
        default:
            icon = "fileResource"
        }
        
        return icon
    }
    
    var resourceIcon: UIImage? {
        var icon: UIImage? = UIImage()
        switch self {
        case .video:
            icon = AppAssets.sessionPlayVideoIcon
            
        case .image:
            icon = AppAssets.imageIcon
            
        case .pdf:
            icon = AppAssets.pdfIcon
            
        case .ppt:
            icon = AppAssets.pptIcon
            
        case .pgn:
            icon = AppAssets.pgn_Icon
            
        case .unacademyclx, .livestream, .uploaded:
            icon = AppAssets.videoResource
            
        case .zip, .rar:
            icon = AppAssets.zipIcon
                
        case .audio:
            icon = AppAssets.mp3Icon
            
        case .link:
            icon = AppAssets.copyLinkIcon
            
        default:
            icon = AppAssets.fileDefaultIcon
        }
        return icon
    }
    
    public init(from decoder: Decoder) throws {
        self = try AssetTypes(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

// MARK: - Metadata
struct HomeFeedMetadata: Codable {
    let uuid, courseUUID, courseEmoji, courseTitle, cover : String?
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case cover
        case courseUUID = "course_uuid"
        case courseEmoji = "course_emoji_unicode"
        case courseTitle = "course_title"
    }
}

// MARK: - Trailer
struct Trailer: Codable {
    let url: String?
    let thumbnail, publishingStatus, lastDraftAt: String?
    let contentType: ContentType?
    let lastPublishedAt: String?
    let isConverted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case url, thumbnail
        case contentType = "content_type"
        case publishingStatus = "publishing_status"
        case lastDraftAt = "last_draft_at"
        case lastPublishedAt = "last_published_at"
        case isConverted = "is_converted"
    }
}

enum ContentType: String, Codable {
    case video
    case image
}

enum SessionType: String, Codable {
    case lesson
    case schoolsession
}

enum StatDataType: String, Codable {
    case revenue
    case subscribers
}

enum AccessType: String, Codable {
    case free, paid
    
    var icon: UIImage? {
        switch self {
        case .paid:
            return AppAssets.paidSessionIcon
        default:
            return AppAssets.freeSessionIcon
        }
    }
    
    var title: String {
        switch self {
        case .paid:
            return "Paid Session"
        default:
            return "Open Session "
        }
    }
}
