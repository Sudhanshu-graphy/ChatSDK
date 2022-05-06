//
//  AppFont.swift
//  GraphyChatSDK
//
//  Created by Sudhanshu Dwivedi on 04/05/22.
//

import Foundation
import UIKit

enum AppFontStyle: String {
    case Black
    case BlackItalic
    case Bold
    case BoldItalic
    case ExtraBold
    case ExtraBoldItalic
    case ExtraLight
    case ExtraLightItalic
    case Italic
    case Light
    case LightItalic
    case Medium
    case MediumItalic
    case Regular
    case SemiBold
    case SemiBoldItalic
    case Thin
    case ThinItalic
}
enum AppFont {
    static func fontOf(type: AppFontStyle, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
