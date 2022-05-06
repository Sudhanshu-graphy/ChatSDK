//
//  MessageRepliesAPI.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 02/07/21.
//

import Foundation

enum MessageRepliesAPI {
    static func getMessageReplies(workspaces: String, entities:String, channelUUID: String, messageUUID: String, completion: WebServiceResult<ChannelMessages>) {
        let req = WebServiceRequest<ChannelMessages>(url: Endpoints.messageReplies)
        req.completion = completion
        req.path = ["workspaceExternalUUID": workspaces, "entityExternalUUID": entities, "channelUUID" : channelUUID, "messageUUID" : messageUUID]
        req.params = ["canMention": true]
        NetworkRequest.shared.fire(req: req)
    }
}
