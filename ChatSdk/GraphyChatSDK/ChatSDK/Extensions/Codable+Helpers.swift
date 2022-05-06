//
//  Codable+Helpers.swift
//  Graphy
//
//  Created by Rahul Kumar on 24/02/21.
//

import Foundation

extension Encodable {
    /// Converted object to postable dictionary
    var json: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
