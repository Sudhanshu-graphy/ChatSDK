//
//  EmojiAllVoteListCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 12/07/21.
//

import UIKit

class EmojiAllVoteListCell: UITableViewCell {
    
    @IBOutlet weak var userNamesLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        userNamesLabel.font = AppFont.fontOf(type: .Medium, size: 14)
        userNamesLabel.textColor = AppColors.slate02
    }
    
    internal func config(with name: String, emojiText: String ) {
        emojiLabel.text = emojiText
        userNamesLabel.text = name
    }
}
