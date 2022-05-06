//
//  ChannelMesagesVC.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/06/21.
//

import UIKit
import NextGrowingTextView
import ImageScout
import SafariServices
import UniformTypeIdentifiers

struct Message {
    let name: String
    let time: String
    let message: String
    let date: Date
}

struct ImageSource {
    let image: UIImage?
    let source: String?
    
}

struct UploadfileData {
    let fileName: String?
    let fileType: FileType
    let fileSource: PickerFileSource
    let image: UIImage?
    let fileData: Data?
    let mimeType: String?
}

struct Users: Decodable {
    var name: String
    var userName: String
    var id: String
    var avatar: String
}

enum SocketEvents: String {
    case CONNECT = "connect"
    case DISCONNECT = "disconnect"
    case JOIN_CHANNEL = "join_channel"
    case CHANNEL_JOINED = "channel_joined"
    case SEND_MESSAGE = "send_message"
    case MESSAGE_SENT = "message_sent"
    case SEND_REACTION = "send_reaction"
    case REACTION_SENT = "reaction_sent"
    case MESSAGE_DELETED = "message_deleted"
}

enum CommunityType: String {
    case school
    case courses
}

class ChannelMessagesVC: DeInitLoggerViewController {
    
    // MARK:Outlets
    // swiftlint:disable private_outlet
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var navItem: UINavigationItem!
    @IBOutlet internal weak var messagesTableView: UITableView!
    @IBOutlet private weak var sendMessageTextViewHeight: NSLayoutConstraint!
    @IBOutlet internal weak var sendMessageTextView: EasyMention!
    @IBOutlet private weak var sendMessageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sendMessagesButton: UIButton!
    @IBOutlet private weak var emptyStateView: UIView!
    @IBOutlet private weak var loaderView: UIView!
    @IBOutlet private weak var emptyPlaceholder: UILabel!
    @IBOutlet private weak var noPermissionLabel: UILabel!
    @IBOutlet private weak var noPermissionView: UIView!
    @IBOutlet private weak var sendMessagesView: UIView!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var noPermissionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var imagesCollectionView: UICollectionView!
    @IBOutlet private weak var imagesCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var imagesCollectionViewBtmConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imagesCollectionViewTpConstraint: NSLayoutConstraint!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet internal weak var mentionsTableView: UITableView!
    @IBOutlet private weak var mentionsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mentionsTableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var welcomCardView: UIView!
    @IBOutlet private weak var welcomeCardLabel: UILabel!
    @IBOutlet private weak var welcomeCardListView: WelcomeCardReusableView!
    @IBOutlet weak var helloButton: UIButton!
    @IBOutlet weak var prefilledBottomSheetButton: UIButton!
    @IBOutlet weak var prefilledMessageStackView: UIStackView!
    @IBOutlet weak var prefilledMessageStackViewHeight: NSLayoutConstraint!
    
    
    // MARK:Properties
    private var backButtonItem: UIBarButtonItem {
        let backButton = UIBarButtonItem(image: AppAssets.chevronLeft,
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.backButtonAction))
        backButton.tintColor = AppColors.slate02
        return backButton
    }
    
    private var infoButtonItem: UIBarButtonItem {
        let infoButton = UIBarButtonItem(image: AppAssets.infoIcon,
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.infoButtonAction))
        infoButton.tintColor = AppColors.slate02
        return infoButton
    }
    
    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(ChannelMessagesVC.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        return refreshControl
    }()
    
    lazy internal var activityIndicator: MaterialActivityIndicatorView = {
        return setupActivityIndicator()
    }()
    
    lazy internal var imageActivityIndicator: MaterialActivityIndicatorView = {
        return setupImageActivityIndicator()
    }()
    
    internal var channelName: String = ""
    internal var channelSlug: String = ""
    internal let messagesVM = ChannelMessagesVM()
    internal var lastMessageDate: String = ""
    internal var courseSlug: String = ""
    internal var firstTimeLoading: Bool = true
    internal var emojiText = ""
    internal var hapticGenerator = UIImpactFeedbackGenerator()
    internal var imagePicker: UIKitImagePicker?
    internal var addedFiles = [UploadfileData]()
    internal var courseName = ""
    internal var unreadCount = 0
    internal var isFromNotif = false
    private let imageFetcher = ImageScout()
    private var mentionItems = [MentionUserData]()
    internal var filteredMentions = [MentionUserData]()
    public var channelType: ChannelType?
    public var communityType: CommunityType = .courses
    internal var entityUUID = ""
    var analyticsChannelType = "course"
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChannelType()
        removeDeeplinkData()
        setupNavBar()
        setupUI()
        setupTableView()
        setupCollectionView()
        setupSendMessageTextView()
        addLongPressGesture()
        setupMessagesVM()
        hapticGenerator.prepare()
        setupImagePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        if firstTimeLoading {
            activityIndicator.startAnimating()
            firstTimeLoading.toggle()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelMessagesVC.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelMessagesVC.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
        
    @objc func keyboardWillHide(_ sender: Notification) {
        [helloButton, prefilledBottomSheetButton].forEach {
            $0?.backgroundColor = AppColors.slate05 ?? .white
        }
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.sendMessageViewBottomConstraint.constant = 0
                UIView.animate(withDuration: 0.15,
                               animations: { () -> Void in
                    self.view.layoutIfNeeded() })
            }
        }
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        [helloButton, prefilledBottomSheetButton].forEach {
            $0?.backgroundColor = .white
        }
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.sendMessageViewBottomConstraint.constant = keyboardHeight - UIDevice.current.safeAreaBottom +  (UIDevice.current.hasNotch ? 5 : 0)
                UIView.animate(withDuration: 0.15, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    private func setupChannelType() {
        analyticsChannelType = (communityType == .school) ? "open" : "course"
        channelType = ChannelType(rawValue: channelSlug)
        
    }
    
    private func removeDeeplinkData() {
        if let deeplinkDic = LocalData.deeplinkData,
           let deeplinkType = deeplinkDic["deeplinkType"] as? String {
            if deeplinkType == "channelMessage" {
                LocalData.deeplinkData = nil
            }
        }
    }
    
    // MARK:UI
    private func setupNavBar() {
        let emojiTitle = UILabel()
        emojiTitle.text = "\(emojiText)"
        emojiTitle.font = AppFont.fontOf(type: .SemiBold, size: 14)
        emojiTitle.sizeToFit()
        let navTitle = UILabel()
        navTitle.text = "\(channelName)"
        navTitle.font = AppFont.fontOf(type: .SemiBold, size: 16)
        navTitle.sizeToFit()
        let titleItem = UIBarButtonItem(customView: navTitle)
        let emojiItem = UIBarButtonItem(customView: emojiTitle)
        navItem.leftBarButtonItems = [backButtonItem, emojiItem, titleItem]
        if communityType == .courses {
            navItem.rightBarButtonItem = infoButtonItem
        }
        navigationBar.barTintColor = .white
        navigationBar.isTranslucent = false
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setupUI() {
        showPrefilledView(hidden: true)
        changeSendButtonState(enable: false)
        sendMessagesButton.layer.cornerRadius = 4
        emptyPlaceholder.textColor = AppColors.slate02
        emptyPlaceholder.font =  AppFont.fontOf(type: .Regular, size: 14)
        emptyPlaceholder.text = ""
        noPermissionView.backgroundColor = AppColors.slate05
        noPermissionView.insetsLayoutMarginsFromSafeArea = false
        noPermissionLabel.font = AppFont.fontOf(type: .Medium, size: 14)
        noPermissionLabel.textColor = AppColors.slate03
        noPermissionLabel.text = "Only certain people can send messages in this channel"
        sendMessagesView.isHidden = false
        noPermissionView.isHidden = true
        noPermissionViewHeight.constant = 75
        isToShowImagesCollectionView(hidden: true)
        [helloButton, prefilledBottomSheetButton].forEach {
            $0?.backgroundColor = AppColors.slate05
            $0?.titleLabel?.font = AppFont.fontOf(type: .Medium, size: 14)
            $0?.setTitleColors(with: .black)
            $0?.setCornerRadiusAndBorderToView(cornerRadius: 4, borderWidth: 0.5, borderColor: UIColor.init(0xDFDFDF))
        }
        
        welcomeCardLabel.font = AppFont.fontOf(type: .Medium, size: 20)
        welcomeCardLabel.textColor = .black
    }
    
    private func setupTableView() {
        let cellNib = UINib(nibName: "ChatMessagesTextCell", bundle: nil)
        messagesTableView.register(cellNib, forCellReuseIdentifier: "ChatMessagesTextCell")
        messagesTableView.rowHeight = UITableView.automaticDimension
        messagesTableView.estimatedRowHeight = UITableView.automaticDimension
        messagesTableView.transform =  CGAffineTransform(scaleX: 1, y: -1)
        let filterSectionHeaderNib = UINib.init(nibName: "MessagesTableHeaderView",
                                                bundle: Bundle.main)
        self.messagesTableView.register(filterSectionHeaderNib,
                                        forHeaderFooterViewReuseIdentifier: "MessagesTableHeaderView")
        self.messagesTableView.register(UINib(nibName: "WelcomeMessageCell", bundle: nil), forCellReuseIdentifier: "WelcomeMessageCell")
        self.messagesTableView.register(UINib(nibName: "OpenChannelWelcomeCell", bundle: nil), forCellReuseIdentifier: "OpenChannelWelcomeCell")
        self.messagesTableView.keyboardDismissMode = .onDrag
        self.messagesTableView.addSubview(self.refreshControl)
        
        mentionsTableView.layer.masksToBounds = true
        mentionsTableView.layer.borderWidth = 0.2
        mentionsTableView.layer.borderColor = AppColors.slate02.cgColor
        mentionsTableView.layer.cornerRadius = 4
        mentionsTableView.tableFooterView = UIView()
        mentionsTableView.separatorInset = UIEdgeInsets.zero
        mentionsTableView.separatorStyle = .none
        mentionsTableView.isHidden = true
        let mentionsCellNib = UINib(nibName: "MentionsCell", bundle: nil)
        mentionsTableView.register(mentionsCellNib, forCellReuseIdentifier: "MentionsCell")
    }
    
    private func setupCollectionView() {
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.register(UINib(nibName: "SendImagesCell", bundle: nil), forCellWithReuseIdentifier: "SendImagesCell")
        self.imagesCollectionView.register(UINib(nibName: "SendFilesCell", bundle: nil), forCellWithReuseIdentifier: "SendFilesCell")
    }
    
    private func setupSendMessageTextView() {
        self.sendMessageTextView.textView.font = AppFont.fontOf(type: .Medium, size: 14)
        self.sendMessageTextView.textView.textColor = AppColors.slate02
        self.sendMessageTextView.textView.layer.cornerRadius = 4
        self.sendMessageTextView.textView.inputAccessoryView =  UIView()
        self.sendMessageTextView.textView.allowsEditingTextAttributes = true
        self.sendMessageTextView.mentionDelegate = self
        self.sendMessageTextView.placeholderAttributedText = NSAttributedString(
            string: "Send a message to \(channelName)",
            attributes: [
                .font: AppFont.fontOf(type: .Medium, size: 14),
                .foregroundColor: AppColors.slate03
            ]
        )
        self.sendMessageTextView.maxNumberOfLines = 6
    }
    
    private func setupActivityIndicator() -> MaterialActivityIndicatorView {
        let activity = MaterialActivityIndicatorView(frame: CGRect(x: 0, y: 0,
                                                                   width: 13, height: 13))
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .black
        activity.isUserInteractionEnabled = false
        view.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: emptyPlaceholder.centerYAnchor,
                                          constant: 40).isActive = true
        return activity
    }
    
    private func setupImageActivityIndicator() -> MaterialActivityIndicatorView {
        let activity = MaterialActivityIndicatorView(frame: CGRect(x: 0, y: 0,
                                                                   width: 40, height: 40))
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .black
        activity.isUserInteractionEnabled = false
        view.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                          constant: 0).isActive = true
        return activity
    }
    
    private func setupImagePicker() {
        imagePicker = UIKitImagePicker(presentationController: self, delegate: self)
    }
    
    private func setupMessagesVM() {
        
        messagesVM.getChannelData(channelSlug: self.channelSlug,
                                  entityUUID: self.entityUUID)
        
        messagesVM.configureData = { [weak self] in
            guard let self = self else { return }
            
            self.channelName = "#\(self.messagesVM.channelName)"
            self.setupNavBar()
            
            if !self.messagesVM.canPost {
                self.showNoPermissionView()
            }
            self.messagesVM.getData(entityUUID: self.messagesVM.entityUUID,
                                    channelUUID: self.messagesVM.channelUUID, type: self.channelType, communityType: self.communityType)
        }
        
        messagesVM.reloadTableView = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.messagesTableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.messagesTableView.isHidden = false
            self.emptyStateView.isHidden = true
        }
        
        messagesVM.firstreloadTableView = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.messagesTableView.reloadData()
            self.messagesTableView.setNeedsLayout()
            self.messagesTableView.layoutIfNeeded()
            self.messagesTableView.reloadData()
            self.messagesTableView.isHidden = false
            self.helloButton.setTitle(self.messagesVM.getHelloButtonText(type: self.channelType ?? .general), for: .normal)
        }
        
        messagesVM.performBatchUpdate = { [weak self] in
            guard let self = self else { return }
            self.messagesTableView.performBatchUpdates({
                let indexPath = IndexPath.init(row: 0, section: 0)
                let indexSet = IndexSet(integer: 0)
                let messageCountInSection = self.messagesVM.numberOfRows(at: 0)
                if messageCountInSection == 1 {
                    self.messagesTableView.insertSections(indexSet, with: .top)
                } else {
                    self.messagesTableView.insertRows(at: [indexPath], with: .top)
                }
            }, completion: nil)
            self.messagesTableView.isHidden = false
        }
        
        messagesVM.scrollToTop = { [weak self] in
            guard let self = self else { return }
            self.messagesTableView.scrollToTop()
        }
        
        messagesVM.showEmptyMessageState = { [weak self] in
            guard let self = self else { return }
            self.helloButton.setTitle(self.messagesVM.getHelloButtonText(type: self.channelType ?? .general), for: .normal)
            self.welcomeCardLabel.text = "Welcome to \(self.channelName)"
            if let channelType = ChannelType(rawValue: self.channelSlug) {
                self.welcomeCardListView.config(with: channelType.welcomeCardArray, channelType: channelType)
                self.welcomCardView.isHidden = false
            } else {
                self.emptyStateView.isHidden = true
                self.emptyPlaceholder.text = "This is the beginning of your chat history in \(self.channelName)"
            }
            self.activityIndicator.stopAnimating()
        }
        
        messagesVM.showError = { [weak self] (error) in
            guard let self = self else { return }
            ToastBasic.make(text: error).show()
            self.activityIndicator.stopAnimating()
        }
        
        messagesVM.hideLoading = { [weak self] in
            guard let self = self else { return }
            self.imageActivityIndicator.stopAnimating()
        }
        
        messagesVM.showPrefilledView = { [weak self] in
            guard let self = self else { return }
            self.checkPrefilledMessageView()
        }
    }
    
    private func checkPrefilledMessageView() {
        if let type = self.channelType {
            if AppUtil.isInstructor() {
                self.showPrefilledView(hidden: false)
            } else if type != .announcements {
                self.showPrefilledView(hidden: false)
            }
        }
    }
    
    private func addLongPressGesture() {
        let tapGesture = UILongPressGestureRecognizer(target: self,
                                                      action: #selector(self.onTapClosure))
        messagesTableView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTapClosure(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let tapLocation = sender.location(in: self.messagesTableView)
            if let tapIndexPath = self.messagesTableView.indexPathForRow(at: tapLocation) {
                if let _ = self.messagesTableView.cellForRow(at: tapIndexPath) as? ChatMessagesTextCell {
                    let vc = ChatMessagesBottomSheet()
                    vc.messageUUID = messagesVM.getCellViewModel(at: tapIndexPath).uuid
                    vc.message = messagesVM.getCellViewModel(at: tapIndexPath).message ?? ""
                    vc.courseName = courseName
                    vc.indexPath = tapIndexPath
                    vc.channelName = channelName
                    vc.entityUUID = self.messagesVM.entityUUID
                    vc.channelSlug = channelSlug
                    vc.channelUUID = messagesVM.channelUUID
                    vc.communityType = communityType
                    vc.analyticsChannelType = analyticsChannelType
                    vc.delegate = self
                    self.presentPanModal(vc)
                }
            }
        }
    }
    
    // MARK:Actions
    @objc private func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func infoButtonAction() {
        let vc = ChannelDetailsVC()
        vc.channelSlug = channelSlug
        vc.entitySlug = courseSlug
        vc.entityUUID = self.messagesVM.entityUUID
        vc.emojiText = self.emojiText
        vc.channelUUID = messagesVM.channelUUID
        vc.courseName = courseName
        vc.channelName = channelName
        vc.analyticChannelType = analyticsChannelType
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        hapticGenerator.impactOccurred(intensity: 6)
        let messageAttributedString = NSMutableAttributedString(attributedString: self.sendMessageTextView.textView.attributedText).htmlSimpleTagString()
        let messageString = messageAttributedString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let mentions = getMentionArray()
        if !messageString.isEmpty && addedFiles.count == 0 {
            let containsUrl = messageString.containsUrl(str: messageString)
            messagesVM.sendMessages(message: getMentionMessage(),
                                    channel_uuid: messagesVM.channelUUID, mentions: mentions)
        }
        
        if addedFiles.count > 0 {
            imageActivityIndicator.startAnimating()
            messagesVM.uploadImages(channelSlug: channelSlug, courseUUID: self.messagesVM.entityUUID, courseName: courseName, images: addedFiles, message: messageString, channel_uuid: messagesVM.channelUUID, mentions: getMentionArray(), channelType: analyticsChannelType)
            addedFiles.removeAll()
            isToShowImagesCollectionView(hidden: true)
        }
        hideKeyboard()
        self.sendMessageTextView.resetAllValues()
        self.sendMessageTextView.textView.endEditing(true)
        self.mentionsTableView.isHidden = true
        self.filteredMentions.removeAll()
        self.placeholderLabel.isHidden = false
        changeSendButtonState(enable: true)
    }
    
    @IBAction func imageButtonClicked(_ sender: Any) {
        let vc = ImageSourceBottomSheet()
        vc.delegate = self
        self.presentPanModal(vc)
    }
    
    @IBAction func helloEveryoneButtonAction(_ sender: Any) {
        self.sendMessageTextView.textView.text = helloButton.titleLabel?.text
        showPrefilledView(hidden: true)
        changeSendButtonState(enable: true)
    }
    
    @IBAction func prefilledBottomSheetButtonAction(_ sender: Any) {
        if let data = messagesVM.getPrefilledMessage() {
            GraphyNavigator.presentPrefilledBottomSheet(viewController: self, data: data)
        }
    }
    
    // MARK: hideKeyboard
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        messagesVM.refreshData(type: channelType)
    }
    
    private func isToShowImagesCollectionView(hidden: Bool) {
        self.imagesCollectionView.isHidden = hidden
        self.imagesCollectionViewHeight.constant = hidden ? 0 : 60
        self.imagesCollectionViewBtmConstraint.constant = hidden ? 0 : 8
        self.imagesCollectionViewTpConstraint.constant = hidden ? 8 : 20
    }
    
    private func changeSendButtonState(enable: Bool) {
        sendMessagesButton.backgroundColor = enable ? AppColors.dashBlueDefault : UIColor.init(0xA8A8A8)
        sendMessagesButton.isEnabled = enable
    }
    
    private func showNoPermissionView() {
        self.noPermissionView.isHidden = false
        self.tableViewBottomConstraint.constant = UIDevice.current.hasNotch ? 0 : 25
        self.sendMessagesView.isHidden = true
    }
}

extension ChannelMessagesVC: ChatMessageTextCellProtocol {
    func openImagePopUp(data: [Asset], index:Int, messageUUID: String) {
        if data[index].type?.rawValue.isImageType() ?? false  &&
            data[index].url?.fileExtension() != "svg" {
            var assetData = [Asset]()
            assetData = data.filter({ value in
                value.type?.rawValue.isImageType() ?? false
            })
            let storyBoard = UIStoryboard(name: "ImagePopUpController", bundle: nil)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "ImagePopUpController") as? ImagePopUpController else { return }
            vc.assetData  = assetData
            vc.index = index
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        } else if data[index].type == .PDF {
            GraphyNavigator.openPDFController(assetTitle: data[index].title ?? "", assetUrl: data[index].url ?? "")
        } else {
            if let url  = data[index].url {
                openLink(url: url)
            }
        }
    }
    
    func openProfileModal(name: String, imageUrl: String, messageUUID: String, uuid: String?) {
        if let uuid = uuid {
//            ProfileNavigator.openProfileCard(uuid: uuid)
        }
    }
    
    func sendData(messageUUID: String) {
        let vc = EmojiViewController()
        vc.messageUUID = messageUUID
        vc.entityUUID = self.messagesVM.entityUUID
        vc.channelName = channelName
        vc.courseName = courseName
        vc.channelSlug = channelSlug
        vc.channelUUID = messagesVM.channelUUID
        vc.analyticsChannelType = analyticsChannelType
        self.presentPanModal(vc)
    }
    
    func openEmojiVoteModal(data: [Reaction]) {
        let vc = EmojiVoteController()
        vc.emojiData = data
        self.presentPanModal(vc)
    }
    
}

extension ChannelMessagesVC: MessageBottomSheetProtocol {
    func sendInfo(indexPath: IndexPath) {
        let vc = MessageThreadsVC()
        vc.channelName = self.channelName
        vc.messageData = messagesVM.getCellViewModel(at: indexPath)
        vc.modalPresentationStyle = .overFullScreen
        vc.channelUUID = messagesVM.channelUUID
        vc.entityUUID = self.messagesVM.entityUUID
        vc.courseName = courseName
        vc.channelSlug = channelSlug
        vc.communityType = communityType
        vc.analyticsChannelType = analyticsChannelType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sendDeleteMessageInfo(indexPath: IndexPath) {
        let vc = DeleteMessageBottomSheet()
        vc.indexPath = indexPath
        vc.channelId = messagesVM.channelUUID
        vc.messageData = messagesVM.getCellViewModel(at: indexPath)
        vc.delegate = self
        self.presentPanModal(vc)
    }
    
    internal func dismissSheet() {
        ToastBasic.make(text: "Text copied to clipboard").show(at: .top)
    }
    
    fileprivate func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func reloadImageCollectionView() {
        self.imagesCollectionView.performBatchUpdates({
            let indexPath = IndexPath(row: addedFiles.count - 1, section: 0)
            self.imagesCollectionView.insertItems(at: [indexPath])
        }, completion: nil)
        let indexPath = IndexPath(row: addedFiles.count, section: 0)
        self.imagesCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        changeSendButtonState(enable: addedFiles.count > 0)
    }
    
    fileprivate func openLink(url: String) {
        if let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            guard let url = URL(string: urlString) else { return }
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.modalPresentationStyle = .formSheet
            present(vc, animated: true, completion: nil)
        }
    }
    
    fileprivate func removeFile(index: Int) {
        addedFiles.remove(at: index)
        changeSendButtonState(enable: addedFiles.count > 0)
        if addedFiles.count == 0 {
            isToShowImagesCollectionView(hidden: true)
        }
        self.imagesCollectionView.reloadData()
    }
    
    private func getMentionUser(searchQuery: String, handler: @escaping ((MentionUser?) -> Void)) {
        MentionApi.getMentionUsers(channelUUID: messagesVM.channelUUID, searchQuery: searchQuery) { response in
            if response.status == .success, let data = response.json {
                handler(data)
            } else {
                if let errorMessage = response.errorMsg {
                    ToastBasic.make(text: errorMessage).show()
                }
            }
        }
    }
    
    private func getMentionMessage() -> String {
        var text = self.sendMessageTextView.textView.text
        let currentMentions = sendMessageTextView.getCurrentMentions()
        for value in currentMentions {
            if value.firstName == "channel" {
                text = text?.replacingOccurrences(of: "@channel", with: "<@channel>")
            } else if value.firstName == "here" {
                text = text?.replacingOccurrences(of: "@here", with: "<@here>")
            } else {
                let firstName = value.firstName ?? ""
                let lastName = value.lastName ?? ""
                let name = "@\(firstName) \(lastName)"
                let uuid = value.uuid ?? ""
                text = text?.replacingOccurrences(of: name, with: "<@\(uuid)>")
            }
        }
        return text ?? ""
    }
    
    private func getMentionArray() -> [String] {
        var mentionArray = [String]()
        let currentMentions = sendMessageTextView.getCurrentMentions()
        for value in currentMentions {
            if value.firstName == "channel" {
                mentionArray.append("channel")
            } else if value.firstName == "here" {
                mentionArray.append("here")
            } else {
                if let uuid = value.uuid {
                    mentionArray.append(uuid)
                }
            }
        }
        return mentionArray
    }
    
    private func showPrefilledView(hidden: Bool) {
        self.mentionsTableViewBottomConstraint.constant = hidden ? 0 : 75
        self.tableViewBottomConstraint.constant = hidden ? 0 : 75
        self.prefilledMessageStackViewHeight.constant = hidden ? 0 : 45
        self.prefilledMessageStackView.isHidden = hidden
    }
}

extension ChannelMessagesVC: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}

extension ChannelMessagesVC: ImagePickerDelegate {
    func didSelect(image: UIImage?, imageUrl: String) {
        if let selectedImage = image {
            if addedFiles.count == 0 {
                isToShowImagesCollectionView(hidden: false)
                imagesCollectionView.reloadData()
            }
            addedFiles.append(UploadfileData(fileName: "", fileType: .Image, fileSource: .gallery, image: selectedImage, fileData: nil, mimeType: "image/png"))
            reloadImageCollectionView()
        }
    }
}

extension ChannelMessagesVC: sendImagesCellProtocol {
    func sendInfo(index: Int) {
        self.removeFile(index: index)
    }
}

extension ChannelMessagesVC: ImageSourceBottomSheetProtocol {
    func sendInfo(fileType: PickerFileSource) {
        switch fileType {
        case .camera:
            openCamera()
        case .gallery:
            imagePicker?.present()
        case .files:
            GraphyNavigator.openFilePicker(viewController: self)
        }
    }
}

extension ChannelMessagesVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            if addedFiles.count == 0 {
                isToShowImagesCollectionView(hidden: false)
                imagesCollectionView.reloadData()
            }
            addedFiles.append(UploadfileData(fileName: "", fileType: .Image, fileSource: .camera, image: pickedImage.upOrientationImage(), fileData: nil, mimeType: "image/png"))
            reloadImageCollectionView()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


extension ChannelMessagesVC: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let url = urls.first else { return }
        let fileDocument = Document(fileURL: url)
        let data = try? Data(contentsOf: url)
        let fileName = fileDocument.fileURL.lastPathComponent
        let fileType = fileName.fileExtension()
        let mimeType = fileDocument.fileURL.mimeType()
        print(mimeType)
        
        if addedFiles.count == 0 {
            isToShowImagesCollectionView(hidden: false)
            imagesCollectionView.reloadData()
        }
        addedFiles.append(UploadfileData(fileName: fileName,
                                         fileType: FileType(rawValue: fileType) ?? .Image,
                                         fileSource: .files, image: nil,
                                         fileData: data, mimeType: mimeType))
        reloadImageCollectionView()
    }
}

extension ChannelMessagesVC: sendFilesCellProtocol {
    func sendFileInfo(index: Int) {
        self.removeFile(index: index)
    }
}

extension ChannelMessagesVC: EasyMentionDelegate {
    func startMentioning(in textView: EasyMention, mentionQuery: String, showFullList: Bool) {
        self.getMentionUser(searchQuery: mentionQuery) { data in
            self.mentionItems.removeAll()
            if let data = data {
                self.mentionItems = data
            }
            if mentionQuery.contains("c") {
                if AppUtil.isInstructor() {
                    self.mentionItems.insert(MentionUserData(uuid: "", firstName: "channel", lastName: "", externalUUID: nil, avatar: "", isEducator: 0), at: 0)
                }
            } else if mentionQuery.contains("h") {
                self.mentionItems.insert(MentionUserData(uuid: "", firstName: "here", lastName: "", externalUUID: nil, avatar: "", isEducator: 0), at: 0)
            }
            self.sendMessageTextView.setMentions(mentions: self.mentionItems)
        }
    }
    
    func mentionSelected(in textView: EasyMention, mention: MentionUserData) {
    }
    
    func textViewDidChange() {
        if self.sendMessageTextView.textView.text.count > 0 {
            changeSendButtonState(enable: true)
        } else if addedFiles.count > 0 {
            changeSendButtonState(enable: true)
        } else {
            changeSendButtonState(enable: false)
        }
        placeholderLabel.isHidden = !sendMessageTextView.textView.text.isEmpty
    }
    
    func hideTableView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.mentionsTableView.isHidden = true
        })
    }
    
    func showTableView(mentionData: [MentionUserData]) {
        self.filteredMentions = mentionData
        self.mentionsTableView.reloadData()
        let height = (filteredMentions.count * 40)
        self.mentionsTableViewHeight.constant = (height >= 200) ? 200 : CGFloat(height)
        UIView.animate(withDuration: 0.2, animations: {
            self.mentionsTableView.isHidden = false
        })
    }
}

extension ChannelMessagesVC: PrefilledMessageBottomSheetProtocol {
    func sendMessageData(with data: String) {
        self.sendMessageTextView.textView.text = data
        showPrefilledView(hidden: true)
        changeSendButtonState(enable: true)
    }
}

extension ChannelMessagesVC: DeleteMessageBottomSheetDelegate {
    func deleteMessage(indexPath: IndexPath) {
        messagesVM.deleteMessage(indexPath: indexPath)
    }
}

extension ChannelMessagesVC: OpenChannelWelcomeCellDelegate {
    func firstMessageViewTapAction() {
        self.sendMessageTextView.becomeFirstResponder()
    }
    
    func inviteFriendTapAction() {
      
    }
}
