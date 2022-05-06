//
//  AuthApi.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 25/06/21.
//

import Foundation

class AuthApi {
    
    static var defaultHeaders: [String: String] {
        var headers = ["Content-Type" : HTTPHeaderValue.json.content, "Connection": "keep-alive"]
        headers["X-APP-Client"] = HTTPHeaderValue.client.content
        headers[HTTPHeaderField.buildNumber.rawValue] = HTTPHeaderValue.buildNumber.content
            
        if let token = LocalData.token?.access {
            headers["Authorization"] = "Bearer \(token)"
        }
        headers[HTTPHeaderField.forwardedHost.rawValue] = HTTPHeaderValue.forwardedHost.content
        return headers
    }
    
    static func setDefaultApiSettings() {
        NetworkRequest.shared.defaultRequestInterceptor = AuthApi.jsonParamsRequestInterceptor
    }
    
    static let jsonParamsRequestInterceptor: ((inout URLRequest, [String: Any], [URL]) -> Void) = {
        urlRequest, params, _ in
        do {
            let json = try JSONSerialization.data(withJSONObject: params, options: [])
            urlRequest.httpBody = json
            defaultHeaders.forEach({ urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) })
        } catch let error {
            print(error)
        }
    }
    
    static func refreshToken(completion: WebServiceResult<Token>) {
        guard let token = LocalData.token?.refresh, !token.isEmpty else { return }
        
        var headers = ["Content-Type": "application/json", "Connection": "keep-alive"]
        headers["forwardedHost"] = HTTPHeaderField.forwardedHost.rawValue
        headers["X-APP-Client"] = HTTPHeaderField.client.rawValue
        
        let jsonParamsRequestInterceptor: ((inout URLRequest, [String: Any], [URL]) -> Void) = {
            urlRequest, params, _ in
            do {
                let json = try JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = json
                headers.forEach({ urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) })
            } catch let error {
                print(error)
                
                return
            }
        }
        
        let req = WebServiceRequest<Token>(url: Endpoints.authRefreshToken)
        req.params = ["refresh": token]
        req.completion = completion
        req.requestInterceptor = jsonParamsRequestInterceptor
        NetworkRequest.shared.fire(req: req)
    }
    
    
    static func logout(completion: WebServiceResult<BaseResponse>) {
        let req = WebServiceRequest<BaseResponse>(url: Endpoints.logout)
        var header = AuthApi.defaultHeaders
        header["X-FORWARDED-HOST"] = HTTPHeaderValue.forwardedHost.content
        req.headers = header
        req.completion = completion
        NetworkRequest.shared.fire(req: req)
    }
}
