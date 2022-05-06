//
//  UIScreen+Helpers.swift
//  Graphy
//
//  Created by Akshit Talwar on 12/05/21.
//

import UIKit

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    
    static let safeWidth = screenWidth - (UIApplication.shared.windows.first?.safeAreaInsets.left ?? 0) - (UIApplication.shared.windows.first?.safeAreaInsets.right ?? 0)
    static let safeHeight = screenHeight - (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) - (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
}
