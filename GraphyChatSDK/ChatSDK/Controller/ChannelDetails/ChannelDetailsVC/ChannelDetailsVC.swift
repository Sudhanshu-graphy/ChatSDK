//
//  ChannelDetailsVC.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/06/21.
//

import UIKit
import SafariServices

class ChannelDetailsVC: DeInitLoggerViewController {
    
    // MARK:Outlets
    @IBOutlet private weak var navItem: UINavigationItem!
    @IBOutlet private weak var navBar: UINavigationBar!
    @IBOutlet private weak var channelPic: UIImageView!
    @IBOutlet private weak var channelNameLabel: UILabel!
    @IBOutlet private weak var descriptionPlaceholderLabel: UILabel!
    @IBOutlet private weak var descriptionContentLabel: UILabel!
    @IBOutlet private weak var createdDateLabel: UILabel!
    @IBOutlet private weak var notificationSwitchButton: UIButton!
    @IBOutlet private weak var notificationPlaceholderLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyView: UIView!
    @IBOutlet internal weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var emptyImageView: UIImageView!
    @IBOutlet private weak var emptyViewHeading: UILabel!
    @IBOutlet private weak var emptyViewSubHeading: UILabel!
    @IBOutlet private weak var emojiView: UIView!
    @IBOutlet private weak var emojiLabel: UILabel!
    
    // MARK:Properties
    private var dismissButtonItem: UIBarButtonItem {
        let dismissButton = UIBarButtonItem(image: AppAssets.crossIcon, style: .plain, target: self, action: #selector(self.dismissButtonAction))
        dismissButton.tintColor = UIColor.black
        return dismissButton
    }
    
    internal var channelSlug: String = ""
    internal var channelDetailVM = ChannelDetailVM()
    internal var channelMemberVM = ChannelMemberVM()
    internal var channelRecentFilesVM = ChannelRecentFilesVM()
    internal var entitySlug: String = ""
    internal var entityUUID: String = ""
    var headings: [String] = ["Loading...", "Nothing here yet"]
    var subheading: [String] = ["All members from the channel will show up here",
                                "Files shared in the channel will show up here "]
    internal var emptyImages: [UIImage] = [AppAssets.emptyMembersIcon, AppAssets.emptyFilesIcon]
    internal var emojiText = ""
    internal var channelUUID = ""
    internal var courseName = ""
    internal var channelName = ""
    internal var offset = 0
    internal var totalMemberCount = 0
    public var analyticChannelType = "course"
    
    // MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupNavBar()
        getChannelDetails()
        setupChannelMemberVM(offset: offset)
        setupchannelRecentFilesVM()
    }

    // MARK: UI
    private func setupUI() {
        channelPic.layer.cornerRadius = 4
        channelPic.clipsToBounds = true
        channelNameLabel.font = AppFont.fontOf(type: .Bold, size: 14)
        channelNameLabel.textColor = AppColors.slate01
        descriptionPlaceholderLabel.font = AppFont.fontOf(type: .SemiBold, size: 12)
        descriptionPlaceholderLabel.textColor = AppColors.slate02
        descriptionContentLabel.font = AppFont.fontOf(type: .Regular, size: 12)
        descriptionContentLabel.textColor = AppColors.slate02
        createdDateLabel.font = AppFont.fontOf(type: .Medium, size: 10)
        createdDateLabel.textColor = AppColors.slate03
        notificationPlaceholderLabel.font = AppFont.fontOf(type: .Medium, size: 14)
        notificationPlaceholderLabel.textColor = AppColors.slate01
        self.segmentControl.selectedSegmentIndex = 0
        emptyViewHeading.font  = AppFont.fontOf(type: .Bold, size: 14)
        emptyViewHeading.textColor = AppColors.slate01
        emptyViewSubHeading.font = AppFont.fontOf(type: .Medium, size: 14)
        emptyViewSubHeading.textColor = AppColors.slate03
        emojiView.layer.cornerRadius = 4
        emojiView.backgroundColor = AppColors.slate05
        emojiView.clipsToBounds = true
        emojiLabel.text = emojiText
    }
    
    private func setupTableView() {
        let cellNib = UINib(nibName: "ChannelDetailFilesCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ChannelDetailFilesCell")
        tableView.register(UINib(nibName: "ChannelDetailMemberCell",
                                 bundle: nil), forCellReuseIdentifier: "ChannelDetailMemberCell")
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func setupNavBar() {
        let navTitle = UILabel()
        navTitle.text = "Channel details"
        navTitle.font = AppFont.fontOf(type: .SemiBold, size: 16)
        navTitle.sizeToFit()
        let titleItem = UIBarButtonItem(customView: navTitle)
        navBar.barTintColor = .white
        navItem.leftBarButtonItems = [dismissButtonItem, titleItem]
    }
    
    
    @objc private func dismissButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func getChannelDetails() {
        channelDetailVM.getData(channelSlug: channelSlug, entityUUID: entityUUID)
        channelDetailVM.configureData = { [weak self] in
            guard let self = self else { return }
            self.setupChannelDetails()
        }
        
        channelDetailVM.showError = { (error) in
           ToastBasic.make(text: error).show()
        }
    }
    
    private func setupChannelDetails() {
        channelNameLabel.text = channelDetailVM.channelName
        descriptionContentLabel.text = channelDetailVM.channeldescription
        createdDateLabel.text = channelDetailVM.channelCreatedAt
    }
    
    private func setupChannelMemberVM(offset: Int = 0) {
        channelMemberVM.getData(offset: offset,
                                entityExternalUUID: entityUUID)
        channelMemberVM.reloadTableView = { [weak self] in
            guard let self = self else { return }
            self.totalMemberCount  = self.channelMemberVM.totalMemberCount
            if self.totalMemberCount > 0 {
                self.segmentControl.setTitle("Members (\(self.totalMemberCount))", forSegmentAt: 0)
            }
            self.tableView.reloadData()
        }
        
        channelMemberVM.showError = { (error) in
           ToastBasic.make(text: error).show()
        }
    }
    
    private func setupchannelRecentFilesVM() {
        channelRecentFilesVM.getData(channelUUID: channelUUID)
    }
    
    internal func showEmptyState() {
        if segmentControl.selectedSegmentIndex == 0 {
            emptyView.isHidden = false
            tableView.isHidden = true
            emptyImageView.image = emptyImages[0]
            emptyViewHeading.text = headings[0]
            emptyViewSubHeading.text = subheading[0]
        } else {
            emptyView.isHidden = false
            tableView.isHidden = true
            emptyImageView.image = emptyImages[1]
            emptyViewHeading.text = headings[1]
            emptyViewSubHeading.text = subheading[1]
        }
    }
    
    internal func hideEmptyState() {
        self.tableView.isHidden = false
        self.emptyView.isHidden = true
    }
    
    internal func openLink(url: String) {
        if let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            guard let url = URL(string: urlString) else { return }
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.modalPresentationStyle = .formSheet
            present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK:Actions
    
    @IBAction func notificationSwitchButtonClick(_ sender: Any) {
        self.notificationSwitchButton.isSelected.toggle()
    }
    
    @IBAction func segmentControlClicked(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            channelMemberVM.removeMembersData()
            setupChannelMemberVM(offset: offset)
        } else {
            offset = 0
            totalMemberCount = 0
            self.tableView.reloadData()
        }
    }
}
