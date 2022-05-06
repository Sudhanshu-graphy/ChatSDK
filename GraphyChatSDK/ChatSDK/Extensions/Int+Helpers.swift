//
//  Int+Helpers.swift
//  Graphy
//
//  Created by Rahul Kumar on 26/03/21.
//

import Foundation

extension Int {
    var asWord: String {
        let numberValue = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        
        return formatter.string(from: numberValue) ?? String(self)
    }
}
