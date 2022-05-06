//
//  Device+Helpers.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 16/07/21.
//

import Foundation
import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottom = window?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
    var safeAreaBottom: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottom = window?.safeAreaInsets.bottom ?? 0
        return bottom
    }
    
    var statusBarHeight: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottom = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 44
        return bottom
    }
    
    var deviceID: String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
}
