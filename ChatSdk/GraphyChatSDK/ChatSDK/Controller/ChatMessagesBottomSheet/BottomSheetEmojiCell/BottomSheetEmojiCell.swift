//
//  BottomSheetEmojiCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/06/21.
//

import UIKit

class BottomSheetEmojiCell: UICollectionViewCell {

    var emojiData = [EmojiData]()
    // MARK:Outlets
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var emojiImage: UIImageView!
    // MARK:Properties
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK:UI
    private func setupUI() {
        cellView.setCornerRadiusAndBorderToView(cornerRadius: 20)
        cellView.backgroundColor = AppColors.slate05
    }
    
    internal func configure(with data: EmojiData) {
        emojiImage.image = data.image
    }
    
}
