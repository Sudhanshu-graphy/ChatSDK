//
//  ChatMessagesBottomSheet.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/06/21.
//

import UIKit
import PanModal

protocol MessageBottomSheetProtocol: AnyObject {
    func sendInfo(indexPath: IndexPath)
    func dismissSheet()
    func sendDeleteMessageInfo(indexPath: IndexPath)
}

class ChatMessagesBottomSheet: DeInitLoggerViewController {
    
    // MARK:Outlets
    @IBOutlet private weak var emojiCollectionView: UICollectionView!
    @IBOutlet private weak var actionTableView: UITableView!
    
    // MARK:Properties
    internal let emojiVM = EmojiModalVM()
    internal var actionsVM = ActionModalVM()
    internal var messageUUID: String?
    public var channelName : String = ""
    weak var delegate: MessageBottomSheetProtocol?
    internal var indexPath: IndexPath!
    internal var message = ""
    internal var isFromThread = false
    internal var entityUUID: String = ""
    internal var courseName = ""
    internal var parentMessageUUID = ""
    internal var channelSlug = ""
    internal var channelUUID = ""
    internal var parentMessagesUUID = ""
    public var communityType: CommunityType = .courses
    public var analyticsChannelType = "course"
    
    // MARK:View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        actionsVM.setupData(isFromThread: isFromThread, communityType: communityType)
        setupTableView()
        setupCollectionView()
    }

    // MARK:UI
    private func setupTableView() {
        let cellNib = UINib(nibName: "BottomSheetActionsCell", bundle: nil)
        actionTableView.register(cellNib, forCellReuseIdentifier: "BottomSheetActionsCell")
        actionTableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func setupCollectionView() {
        emojiCollectionView.register(UINib(nibName: "BottomSheetEmojiCell", bundle: nil), forCellWithReuseIdentifier: "BottomSheetEmojiCell")
    }
}


extension ChatMessagesBottomSheet: PanModalPresentable {
    
    var panScrollable:
        UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(actionsVM.panmodalHeight)
    }
    
    var springDamping: CGFloat {
        return 1.0
    }
    
    var transitionDuration: Double {
        return 0.5
    }
    
    var transitionAnimationOptions: UIView.AnimationOptions {
        return [.allowUserInteraction, .allowUserInteraction]
    }
    
    var shouldRoundTopCorners: Bool {
        return true
    }
    
    var showDragIndicator: Bool {
        return false
    }
    
    var allowsDragToDismiss: Bool {
        return true
    }
}
