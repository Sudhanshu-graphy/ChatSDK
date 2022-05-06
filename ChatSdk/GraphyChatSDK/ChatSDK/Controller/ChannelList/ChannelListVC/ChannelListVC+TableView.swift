//
//  ChannelListVC + TableView.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/06/21.
//

import Foundation
import UIKit

extension ChannelListVC : UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "ChannelListCell", for: indexPath) as? ChannelListCell else {
            return UITableViewCell()
        }
        cell.configure(with: dataViewModel.getCellViewModel(at: indexPath),
                       unreadCount: dataViewModel.getUnreadCountData(), unicode: (courseData?.emojiUnicode ?? AppEmoji.defaultEmojiUnicode))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channelData = dataViewModel.getCellViewModel(at: indexPath)
        let vc = ChannelMessagesVC()
        dataViewModel.openedChannelSlug = channelData.slug ?? ""
        if let channelSlug = channelData.slug {
            vc.channelSlug = channelSlug
            dataViewModel.openedChannelSlug = channelSlug
            dataViewModel.updateChannelUnreadCount(channelSlug: channelSlug)
        }
        vc.emojiText = (courseData?.emojiUnicode ?? AppEmoji.defaultEmojiUnicode).unicodeToEmoji()
        vc.channelName = channelData.title ?? ""
        vc.courseSlug = courseData?.slug ?? ""
        vc.entityUUID = courseData?.uuid ?? ""
        vc.courseName = courseData?.title ?? ""
        vc.unreadCount = channelData.totalUnreadMessages ?? 0
        hapticGenerator.impactOccurred(intensity: 6)
        vc.isFromNotif = isFromNotif
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
