//
//  Error.swift
//  Graphy
//
//  Created by Rahul Kumar on 15/04/21.
//

import Foundation

enum ResponseErrorCode: String, Decodable {
    case invalidEmail = "invalid_email"
    case invalidOTP = "invalid_otp"
    case tooManyFailedLoginAttempts = "too_many_failed_login_attempts"
}

struct ResponseError: Decodable {
    let detail: String
    let code: String
    let errors: [ErrorObject]?
    
    var localizedDescription: String {
        errors?.first?.error.first ?? detail
    }
}

struct ErrorObject: Decodable {
    let field: String
    let error: [String]
}
