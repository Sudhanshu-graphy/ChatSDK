//
//  MessagesTableHeaderView.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/06/21.
//

import Foundation
import UIKit

final class MessagesTableHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet internal weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    // MARK: SetupUI
    private func setUpUI() {
        self.dateLabel.font = AppFont.fontOf(type: .Medium, size: 10)
        self.dateLabel.textColor = AppColors.slate03
    }
}
