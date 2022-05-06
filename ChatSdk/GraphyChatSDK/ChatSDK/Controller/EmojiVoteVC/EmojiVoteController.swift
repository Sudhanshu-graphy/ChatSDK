//
//  EmojiVoteModal.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 12/07/21.
//

import Foundation
import ViewPager_Swift
import PanModal
import emojidataios

class EmojiVoteController: DeInitLoggerViewController {
    var tabs = [ViewPagerTab]()
    let options = ViewPagerOptions()
    var pager:ViewPager?
    internal var emojiData: [Reaction]!
    internal var emojiVM: MessageEmojiVM!
    override func loadView() {
        let newView = UIView()
        newView.backgroundColor = UIColor.white
        view = newView
        emojiVM = MessageEmojiVM(data: emojiData)
        tabs.append(ViewPagerTab(title: "All", image: nil))
        setupPagerTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPager()
    }
    
    private func setupPager() {
        options.tabType = .basic
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.distribution = .equal
        options.tabViewBackgroundDefaultColor = .white
        options.tabViewBackgroundHighlightColor = .white
        options.isTabBarShadowAvailable = false
        options.shadowColor = .clear
        options.tabViewTextDefaultColor = .black
        options.tabViewTextHighlightColor = .black
        options.tabIndicatorViewBackgroundColor = AppColors.slate02 
        pager = ViewPager(viewController: self)
        pager?.setOptions(options: options)
        pager?.setDataSource(dataSource: self)
        pager?.setDelegate(delegate: self)
        pager?.build()
    }
    
    private func setupPagerTitle() {
        for value in emojiVM.getEmojiData() {
            let emojiName = EmojiParser.parseAliases(value.first?.emojiName ?? "") + "  \(value.count)"
            tabs.append(ViewPagerTab(title: "\(emojiName)", image:nil))
        }
    }
}

extension EmojiVoteController: ViewPagerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        let vc = EmojiVoteListVC()
        if position == 0 {
            vc.showAllEmojiList = true
            vc.emojiVM = emojiVM
        } else {
            let indexPath = IndexPath(item: position - 1, section: 0)
            vc.memberData = emojiVM.getCellViewModel(at: indexPath)
        }
        return vc
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

extension EmojiVoteController: ViewPagerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
    }
    
    func didMoveToControllerAtIndex(index: Int) {
    }
}


extension EmojiVoteController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(290)
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
        return false
    }
    
    var showDragIndicator: Bool {
        return false
    }
    
    var allowsDragToDismiss: Bool {
        return true
    }
}
