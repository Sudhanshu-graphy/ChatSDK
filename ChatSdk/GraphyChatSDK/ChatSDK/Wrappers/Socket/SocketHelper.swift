import Foundation
import SocketIO

class SocketHelper: NSObject {
    
    static let shared = SocketHelper()
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    internal var isConnected = false
    internal var connected: (() -> Void)?
    internal var showError: ((String) -> Void)?
    override init() {
        super.init()
        configureSocketClient()
    }
    
    internal func configureSocketClient() {
        
        let token = LocalData.token?.access ?? ""
        var showLog = false
        #if DEBUG
        showLog = true
        #endif
    
        let param:[String:String] = ["token": "Bearer \(token)"]
        manager = SocketManager(socketURL: URL(string: Configuration.socketBaseURLString)!)
        manager?.config = SocketIOClientConfiguration(
            arrayLiteral: .secure(true),
            .log(showLog), .compress,
            .extraHeaders(param), .forceWebsockets(true))
    }
    
    internal func establishConnection() {
        if isConnected {
            destroy()
        }
        socket = manager?.defaultSocket
        socket?.connect()
        self.addListener()
    }
    
    internal func destroy() {
        isConnected = false
        socket?.disconnect()
        removeAllListener()
        socket = nil
        isConnected = false
    }
    
    private func addListener() {
        socket?.on(clientEvent: .connect) { (_, _) in
            self.isConnected = true
            print("Socket Connected")
            self.connected?()
        }
        socket?.on(clientEvent: .error) { (data, _) in
            print("Error data is: \(data)")
            self.isConnected = false
        }
        socket?.on(clientEvent: .disconnect) { (_, _) in
            self.isConnected = false
            self.socket?.connect()
        }
        
        self.joinChannelListener(event: .CHANNEL_JOINED)
        self.messageListener(event: .MESSAGE_SENT)
        self.emojiEventListener(event: .REACTION_SENT)
        self.messageDeletedListener(event: .MESSAGE_DELETED)
    }
    
    private func removeAllListener() {
        removeListener(event: .CHANNEL_JOINED)
        removeListener(event: .MESSAGE_SENT)
        removeListener(event: .REACTION_SENT)
    }
    
    private func removeListener(event: SocketEvents) {
        self.socket?.off(event.rawValue)
    }
    
    internal func joinChannel(event: SocketEvents, entitySlug: String, entityExternalUUID: String) {
        self.socket?.emit(event.rawValue, ["entitySlug": entitySlug, "entityExternalUUID": entityExternalUUID])
    }
                                  
    internal func joinChannelListener(event: SocketEvents) {
        self.socket?.on(event.rawValue) { _, _ in
            print("Socket Channel Joined Response")
        }
    }
    
    internal func sendMessages(event: SocketEvents, message: String,
                               channel_uuid: String,
                               images: [Any]? = nil, mentions: [String]? = nil) {
        
        self.socket?.emit(event.rawValue, ["message": message,
                                           "channel_uuid": channel_uuid,
                                           "metadata": ["files": images],
                                           "mentions": mentions ?? [""]])
    }
    
    internal func sendReplyMessage(event: SocketEvents,
                                   message: String,
                                   channel_uuid: String,
                                   root_message_uuid: String,
                                   images: [Any]? = nil, mentions: [String]? = nil) {
        
        self.socket?.emit(event.rawValue, ["message": message,
                                           "channel_uuid": channel_uuid,
                                           "root_message_uuid": root_message_uuid,
                                           "metadata": ["files": images],
                                           "mentions": mentions ?? [""]])
    }
    
    internal func sendEmoji(event: SocketEvents, emojiName: String,
                            messageUUID: String, unicode: String) {
        self.socket?.emit(event.rawValue, ["emoji_name": emojiName,
                                           "message_uuid": messageUUID,
                                           "unicode": unicode])
    }

    internal func messageListener(event: SocketEvents) {
        socket?.on(event.rawValue, callback: { data, _ in
            let jsonString = data[0] as? String
            if let json = jsonString?.data(using: .utf8), let data = try? JSONDecoder().decode(SocketEventData.self, from: json) {
                let userInfo = ["socketEvent": data]
                NotificationCenter.default.post(name: NSNotification.Name.socketEventReceived,
                                                object: nil, userInfo: userInfo)
            }
        })
    }
    
    internal func emojiEventListener(event: SocketEvents) {
        socket?.on(event.rawValue, callback: { data, _ in
            let jsonString = data[0] as? String
            if let json = jsonString?.data(using: .utf8), let data = try? JSONDecoder().decode(Reaction.self, from: json) {
                let userInfo = ["socketEvent": data]
                NotificationCenter.default.post(name: NSNotification.Name.emojiEventReceived,
                                                object: nil, userInfo: userInfo)
            }
        })
    }
    
    internal func messageDeletedListener(event: SocketEvents) {
        socket?.on(event.rawValue, callback: { data, _ in
            let jsonString = data[0] as? String
            if let json = jsonString?.data(using: .utf8), let data = try? JSONDecoder().decode(Reaction.self, from: json) {
                let userInfo = ["socketEvent": data]
                NotificationCenter.default.post(name: NSNotification.Name.messageDeletedEventReceived,
                                                object: nil, userInfo: userInfo)
            }
        })
    }
}
