//
//  ProfileBottomSheetVC.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 29/06/21.
//

import UIKit
import PanModal

class ProfileBottomSheetVC: DeInitLoggerViewController {
    
    // MARK:Outlets
    @IBOutlet private weak var profilePic: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var joinDateLabel: UILabel!
    internal var name: String?
    internal var profilePicUrl: String?
    
    // MARK:ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    private func setupUI() {
        profilePic.layer.cornerRadius = 4
        profilePic.layer.borderWidth = 0.2
        profilePic.layer.borderColor = UIColor.init(0xD7D7D7).cgColor
        profilePic.clipsToBounds = true
        nameLabel.font = AppFont.fontOf(type: .Bold, size: 20)
        nameLabel.textColor = AppColors.slate01
    }
    
    private func setupData() {
        nameLabel.text = name
        profilePic.sd_setImage(with: URL(string: profilePicUrl ?? ""),
                               placeholderImage: AppAssets.avatarPlaceholder)
    }
}


extension ProfileBottomSheetVC: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(410)
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
