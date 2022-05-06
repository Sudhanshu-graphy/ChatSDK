//
//  ChannelDetails.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 29/06/21.
//

import Foundation

enum ChannelsDetailsAPI {
    
    static func getChannelDetails(workspaceSubDomain: String, entityUUID:String, channelSlug:String, completion: WebServiceResult<ChannelDetails>) {
        let req = WebServiceRequest<ChannelDetails>(url: Endpoints.channelDetails)
        req.completion = completion
        req.path = ["workspaceSubDomain": workspaceSubDomain, "entity_uuid": entityUUID, "channelSlug": channelSlug]
        NetworkRequest.shared.fire(req: req)
    }
    
    static func getMembersList(entityExternalUUID:String, limit: Int, offset: Int, completion: WebServiceResult<ChannelMembersRoot>) {
        let req = WebServiceRequest<ChannelMembersRoot>(url: Endpoints.channelMembers)
        req.completion = completion
        req.path = ["course_uuid": entityExternalUUID]
        req.params = ["offset": offset, "limit": limit]
        var header = AuthApi.defaultHeaders
        header["X-FORWARDED-HOST"] = HTTPHeaderValue.forwardedHost.content
        req.headers = header
        NetworkRequest.shared.fire(req: req)
    }
    
    static func getRecentFiles(channelUUID: String, completion: WebServiceResult<ChannelRecentFiles>) {
        let req = WebServiceRequest<ChannelRecentFiles>(url: Endpoints.channelRecentFiles)
        req.completion = completion
        req.path = ["channelUUID": channelUUID]
        NetworkRequest.shared.fire(req: req)
    }
}
