//
//  ChannelMessagesAPI.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 30/06/21.
//

import Foundation
import UIKit

enum ChannelMessagesAPI {
    
    static func getChannelMessages(workspaces: String, entities:String, channelUUID: String, limit: Int, offsetDate: String = "", completion: WebServiceResult<ChannelMessages>) {
        let req = WebServiceRequest<ChannelMessages>(url: Endpoints.channelMessages)
        req.completion = completion
        req.path = ["workspaceExternalUUID": workspaces, "entityExternalUUID": entities, "channelUUID" : channelUUID]
        req.params = ["offsetDate": offsetDate, "limit": limit, "canMention": true]
        NetworkRequest.shared.fire(req: req)
    }
    
    static func uploadChannelImage(image: UIImage, completion: WebServiceResult<FileData>) {
        let req = WebServiceRequest<FileData>(url: Endpoints.uploadChatImage)
        var header = AuthApi.defaultHeaders
        header["upload-type"] = "CHANNEL"
        req.headers = header
        req.completion = completion
        let timeStamp = "\(Date().currentTimeMillis())"
        NetworkRequest.shared.fireUploadImage(req: req, paramName: "files", fileName: timeStamp, image: image)
    }
    
    static func uploadChannelFile(fileName: String, filedata: Data, mimeType: String, completion: WebServiceResult<FileData>) {
        let req = WebServiceRequest<FileData>(url: Endpoints.uploadChatImage)
        var header = AuthApi.defaultHeaders
        header["upload-type"] = "CHANNEL"
        req.headers = header
        req.completion = completion
        NetworkRequest.shared.fireUploadFile(req: req, paramName: "files", fileName: fileName, fileData: filedata, mimeType: mimeType)
    }
    
    static func getMessageSuggestions(workspaces: String, entities:String, channelUUID: String, completion: WebServiceResult<MessageSuggestions>) {
        let req = WebServiceRequest<MessageSuggestions>(url: Endpoints.messageSuggestions)
        req.completion = completion
        req.path = ["workspaceExternalUUID": workspaces, "entityExternalUUID": entities, "channelUUID" : channelUUID]
        NetworkRequest.shared.fire(req: req)
    }
    
    static func getCourseUnreadCountMessage(workspaceSubDomain: String, completion: WebServiceResult<CourseTotalUnreadCount>) {
        let req = WebServiceRequest<CourseTotalUnreadCount>(url: Endpoints.courseUnreadCount)
        req.completion = completion
        req.path = ["workspaceSubDomain": workspaceSubDomain]
        NetworkRequest.shared.fire(req: req)
    }
    
    static func deleteMessage(workspaces: String, entities:String, channelUUID: String, messageUUID: String, completion: WebServiceResult<MessageSuggestions>) {
        let req = WebServiceRequest<MessageSuggestions>(url: Endpoints.messageDelete)
        req.completion = completion
        req.path = ["workspaceExternalUUID": workspaces, "entityExternalUUID": entities, "channelUUID" : channelUUID, "messageUUID": messageUUID]
        NetworkRequest.shared.fire(req: req)
    }
}
