//
//  MessageUpcomingSessionCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/09/21.
//

import UIKit

class MessageUpcomingSessionCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var joinButton: UIButton!
    // MARK: - Properties
    
    // MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        cellView.setCornerRadiusAndBorderToView(cornerRadius: 4, borderWidth: 0, borderColor: .clear, withMask: true)
        dateLabel.textColor = AppColors.slate02
        dateLabel.font = AppFont.fontOf(type: .Medium, size: 12)
        titleLabel.textColor = AppColors.slate01
        titleLabel.font = AppFont.fontOf(type: .Medium, size: 16)
        joinButton.setCornerRadiusAndBorder(cornerRadius: 4, borderWidth: 0, borderColor: .clear)
        stackView.setCustomSpacing(18, after: titleLabel)
        stackView.setCustomSpacing(8, after: dateLabel)
    }
    
    // MARK: - Data
    

    // MARK: - Action
    @IBAction private func joinButtonClicked(_ sender: Any) {
    }
}
