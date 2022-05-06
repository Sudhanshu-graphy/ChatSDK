//
//  Button + Helpers.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/06/21.
//

import Foundation
import UIKit

extension UIButton {
    
    func setButtonTitles(with title: String) {
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .highlighted)
    }

    func setTitleColors(with color: UIColor) {
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color, for: .highlighted)
    }
    
    func setCornerRadiusAndBorder(cornerRadius:Int?, borderWidth:Int, borderColor:UIColor) {
        self.layer.cornerRadius = CGFloat(cornerRadius ?? 0)
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.cgColor
    }
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
    
    func setRoundedByHeight() {
        self.layer.cornerRadius = (self.frame.height / 2)
        self.layer.masksToBounds = true
    }
}
