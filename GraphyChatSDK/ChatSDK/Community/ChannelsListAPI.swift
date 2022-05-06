//
//  ChannelsApi.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 28/06/21.
//

import Foundation

enum ChannelsListAPI {
    static func getChannels(workspaces: String, entityUUID:String, completion: WebServiceResult<Channels>) {
        let req = WebServiceRequest<Channels>(url: Endpoints.channels)
        req.completion = completion
        req.path = ["workspaceExternalUUID": workspaces, "entity_uuid": entityUUID]
        NetworkRequest.shared.fire(req: req)
    }
}
