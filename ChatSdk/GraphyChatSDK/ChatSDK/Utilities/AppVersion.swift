//
//  AppVersion.swift
//  Graphy
//
//  Created by Raj Dhakate on 11/10/21.
//

import Foundation

struct AppVersion {
    private var major: Int = 0
    private var minor: Int = 0
    private var patch: Int = 0
    
    init(_ version: String) {
        let array = version.split(separator: ".")
        if array.count > 0 {
            if let major = Int(array[0]) {
                self.major = major
            }
            if array.count > 1 {
                if let minor = Int(array[1]) {
                    self.minor = minor
                }
                if array.count > 2 {
                    if let patch = Int(array[2]) {
                        self.patch = patch
                    }
                }
            }
        }
    }
}

extension AppVersion: Comparable {
    static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
        
        // check major
        if lhs.major < rhs.major {
            return true
        }
        
        // check minor
        if lhs.major == rhs.major {
            if lhs.minor < rhs.minor {
                return true
            }
        }
        
        // check patch
        if lhs.major == rhs.major, lhs.minor == rhs.minor {
            if lhs.patch < rhs.patch {
                return true
            }
        }
        
        return false
    }
}
