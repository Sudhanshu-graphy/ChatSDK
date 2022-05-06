//
//  ChatMessagesEmojiCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 23/06/21.
//

import UIKit
import emojidataios

class ChatMessagesEmojiCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBgView: UIView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var addEmojiImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK:UI
    private func setupUI() {
        cellBgView.setCornerRadiusAndBorderToView(cornerRadius:4, borderWidth: 0.5)
        cellBgView.backgroundColor = AppColors.slate05
        countLabel.font = AppFont.fontOf(type: .SemiBold, size: 10)
        countLabel.textColor = AppColors.slate01
        emojiLabel.font = AppFont.fontOf(type: .SemiBold, size: 12)
    }
    
    internal func configure(with data : [Reaction]) {
        addEmojiImage.image = nil
        emojiLabel.text = ""
        countLabel.text = ""
        let emoji = EmojiParser.parseAliases(data.first?.emojiName ?? "")
        self.emojiLabel.text = emoji
        self.countLabel.text = "\(data.count)"
        if data.contains(where: { $0.user?.externalUUID == LocalData.loggedInUser?.UUID}) {
            cellBgView.backgroundColor =  AppColors.dashBlueDefault
            cellBgView.layer.borderColor =  UIColor.init(0x6A82E3).cgColor
        } else {
            cellBgView.backgroundColor = AppColors.slate05
            cellBgView.layer.borderColor =  UIColor.clear.cgColor
        }
    }
    
    internal func isToShowAddEmoji(isToshow: Bool) {
        if isToshow {
            emojiLabel.text = ""
            countLabel.text = ""
            cellBgView.layer.borderColor =  UIColor.clear.cgColor
            addEmojiImage.image = AppAssets.addEmojiIcon
            addEmojiImage.isHidden = false
            cellBgView.backgroundColor = AppColors.slate05
        } else {
            addEmojiImage.isHidden = true
            addEmojiImage.image = nil
        }
    }
}
