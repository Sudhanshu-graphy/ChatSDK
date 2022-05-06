//
//  ChannelListController.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 21/06/21.
//

import UIKit
import SwiftUI

struct CourseData {
    var slug: String?
    var emoji: String?
    var name: String?
}

public class ChannelListVC: DeInitLoggerViewController {

    // MARK:Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var navItem: UINavigationItem!
    
    // MARK:Properties
    private var dismissButtonItem: UIBarButtonItem {
        let dismissButton = UIBarButtonItem(image: AppAssets.crossIcon, style: .plain, target: self, action: #selector(self.dismissButtonAction))
        dismissButton.tintColor = UIColor.black
        return dismissButton
    }
    
    internal var dataViewModel = ChannelsListVM()
    internal var hapticGenerator = UIImpactFeedbackGenerator()
    internal var isFromNotif = false
    public var courseData: FeedResult?
    public var isFromCourseRoot = false
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        getChannelData()
        hapticGenerator.prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        dataViewModel.openedChannelSlug = ""
        if let deeplinkDic = LocalData.deeplinkData,
           let deeplinkType = deeplinkDic["deeplinkType"] as? String,
           let channelSlug = deeplinkDic["channelSlug"] as? String {
            if deeplinkType == "channelMessage" {
                navigateToMessagesScreen(channelSlug: channelSlug)
            }
        }
    }
   
    // MARK:UI
    private func setupNavBar() {
        navigationBar.barTintColor = .white
        let navTitle = UILabel()
        navTitle.text = "Chat"
        navTitle.font = AppFont.fontOf(type: .ExtraBold, size: 16)
        navTitle.sizeToFit()
        let titleItem = UIBarButtonItem(customView: navTitle)
        navItem.leftBarButtonItems = [dismissButtonItem, titleItem]
    }
    
    private func setupTableView() {
        let cellNib = UINib(nibName: "ChannelListCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ChannelListCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK:Actions
    @objc private func dismissButtonAction() {
        if isFromNotif {
            self.dismiss(animated: true) {
//                GraphyNavigator.setUpRoot()
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func getChannelData() {
        
        dataViewModel.establishSocketConnection(entitySlug: courseData?.slug ?? "", entityExternalUUID: courseData?.uuid ?? "")

        if (courseData?.slug) != nil {
            dataViewModel.getData(entityUUID: courseData?.uuid ?? "")
        }
        dataViewModel.reloadTableView = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
        dataViewModel.showError = { (error) in
           ToastBasic.make(text: error).show()
        }
    }
    
    private func navigateToMessagesScreen(channelSlug: String) {
        let vc = ChannelMessagesVC()
        dataViewModel.openedChannelSlug = channelSlug
        vc.channelSlug = channelSlug
        dataViewModel.updateChannelUnreadCount(channelSlug: channelSlug)
        vc.courseSlug = courseData?.slug ?? ""
        vc.channelName = channelSlug
        vc.courseName = courseData?.title ?? ""
        vc.emojiText = (courseData?.emojiUnicode ?? AppEmoji.defaultEmojiUnicode).unicodeToEmoji()
        vc.isFromNotif = isFromNotif
        vc.entityUUID = courseData?.uuid ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
