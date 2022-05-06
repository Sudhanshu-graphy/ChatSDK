//
//  PrefilledMessageBottomSheetCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/09/21.
//

import UIKit

final class PrefilledMessageBottomSheetCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        titleLabel.addInterlineSpacing()
        titleLabel.textColor = .black
        titleLabel.font = AppFont.fontOf(type: .Regular, size: 14)
    }
    
    // MARK: - Data
    public func config(with title: String) {
        titleLabel.text = title
    }
}
