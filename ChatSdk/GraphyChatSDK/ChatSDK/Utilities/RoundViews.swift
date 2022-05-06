//
//  RoundViews.swift
//  Graphy
//
//  Created by Raj Dhakate on 12/10/21.
//

import Foundation
import UIKit

class RoundImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
}

class RoundView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
}

class PillLabel: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8
    }
}
