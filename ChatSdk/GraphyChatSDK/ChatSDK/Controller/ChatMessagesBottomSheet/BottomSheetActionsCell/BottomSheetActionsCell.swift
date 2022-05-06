//
//  BottomSheetActionsCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/06/21.
//

import UIKit

class BottomSheetActionsCell: UITableViewCell {
    
    // MARK:Outlets
    @IBOutlet private weak var actionImageView: UIImageView!
    @IBOutlet private weak var actionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    
    // MARK:UI
    private func setupUI() {
        actionLabel.font = AppFont.fontOf(type: .Medium, size: 14)
        actionLabel.textColor = AppColors.slate02
    }
    
    // MARK:Data
    func configure(with data : ChatMessageActions) {
        actionLabel.text = data.action
        actionImageView.image = data.image
    }
}
