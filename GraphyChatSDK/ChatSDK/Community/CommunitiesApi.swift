//
//  CommuntiesApi.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/07/21.
//

import Foundation

enum CommuntiesApi {
    static func getCommunities(completion: WebServiceResult<Communities>) {
        let req = WebServiceRequest<Communities>(url: Endpoints.communities)
        req.completion = completion
        var header = AuthApi.defaultHeaders
        header["X-FORWARDED-HOST"] = HTTPHeaderValue.forwardedHost.content
        req.headers = header
        NetworkRequest.shared.fire(req: req)
    }
}
