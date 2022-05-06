//
//  ChatMessagesRepliesCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 23/06/21.
//

import UIKit

class ChatMessagesRepliesCell: UICollectionViewCell {
    @IBOutlet private weak var profilePic: UIImageView!
    @IBOutlet private weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.setCornerRadiusAndBorderToView(cornerRadius:8)
    }
}
