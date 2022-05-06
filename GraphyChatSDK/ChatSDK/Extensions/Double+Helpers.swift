//
//  Double+Helpers.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 14/09/21.
//

import Foundation
extension Double {
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
