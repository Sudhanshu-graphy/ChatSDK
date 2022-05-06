//
//  MentionsCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 05/08/21.
//

import UIKit

class MentionsCell: UITableViewCell {
    @IBOutlet private weak var channelView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var channelImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = AppColors.slate01
        nameLabel.font = AppFont.fontOf(type: .Medium, size: 14)
        userImageView.layer.cornerRadius = 4
        userImageView.clipsToBounds = true
        channelView.layer.cornerRadius = 4
        channelView.clipsToBounds = true
        userImageView.backgroundColor = AppColors.slate05
    }
    
    internal func configData(with data: MentionUserData?) {
          nameLabel.text = ""
          userImageView.image = nil
          let firstName = data?.firstName ?? ""
          let lastName = data?.lastName ?? ""
          let fullName = "\(firstName) \(lastName)"
          nameLabel.text = fullName
          let urlString = data?.avatar ?? ""
          channelImageView.isHidden = true
          channelView.isHidden = true
          userImageView.sd_setImage(with: URL(string: urlString), completed: nil)
          if data?.firstName == "channel" || data?.firstName == "here" {
              channelImageView.isHidden = false
              userImageView.isHidden = true
              channelView.isHidden = false
              channelImageView.image = AppAssets.channelMentionIcon
              let firstString = (data?.firstName == "channel") ? "@channel " : "@here "
              let secondString = (data?.firstName == "channel") ?
                  "notify everyone on this channel" : "notify everyone who is online"
              let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: AppColors.slate01, .font: AppFont.fontOf(type: .Medium, size: 14)]
              let secondOtherAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: AppColors.slate03, .font: AppFont.fontOf(type: .Medium, size: 14)]
              let attributedText = NSMutableAttributedString(string: firstString, attributes: firstAttributes)
              let secondAttributedText = NSMutableAttributedString(string: secondString, attributes: secondOtherAttributes)
              attributedText.append(secondAttributedText)
              nameLabel.attributedText = attributedText
          }
      }}
