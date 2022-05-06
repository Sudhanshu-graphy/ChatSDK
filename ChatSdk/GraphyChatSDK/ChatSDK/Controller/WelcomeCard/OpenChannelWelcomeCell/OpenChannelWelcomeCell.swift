//
//  OpenChannelWelcomeCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/10/21.
//

import UIKit

protocol OpenChannelWelcomeCellDelegate: AnyObject {
    func firstMessageViewTapAction()
    func inviteFriendTapAction()
}

final class OpenChannelWelcomeCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var channelTitleLabel: UILabel!
    @IBOutlet private weak var messageEmojiView: UIView!
    @IBOutlet private weak var firstMessageView: UIView!
    @IBOutlet private weak var firstMessageLabel: UILabel!
    @IBOutlet private weak var shareUpdatesLabel: UILabel!
    @IBOutlet private weak var inviteFriendsView: UIView!
    @IBOutlet private weak var inviteFriendsLabel: UILabel!
    @IBOutlet private weak var inviteFriendsToCommunityLabel: UILabel!
    
    // MARK: - Properties
    public weak var delegate: OpenChannelWelcomeCellDelegate?
    
    // MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        addTapGesture()
    }
    
    // MARK: - Setup
    private func setupUI() {
        messageEmojiView.setCornerRadiusAndBorderToView(cornerRadius: 3, borderWidth: 0, borderColor: .clear, withMask: true)
        firstMessageView.setCornerRadiusAndBorderToView(cornerRadius: 4, borderWidth: 0.5, borderColor: UIColor.init(0xDFDFDF), withMask: true)
        inviteFriendsView.setCornerRadiusAndBorderToView(cornerRadius: 4, borderWidth: 0.5, borderColor: UIColor.init(0xDFDFDF), withMask: true)
        channelTitleLabel.textColor = AppColors.slate01
        channelTitleLabel.font = AppFont.fontOf(type: .ExtraBold, size: 16)
        firstMessageLabel.textColor = AppColors.slate01
        firstMessageLabel.font = AppFont.fontOf(type: .Bold, size: 15)
        shareUpdatesLabel.textColor = AppColors.slate02
        shareUpdatesLabel.font = AppFont.fontOf(type: .Regular, size: 14)
        inviteFriendsLabel.textColor = AppColors.slate01
        inviteFriendsLabel.font = AppFont.fontOf(type: .Bold, size: 14)
        inviteFriendsToCommunityLabel.textColor = AppColors.slate02
        inviteFriendsToCommunityLabel.font = AppFont.fontOf(type: .Regular, size: 14)
        inviteFriendsToCommunityLabel.text = "Invite friends to \(AppUtil.schoolTitle)’s open community"
    }
    
    private func addTapGesture() {
        let firstMessageTapGesture = UITapGestureRecognizer(target: self,
                                                      action: #selector(self.firstMessageTapAction))
        let inviteFriendsTapGesture = UITapGestureRecognizer(target: self,
                                                       action: #selector(self.inviteTapAction))
        firstMessageView.addGestureRecognizer(firstMessageTapGesture)
        inviteFriendsView.addGestureRecognizer(inviteFriendsTapGesture)
    }
    
    // MARK: - Data
    public func config(with channelName: String) {
        channelTitleLabel.text = "Welcome to the \(channelName) channel!"
    }
    
    // MARK: - Action
    @objc private func firstMessageTapAction() {
        delegate?.firstMessageViewTapAction()
    }
    
    @objc private func inviteTapAction() {
//        delegate?.inviteFriendTapAction()
    }
}
