//
//  BaseResponse.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/07/21.
//

import Foundation

struct BaseResponse: Codable {
    var error: String?
    var code: String?
    var created: Bool?
    var message: String?

    enum CodingKeys: String, CodingKey {
        case error
        case code
        case created
        case message
    }
}
