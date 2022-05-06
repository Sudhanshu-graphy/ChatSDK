import Foundation

// MARK: - ChannelMessages
struct SocketEventData: Codable {
    let channel: Channel?
    let workspace: Workspace?
    let message: ChannelMessagesData?
}

struct Channel: Codable {
    let id: Int?
    let uuid, slug, type: String?
    let totalMessageCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, uuid, slug, type
        case totalMessageCount = "total_message_count"
    }
}

// MARK: - Workspace
struct Workspace: Codable {
    let uuid: String?
}
