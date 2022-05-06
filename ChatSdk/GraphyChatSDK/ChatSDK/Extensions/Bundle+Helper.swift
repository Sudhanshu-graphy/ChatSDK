//
//  Bundle+Helper.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 28/07/21.
//

import Foundation
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
