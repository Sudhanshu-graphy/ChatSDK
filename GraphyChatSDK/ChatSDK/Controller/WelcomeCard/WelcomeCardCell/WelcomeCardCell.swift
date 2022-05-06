//
//  WelcomeCardCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 21/09/21.
//

import UIKit

final class WelcomeCardCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var cardIcon: UIImageView!
    @IBOutlet private weak var cardTitleLabel: UILabel!
    @IBOutlet private weak var cellView: UIView!
    
    // MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        cardTitleLabel.textColor = AppColors.slate01
        cardTitleLabel.font = AppFont.fontOf(type: .Regular, size: 14)
    }
    
    // MARK: - Data
    
    public func configData(with data: WelcomeCardType, channelType: ChannelType, backgroundColor: UIColor = .white) {
        cellView.backgroundColor = backgroundColor
        self.contentView.backgroundColor = backgroundColor
        self.cardIcon.image = data.icon
        self.cardTitleLabel.text = data.title(type: channelType)
    }
}
