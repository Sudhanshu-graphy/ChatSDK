import Foundation
import UIKit

// MARK: - ChannelMessages
struct ChannelMessages: Codable {
    let count: Int?
    let results: [ChannelMessagesData]?
}

// MARK: - ChannelMessagesData
struct ChannelMessagesData: Codable {
    let id: Int?
    let uuid, message, createdAt: String?
    let rootmessageUUID: String?
    var reactionCount, replyCount, assetCount: Int?
    let user: ChannelUser?
    let mentions: [String: Mention]?
    let metadata: Metadata?
    var reactions: [Reaction]?
    let firstReply: FirstReply?
    let showWelcomeMessage, isPrivate: Bool?
    enum CodingKeys: String, CodingKey {
        case id, uuid, message
        case createdAt = "created_at"
        case rootmessageUUID = "root_message_uuid"
        case reactionCount = "reaction_count"
        case replyCount = "reply_count"
        case assetCount = "asset_count"
        case user, mentions, metadata, reactions, showWelcomeMessage
        case firstReply = "first_reply"
        case isPrivate = "is_private"
    }
}

struct Reaction: Codable {
    let uuid, emojiName, unicode: String?
    let action: Int?
    let messageUUID, channelUUID: String?
    let user: ChannelUser?
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case emojiName = "emoji_name"
        case unicode, action
        case messageUUID = "message_uuid"
        case channelUUID = "channel_uuid"
        case user
    }
}

struct Mention: Codable {
    let uuid, externalUUID, firstName, lastName: String?
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case externalUUID = "external_uuid"
        case avatar, uuid
    }
}

// MARK: - FirstReply
struct FirstReply: Codable {
    let message: String?
    let rootMessageUUID: String?
    let user: ChannelUser?
    let mentions: Mentions?
    let metadata: Metadata?
    let reactions: [Reaction]?
    
    enum CodingKeys: String, CodingKey {
        case message
        case rootMessageUUID = "root_message_uuid"
        case user, mentions, metadata, reactions
    }
}


// MARK: - Mentions
struct Mentions: Codable {
}

// MARK: - Metadata
struct Metadata: Codable {
    let assets: [Asset]?
}

// MARK: - Asset
struct Asset: Codable {
    
    internal init(uuid: String? = nil, type: FileType? = nil, url: String? = nil, size: Int? = nil, createdAt: String? = nil, title: String? = nil) {
        self.uuid = uuid
        self.type = type
        self.url = url
        self.size = size
        self.createdAt = createdAt
        self.title = title
    }
    
    let uuid: String?
    let type: FileType?
    let url: String?
    let size: Int?
    let createdAt, title: String?
}

// MARK: - User
struct ChannelUser: Codable {
    let id, isEducator: Int?
    let uuid, username, firstName, lastName, externalUUID: String?
    let avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case id, uuid, username
        case firstName = "first_name"
        case lastName = "last_name"
        case externalUUID = "external_uuid"
        case isEducator = "is_educator"
        case avatar
    }
}


enum FileType: String, Codable {
    case PGN = "pgn"
    case PDF = "pdf"
    case ZIP = "zip"
    case PPT = "ppt"
    case PPTX = "pptx"
    case RAR = "rar"
    case Image = "image"
    case MP3 = "mp3"
    case WAV = "wav"
    case M4A = "m4a"
    case X_M4A = "x-m4a"
    case MPEG = "mpeg"
    case JPEG = "jpeg"
    case JPG = "jpg"
    case PNG = "png"
    case SVG = "svg"
    case WEBP = "webp"
    case SVG_XML = "svg+xml"
    case GIF = "gif"
    case none = ""
    case unknown
    
    var icon: UIImage? {
        var icon: UIImage? = UIImage()
        switch self {
        case .Image, .JPG, .JPEG, .SVG_XML, .PNG, .WEBP, .GIF:
            icon = AppAssets.imageIcon
            
        case .PDF:
            icon = AppAssets.pdfIcon
            
        case .PGN:
            icon = AppAssets.pgn_Icon
            
        case .RAR, .ZIP:
            icon = AppAssets.zipIcon
            
        case .MP3, .WAV, .M4A, .X_M4A, .MPEG:
            icon = AppAssets.mp3Icon
            
        case .PPT, .PPTX, .SVG:
            icon = AppAssets.pptIcon
            
        case .none, .unknown:
            icon = AppAssets.fileDefaultIcon
        }
        return icon
    }
    
    public init(from decoder: Decoder) throws {
        self = try FileType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
