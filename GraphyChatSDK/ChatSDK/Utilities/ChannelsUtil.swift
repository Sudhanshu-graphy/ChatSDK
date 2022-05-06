//
//  ChannelsUtil.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 19/10/21.
//

import Foundation

enum ChannelUtil {
    
    static var unreadCountData = [UnreadCount]()
    
    static func setUnreadCount(data: [UnreadCount]) {
        self.unreadCountData = data
    }
    
    static func getCourseUnreadCount(slug: String) -> Int {
        if let index = unreadCountData.firstIndex(where: {$0.slug == slug}) {
            return unreadCountData[index].totalUnreadMessages ?? 0
        } else {
            return 0
        }
    }
}
