//
//  UIImage+Helpers.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 23/08/21.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageColor(color: UIColor?) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
