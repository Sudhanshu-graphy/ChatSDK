//
//  ChannelListCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 21/06/21.
//

import UIKit

class ChannelListCell: UITableViewCell {


    @IBOutlet private weak var channelEmojiView: UIView!
    @IBOutlet private weak var channelName: UILabel!
    @IBOutlet private weak var unreadCount: UIButton!
    @IBOutlet private weak var emojiLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK:setupUI
    private func setupUI() {
        unreadCount.setRounded()
        unreadCount.backgroundColor = UIColor.init(0xCDFDE5)
        unreadCount.titleLabel?.font = AppFont.fontOf(type: .SemiBold, size: 10)
        unreadCount.setTitleColor(AppColors.slate02, for: .normal)
        unreadCount.titleLabel?.minimumScaleFactor = 0.3
        unreadCount.titleLabel?.adjustsFontSizeToFitWidth = true
        unreadCount.titleLabel?.adjustsFontForContentSizeCategory = true
        channelName.textColor = AppColors.slate02
        channelName.font = AppFont.fontOf(type: .Medium, size: 14)
        channelEmojiView.layer.cornerRadius = 4
        channelEmojiView.clipsToBounds = true
        channelEmojiView.backgroundColor = AppColors.slate05
    }
    
    internal func configure(with data: ChannelData,
                            unreadCount: [String:Int],
                            unicode: String) {
        if let slug = data.slug {
            let unreadCount = unreadCount[slug] ?? 0
            let unreadCountString = (unreadCount < 99) ? "\(unreadCount)" : "99+"
            self.unreadCount.setTitle(unreadCountString, for: .normal)
            self.unreadCount.isHidden =  (unreadCount > 0) ? false : true

        }
        let channelName = data.title ?? ""
        self.channelName.text = "#\(channelName)"
        self.emojiLabel.text = unicode.unicodeToEmoji()
    }
}
