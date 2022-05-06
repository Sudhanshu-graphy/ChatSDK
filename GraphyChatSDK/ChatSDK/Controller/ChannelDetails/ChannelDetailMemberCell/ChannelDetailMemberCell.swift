//
//  ChannelDetailMemberCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/06/21.
//

import UIKit

final class ChannelDetailMemberCell: UITableViewCell {
    
    // MARK:Properties
    @IBOutlet private weak var memberProfilePic: UIImageView!
    @IBOutlet private weak var memberNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK:UI
    private func setupUI() {
        memberProfilePic.layer.cornerRadius = 4
        memberProfilePic.clipsToBounds = true
        memberNameLabel.font = AppFont.fontOf(type: .Medium, size: 14)
        memberNameLabel.textColor = AppColors.slate01
    }
    
    internal func config(with data: ChannelMembers) {
        let firstName = data.userDetails?.firstName ?? ""
        let secondName = data.userDetails?.lastName ?? ""
        let fullName = firstName + " " + secondName
        memberNameLabel.text = fullName
//        memberProfilePic.sd_setImage(with: URL(string: data.userDetails?.avatar ?? ""),
//                                     placeholderImage: AppAssets.avatarPlaceholder)
    }
    
    internal func configFromEmoji(with data: Reaction) {
        let firstName = data.user?.firstName ?? ""
        let secondName = data.user?.lastName ?? ""
        let fullName = firstName + " " + secondName
        memberNameLabel.text = fullName
//        memberProfilePic.sd_setImage(with: URL(string: data.user?.avatar ?? ""),
//                                     placeholderImage: AppAssets.avatarPlaceholder)
    }
}
