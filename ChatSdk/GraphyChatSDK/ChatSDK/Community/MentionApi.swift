//
//  MentionApi.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 05/08/21.
//

import Foundation

enum MentionApi {
    static func getMentionUsers(channelUUID: String, searchQuery: String, completion: WebServiceResult<MentionUser>) {
        let req = WebServiceRequest<MentionUser>(url: Endpoints.mentionUsers)
        req.completion = completion
        req.path = ["channelUUID": channelUUID]
        req.params = ["q": searchQuery]
        NetworkRequest.shared.fire(req: req)
    }
}
