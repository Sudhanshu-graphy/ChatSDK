//
//  ChatMessagesTextCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/06/21.
//

import UIKit
import SDWebImage
import SwiftyMarkdown

enum TextMessageAdditionalCollectionView : Int {
    case emoji = 0
    case replies = 1
}

protocol ChatMessageTextCellProtocol: AnyObject {
    func sendData(messageUUID: String)
    func openProfileModal(name: String, imageUrl: String, messageUUID: String, uuid: String?)
    func openImagePopUp(data: [Asset], index:Int, messageUUID: String)
    func openEmojiVoteModal(data: [Reaction])
}

class ChatMessagesTextCell: UITableViewCell {
    
    // MARK:Outlets
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var profilePic: UIImageView!
    @IBOutlet private weak var nameTextView: UITextView!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var message: AttributedLabel!
    @IBOutlet internal weak var emojiCollectionView: UICollectionView!
    @IBOutlet private weak var emojiCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var firstReplyImageView: UIImageView!
    @IBOutlet private weak var firstReplyImageHeight: NSLayoutConstraint!
    @IBOutlet private weak var repliesCountLabel: UILabel!
    @IBOutlet private weak var repliesCountHeight: NSLayoutConstraint!
    @IBOutlet private weak var firstReplyTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var seperatorView: UIView!
    @IBOutlet internal weak var imageCollectionView: UICollectionView!
    @IBOutlet private weak var imageCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var imageCollectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var emojiCollectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var emojiCollectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var seperatorViewTopConstraint: NSLayoutConstraint!
    @IBOutlet public weak var actionableCollectionView: UICollectionView!
    @IBOutlet private weak var actionableCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var actionableCollectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var actionableCollectionViewBottomConstraint: NSLayoutConstraint!
    
    internal var emojiVM : MessageEmojiVM?
    internal var messageData : ChannelMessagesData!
    weak var delegate: ChatMessageTextCellProtocol?
    internal var imageVM: MessagesImageVM?
    internal var messageUUID: String?
    internal var hapticGenerator = UIImpactFeedbackGenerator()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        addLongPressGesture()
        setupCollectionView()
        showRepliesSection(isHidden: true)
        showEmojiSection(isHidden: true)
        showImageSection(isHidden: true, isMessageEmpty: false)
        showSeperatorView(isHidden: true)
        showActionableCollectionView(isHidden: true)
        hapticGenerator.prepare()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        emojiVM = nil
        imageVM = nil
        messageUUID = ""
        repliesCountLabel.text = ""
        showEmojiSection(isHidden: true)
        showActionableCollectionView(isHidden: true)
    }
    
    // MARK:UI
    private func setupUI() {
        profilePic.backgroundColor = AppColors.slate05
        profilePic.layer.cornerRadius = 4
        profilePic.clipsToBounds = true
        profilePic.layer.borderWidth = 0.5
        profilePic.layer.borderColor = UIColor.init(0xDFDFDF).cgColor
        firstReplyImageView.backgroundColor = AppColors.slate05
        firstReplyImageView.layer.cornerRadius = 4
        firstReplyImageView.clipsToBounds = true
        firstReplyImageView.layer.borderWidth = 0.5
        firstReplyImageView.layer.borderColor = UIColor.init(0xDFDFDF).cgColor
        nameTextView.font =  AppFont.fontOf(type: .SemiBold, size: 14)
        nameTextView.textColor = AppColors.slate01
        nameTextView.textContainerInset = UIEdgeInsets(top: 0, left: -4,
                                                       bottom: 0, right: 0)
        nameTextView.clipsToBounds = true
        nameTextView.layer.cornerRadius = 2
        timeLabel.font = AppFont.fontOf(type: .Medium, size: 10)
        timeLabel.textColor = AppColors.slate03
        repliesCountLabel.font = AppFont.fontOf(type: .SemiBold, size: 10)
        repliesCountLabel.textColor = AppColors.dashBlueDefault
    }
    
    private func addLongPressGesture() {
        let tapGesture = UILongPressGestureRecognizer(target: self,
                                                      action: #selector(self.onTapClosure))
        emojiCollectionView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTapClosure(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            if let data = messageData.reactions {
                delegate?.openEmojiVoteModal(data: data)
            }
        }
    }
    
    internal func configure(with data : ChannelMessagesData, hide: Bool = true) {
        self.messageUUID = data.uuid
        self.messageData = data
        setMessageData(with: data)
        setUserDetails(with: data)
        checkForReactions(with: data)
        checkForReplies(with: data)
        checkForActionableCollectionView(data: data)
        checkForAssets(with: data)
    }
    
    private func setupCollectionView() {
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        emojiCollectionView.register(UINib(nibName: "ChatMessagesEmojiCell",
                                           bundle: nil), forCellWithReuseIdentifier: "ChatMessagesEmojiCell")
        imageCollectionView.register(UINib(nibName: "ChatMessagesImageCell",
                                           bundle: nil), forCellWithReuseIdentifier: "ChatMessagesImageCell")
        actionableCollectionView.register(UINib(nibName: "MessageUpcomingSessionCell", bundle: nil), forCellWithReuseIdentifier: "MessageUpcomingSessionCell")
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        actionableCollectionView.delegate = self
        actionableCollectionView.dataSource = self
    }
    
    public func showRepliesSection(isHidden : Bool) {
        firstReplyImageView.isHidden = isHidden
        repliesCountLabel.isHidden = isHidden
        firstReplyImageHeight.constant = isHidden ? 0 : 20
        repliesCountHeight.constant = isHidden ? 0 : 20
        firstReplyTopConstraint.constant = isHidden ? 0 : 5
    }
    
    internal func showSeperatorView(isHidden: Bool) {
        seperatorView.isHidden = isHidden
        seperatorViewTopConstraint.constant = isHidden ? 2 : 20
    }
    
    internal func showEmojiSection(isHidden: Bool) {
        if isHidden {
            emojiCollectionViewHeight.constant = 0
            emojiCollectionViewTopConstraint.constant = 0
            emojiCollectionViewBottomConstraint.constant = 0
            emojiCollectionView.isHidden = true
        } else {
            emojiCollectionView.isHidden = false
            emojiCollectionViewTopConstraint.constant = 5
            emojiCollectionViewBottomConstraint.constant = 10
        }
    }
    
    internal func showImageSection(isHidden: Bool, isMessageEmpty: Bool) {
        if isHidden {
            imageCollectionViewHeight.constant = 0
        }
        imageCollectionView.isHidden = isHidden
        let constant = isMessageEmpty ? -10 : 10
        imageCollectionViewTopConstraint.constant = CGFloat(isHidden ? 0 : constant)
    }
    
    private func reloadEmojiViews() {
        emojiCollectionView.reloadData()
        emojiCollectionViewHeight.constant = emojiCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    private func reloadAssetViews() {
        imageCollectionView.reloadData()
        imageCollectionViewHeight.constant = imageCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    private func setMessageData(with data: ChannelMessagesData) {
        self.timeLabel.text = data.createdAt?.messageTime()
        let md = SwiftyMarkdown(string: messageData.message ?? "")
        let attributedString = NSMutableAttributedString(attributedString: md.attributedString())
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle,
                                      range:NSRange(location: 0, length: attributedString.length))
        let all = Style.font(AppFont.fontOf(type: .Medium, size: 14))
            .foregroundColor(AppColors.slate01)
        let link = Style("a")
            .foregroundColor(AppColors.dashBlueDefault ?? .blue, .normal)
            .foregroundColor(.brown, .highlighted)
        let boldStyle = Style("b").font(AppFont.fontOf(type: .Medium, size: 14))
        let underlineStyle = Style("u").underlineStyle(.single)
        let italicStyle = Style("i").font(AppFont.fontOf(type: .Medium, size: 14))
        message.numberOfLines = 0
        var messageString = NSMutableAttributedString(attributedString: md.attributedString()).htmlSimpleTagString()
        
        if (messageData.mentions?.count ?? 0) > 0 {
            if let mentions = messageData.mentions {
                for (key, value) in mentions {
                    let firstName = value.firstName ?? ""
                    let lastName = value.lastName ?? ""
                    let fullName = firstName + " " + lastName
                    messageString = messageString.replacingOccurrences(of: key, with: fullName)
                }
            }
        }
        message.attributedText = messageString
            .style(tags: link, boldStyle, underlineStyle, italicStyle)
            .styleHashtags(link)
            .styleMentions(link)
            .styleLinks(link)
            .styleAll(all)
        
        message.onClick = { [weak self] _, detection in
            guard let self = self else { return }
            switch detection.type {
            case .hashtag(_):
                break
            case .mention(let name):
                self.mentionClick(with: name)
            case .link(let url):
                UIApplication.shared.open(url)
            case .tag(let tag):
                if tag.name == "a", let href = tag.attributes["href"], let url = URL(string: href) {
                    UIApplication.shared.open(url)
                }
            default:
                break
            }
        }
    }
    
    private func setUserDetails(with data: ChannelMessagesData) {
        let firstName = data.user?.firstName ?? ""
        let secondName = data.user?.lastName ?? ""
        let fullName = firstName + " " + secondName
        if data.user?.isEducator == 1 {
            nameTextView.backgroundColor = UIColor.init(0xF8D372)
            nameTextView.text = " \(fullName)"
        } else {
            nameTextView.backgroundColor = .clear
            nameTextView.text = fullName
        }
        self.profilePic.sd_setImage(with: URL(string: data.user?.avatar ?? ""),
                                    placeholderImage: AppAssets.avatarPlaceholder)
    }
    
    private func checkForReactions(with data: ChannelMessagesData) {
        if let reactionsData = data.reactions {
            if reactionsData.count > 0 {
                emojiVM = MessageEmojiVM(data: reactionsData)
                showEmojiSection(isHidden: false)
                self.reloadEmojiViews()
            }
        }
    }
    
    private func checkForReplies(with data: ChannelMessagesData) {
        if (data.replyCount ?? 0) > 0 {
            showRepliesSection(isHidden: false)
            let repliesText = (data.replyCount == 1) ? "reply" : "replies"
            repliesCountLabel.text = "\(data.replyCount ?? 0) \(repliesText)"
        } else {
            showRepliesSection(isHidden: true)
        }
    }
    
    private func checkForAssets(with data: ChannelMessagesData) {
        if let assetData = data.metadata?.assets {
            self.imageVM = MessagesImageVM(data: assetData)
            showImageSection(isHidden: false,
                                 isMessageEmpty: message.attributedText?.string.isEmpty ?? false)
            reloadAssetViews()
        }
    }
    
    private func mentionClick(with name: String) {
        if let mentions = self.messageData.mentions {
            for (_, value) in mentions {
                let firstName = value.firstName ?? ""
                let lastName = value.lastName ?? ""
                let fullName = firstName + " " + lastName
                if "@\(fullName)>" == name {
                    self.delegate?.openProfileModal(name: fullName, imageUrl: value.avatar ?? "", messageUUID: self.messageData.uuid ?? "", uuid: value.externalUUID)
                }
            }
        }
    }
    
    private func checkForActionableCollectionView(data: ChannelMessagesData) {
//        showActionableCollectionView(isHidden: false)
//        reloadActionableCollectionView()
    }
    
    private func reloadActionableCollectionView() {
        self.actionableCollectionView.reloadData()
        self.actionableCollectionView.setNeedsLayout()
        self.actionableCollectionViewHeight.constant = self.actionableCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    internal func showActionableCollectionView(isHidden: Bool) {
        if isHidden {
            [contentView, cellView, emojiCollectionView, imageCollectionView, actionableCollectionView, message].forEach {
                $0?.backgroundColor = .white
            }
            self.actionableCollectionViewHeight.constant = 0
            self.actionableCollectionView.isHidden = true
            self.actionableCollectionViewTopConstraint.constant = 5
            self.actionableCollectionViewBottomConstraint.constant = 0
        } else {
            [contentView, cellView, emojiCollectionView, imageCollectionView, actionableCollectionView, message].forEach {
                $0?.backgroundColor = AppColors.slate05
            }
            self.actionableCollectionViewTopConstraint.constant = 10
            self.actionableCollectionViewBottomConstraint.constant = 20
            self.actionableCollectionView.isHidden = false
        }
    }
    
    public func setBackgroundColor(color: UIColor) {
        [contentView, cellView, emojiCollectionView, imageCollectionView, actionableCollectionView, message].forEach {
            $0?.backgroundColor = color
        }
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        let firstName = messageData.user?.firstName ?? ""
        let secondName = messageData.user?.lastName ?? ""
        let fullName = firstName + " " + secondName
        delegate?.openProfileModal(name: fullName,
                                   imageUrl: messageData.user?.avatar ?? "",
                                   messageUUID: messageData.uuid ?? "",
                                   uuid: messageData.user?.externalUUID)
    }
}
