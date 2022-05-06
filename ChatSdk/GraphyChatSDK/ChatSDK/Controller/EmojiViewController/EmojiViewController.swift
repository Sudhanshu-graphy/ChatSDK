//
//  EmojiViewController.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 28/06/21.
//

import UIKit
import PanModal

class EmojiViewController: DeInitLoggerViewController {
    @IBOutlet weak var emojiView: EmojiView!
    private let emojiVM = EmojiModalVM()
    internal var messageUUID = ""
    internal var entityUUID: String = ""
    internal var courseName = ""
    public var channelName : String = ""
    internal var channelUUID = ""
    internal var channelSlug = ""
    internal var parentMessageUUID = ""
    public var analyticsChannelType = "course"
    override func viewDidLoad() {
        super.viewDidLoad()
        emojiView.delegate = self
    }
}


// MARK:  EmojiViewDelegate
extension EmojiViewController : EmojiViewDelegate {
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
    
        emojiVM.sendEmoji(emojiName: emoji.getEmojiShortName(),
                          messageUUID: self.messageUUID,
                          unicode: emoji.getEmojiUnicode())
        self.dismiss(animated: true, completion: nil)
    }
    
    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
    
    }
}

extension EmojiViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(260)
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
