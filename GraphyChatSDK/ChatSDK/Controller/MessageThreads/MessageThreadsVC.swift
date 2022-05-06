//
//  MessageThreadsVC.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/06/21.
//

import UIKit
import NextGrowingTextView
import ImageScout
import SafariServices
import UniformTypeIdentifiers

enum MessageThreadsSectionType : Int {
    case message  = 0
    case replies = 1
}

class MessageThreadsVC: DeInitLoggerViewController {
    
    // MARK:Outlets
    @IBOutlet private weak var navBar: UINavigationBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var navItem: UINavigationItem!
    private var backButtonItem: UIBarButtonItem {
        let backButton = UIBarButtonItem(image: AppAssets.chevronLeft,
                                         style: .plain, target: self, action: #selector(self.backButtonAction))
        backButton.tintColor = AppColors.slate02
        return backButton
    }
    
    lazy internal var imageActivityIndicator: MaterialActivityIndicatorView = {
        return setupImageActivityIndicator()
    }()
    
    @IBOutlet internal weak var sendMessageTextView: EasyMention!
    @IBOutlet private weak var sendMessageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sendMessageButton: UIButton!
    @IBOutlet private weak var imagesCollectionView: UICollectionView!
    @IBOutlet private weak var imagesCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var imagesCollectionViewBtmConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imagesCollectionViewTpConstraint: NSLayoutConstraint!
    @IBOutlet internal weak var mentionsTableView: UITableView!
    @IBOutlet private weak var mentionsTableViewHeight: NSLayoutConstraint!
    
    // MARK:Properties
    internal var channelName: String = ""
    internal var repliesCount: Int = 0
    internal let repliesVM = MessagesRepliesVM()
    internal var messageData: ChannelMessagesData?
    internal var messageVM: MessageVM?
    internal var channelUUID: String = ""
    internal var entityUUID: String = ""
    internal var hapticGenerator = UIImpactFeedbackGenerator()
    internal var courseName = ""
    internal var channelSlug = ""
    internal var imagePicker: UIKitImagePicker?
    internal var addedFiles = [UploadfileData]()
    private let imageFetcher = ImageScout()
    private var mentionItems = [MentionUserData]()
    internal var filteredMentions = [MentionUserData]()
    public var communityType: CommunityType = .courses
    public var analyticsChannelType = "course"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUI()
        setupTableView()
        setupCollectionView()
        setupMessageVM()
        setupRepliesVM()
        setupSendMessageTextView()
        addLongPressGesture()
        hapticGenerator.prepare()
        setupImagePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(MessageThreadsVC.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageThreadsVC.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.sendMessageViewBottomConstraint.constant = 0
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                self.view.layoutIfNeeded() })
            }
        }
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.tableView.scrollToBottom(animation: false)
                self.sendMessageViewBottomConstraint.constant = keyboardHeight - UIDevice.current.safeAreaBottom +  (UIDevice.current.hasNotch ? 2 : 0)
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    // MARK:UI
    func setupNavBar() {
        navBar.barTintColor = .white
        navItem.leftBarButtonItem = backButtonItem
        let navTitle = UILabel()
        navTitle.text = "Discussion"
        navTitle.font = AppFont.fontOf(type: .SemiBold, size: 16)
        navTitle.sizeToFit()
        let titleItem = UIBarButtonItem(customView: navTitle)
        navBar.barTintColor = .white
        navItem.leftBarButtonItems = [backButtonItem, titleItem]
    }
    
    private func setupUI() {
        changeSendButtonState(enable: false)
        sendMessageButton.layer.cornerRadius = 4
        isToShowImagesCollectionView(hidden: true)
    }
    
    func setupTableView() {
        let cellNib = UINib(nibName: "ChatMessagesTextCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ChatMessagesTextCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        let filterSectionHeaderNib = UINib.init(nibName: "MessagesTableHeaderView",
                                                bundle: Bundle.main)
        self.tableView.register(filterSectionHeaderNib,
                                forHeaderFooterViewReuseIdentifier: "MessagesTableHeaderView")
        self.tableView.keyboardDismissMode = .onDrag
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
    
    private func addLongPressGesture() {
        let tapGesture = UILongPressGestureRecognizer(target: self,
                                                      action: #selector(self.onTapClosure))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTapClosure(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let tapLocation = sender.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                if tapIndexPath.section == 0 {
                    let vc = ChatMessagesBottomSheet()
                    vc.messageUUID = messageData?.uuid ?? ""
                    vc.message = messageData?.message ?? ""
                    vc.entityUUID = entityUUID
                    vc.channelName = channelName
                    vc.courseName = courseName
                    vc.isFromThread = true
                    vc.delegate = self
                    vc.channelSlug = channelSlug
                    vc.channelUUID = channelUUID
                    vc.parentMessagesUUID = messageVM?.messageUUID ?? ""
                    vc.analyticsChannelType = analyticsChannelType
                    self.presentPanModal(vc)
                } else {
                    if let _ = self.tableView.cellForRow(at: tapIndexPath) as? ChatMessagesTextCell {
                        let vc = ChatMessagesBottomSheet()
                        vc.channelUUID = channelUUID
                        vc.messageUUID = repliesVM.getCellViewModel(at: tapIndexPath)?.uuid
                        vc.message = repliesVM.getCellViewModel(at: tapIndexPath)?.message ?? ""
                        vc.entityUUID = entityUUID
                        vc.channelName = channelName
                        vc.courseName = courseName
                        vc.parentMessageUUID = messageData?.uuid ?? ""
                        vc.channelSlug = channelSlug
                        vc.communityType = communityType
                        vc.isFromThread = true
                        vc.delegate = self
                        vc.analyticsChannelType = analyticsChannelType
                        self.presentPanModal(vc)
                    }
                }
            }
        }
    }
    
    // MARK:Data
    private func setupRepliesVM() {
        repliesVM.getData(messageUUID: messageVM?.messageUUID ?? "",
                          entityUUID: self.entityUUID,
                          channelUUID: self.channelUUID)
        repliesVM.reloadTableView = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        repliesVM.firstreloadTableView = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.setNeedsLayout()
            self.tableView.layoutIfNeeded()
            self.tableView.reloadData()
        }
        
        repliesVM.performBatchUpdate = { [weak self] in
            guard let self = self else { return }
            self.tableView.performBatchUpdates({
                let indexPath = IndexPath.init(row:
                                                self.repliesVM.numberOfRows - 1,
                                               section: 1)
                self.tableView.insertRows(at: [indexPath], with: .bottom)
            }, completion: nil)
        }
        
        repliesVM.scrollToBottom = { [weak self] in
            guard let self = self else { return }
            self.tableView.scrollToBottom()
        }
        
        repliesVM.showError = { (error) in
            ToastBasic.make(text: error).show()
        }
        
        repliesVM.hideLoading = { [weak self] in
            guard let self = self else { return }
            self.imageActivityIndicator.stopAnimating()
        }
    }
    
    private func setupMessageVM() {
        guard let data = messageData else { return}
        messageVM = MessageVM(data: data, channelUUID: self.channelUUID)
        messageVM?.reloadTableView = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    // MARK:Actions
    @objc private func backButtonAction() {
        repliesVM.removeObserver()
        messageVM?.removeObserver()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func sendReplyAction(_ sender: Any) {
        hapticGenerator.impactOccurred(intensity: 6)
        let messageAttributedString = NSMutableAttributedString(attributedString: self.sendMessageTextView.textView.attributedText).htmlSimpleTagString()
        let messageString = messageAttributedString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let mentions = getMentionArray()
        if !messageString.isEmpty && addedFiles.count == 0 {
            repliesVM.sendReply(message: getMentionMessage(),
                                channel_uuid: channelUUID,
                                root_message_uuid: messageVM?.messageUUID ?? "", mentions: mentions)
        }
        
        if addedFiles.count > 0 {
            imageActivityIndicator.startAnimating()
            repliesVM.uploadImages(channelSlug: channelSlug, courseUUID: entityUUID, courseName: courseName, images: addedFiles, message: messageString, channel_uuid: channelUUID, root_message_uuid: messageVM?.messageUUID ?? "", mentions: getMentionArray(), channelType: analyticsChannelType)
            addedFiles.removeAll()
            isToShowImagesCollectionView(hidden: true)
        }
        
        hideKeyboard()
        self.sendMessageTextView.resetAllValues()
        self.sendMessageTextView.textView.endEditing(true)
        self.mentionsTableView.isHidden = true
        self.filteredMentions.removeAll()
        changeSendButtonState(enable: true)
    }
    
    @IBAction func imageButtonClicked(_ sender: Any) {
        let vc = ImageSourceBottomSheet()
        vc.delegate = self
        self.presentPanModal(vc)
    }
    
    // MARK:hideKeyboard
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    func getHeaderView(font : UIFont, color : UIColor, text : String) -> UIView {
        let headerView = UIView.init(frame: CGRect.init(x: 15,
                                                        y: 2,
                                                        width: tableView.frame.width,
                                                        height: 20))
        headerView.backgroundColor = UIColor.clear
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 2, width: headerView.frame.width,
                                  height: headerView.frame.height)
        label.text = text
        label.font = font
        label.textColor = color
        headerView.addSubview(label)
        return headerView
    }
    
    func setupSendMessageTextView() {
        self.sendMessageTextView.textView.font = AppFont.fontOf(type: .Medium, size: 14)
        self.sendMessageTextView.textView.textColor = AppColors.slate02
        self.sendMessageTextView.layer.cornerRadius = 4
        self.sendMessageTextView.placeholderAttributedText = NSAttributedString(
            string: "Add a reply",
            attributes: [
                .font: AppFont.fontOf(type: .Medium, size: 14),
                .foregroundColor: AppColors.slate03
            ]
        )
        self.sendMessageTextView.textView.inputAccessoryView =  UIView()
        self.sendMessageTextView.textView.allowsEditingTextAttributes = true
        self.sendMessageTextView.mentionDelegate = self
        self.sendMessageTextView.maxNumberOfLines = 6
    }
    
    private func isToShowImagesCollectionView(hidden: Bool) {
        self.imagesCollectionView.isHidden = hidden
        self.imagesCollectionViewHeight.constant = hidden ? 0 : 60
        self.imagesCollectionViewBtmConstraint.constant = hidden ? 0 : 8
        self.imagesCollectionViewTpConstraint.constant = hidden ? 8 : 20
    }
    
    private func setupImagePicker() {
        imagePicker = UIKitImagePicker(presentationController: self, delegate: self)
    }
    
    private func changeSendButtonState(enable: Bool) {
        sendMessageButton.backgroundColor = enable ? AppColors.dashBlueDefault : UIColor.init(0xA8A8A8)
        sendMessageButton.isEnabled = enable
    }
}

extension MessageThreadsVC : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let text = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let trimmedString = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimmedString.count > 0 {
            changeSendButtonState(enable: true)
        } else if addedFiles.count > 0 {
            changeSendButtonState(enable: true)
        } else {
            changeSendButtonState(enable: false)
        }
        return true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}

extension MessageThreadsVC: ChatMessageTextCellProtocol {
    func openEmojiVoteModal(data: [Reaction]) {
        let vc = EmojiVoteController()
        vc.emojiData = data
        self.presentPanModal(vc)
    }
    
    func openImagePopUp(data: [Asset], index: Int, messageUUID: String) {
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
        vc.entityUUID = entityUUID
        vc.channelName = channelName
        vc.courseName = courseName
        vc.channelSlug = channelSlug
        vc.channelUUID = channelUUID
        vc.parentMessageUUID = messageVM?.messageUUID ?? ""
        vc.analyticsChannelType = analyticsChannelType
        self.presentPanModal(vc)
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
        MentionApi.getMentionUsers(channelUUID: channelUUID, searchQuery: searchQuery) { response in
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
}

extension MessageThreadsVC: MessageBottomSheetProtocol {
    func sendInfo(indexPath: IndexPath) {
    }
    
    func dismissSheet() {
        ToastBasic.make(text: "Text copied to clipboard").show(at: .top)
    }
    
    func sendDeleteMessageInfo(indexPath: IndexPath) {
        let vc = DeleteMessageBottomSheet()
        vc.indexPath = indexPath
        vc.messageData = repliesVM.getCellViewModel(at: indexPath)
        self.presentPanModal(vc)
    }
}

extension MessageThreadsVC: sendImagesCellProtocol {
    func sendInfo(index: Int) {
        self.removeFile(index: index)
    }
}

extension MessageThreadsVC: ImagePickerDelegate {
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

extension MessageThreadsVC: ImageSourceBottomSheetProtocol {
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

extension MessageThreadsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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


extension MessageThreadsVC: UIDocumentPickerDelegate {
    
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


extension MessageThreadsVC: sendFilesCellProtocol {
    func sendFileInfo(index: Int) {
        self.removeFile(index: index)
    }
}


extension MessageThreadsVC: EasyMentionDelegate {
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
