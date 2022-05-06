//
//  AppRatingUtil.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 13/10/21.
//

import Foundation

enum AppRatingUtil {
    static func shouldShowRatingPopUp() -> Bool {
        // after 1st, 4th and 8th session show app store popup otherwise show nudge
        let sessionCount = UserDefaults.standard.integer(forKey: "keySwiftRaterSignificantEventCount")
        return [1, 4, 8].contains(sessionCount)
    }
}
