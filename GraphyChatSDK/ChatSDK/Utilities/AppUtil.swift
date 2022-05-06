//
//  AppUtil.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/09/21.
//

import Foundation
import UIKit

enum AppUtil {
    
    static func isInstructor() -> Bool {
        return  true
    }
    
    static var schoolTitle: String {
        return ""
    }
    
    // swiftlint:disable discouraged_direct_init
    static var deviceId: String {
        return UIDevice().deviceID
    }
    
    static var subdomain: String {
        return ""
    }
    
    static var schoolUUID: String {
        return ""
    }
}
