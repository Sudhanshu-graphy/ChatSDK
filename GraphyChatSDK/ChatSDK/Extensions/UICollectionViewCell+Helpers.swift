//
//  UICollectionViewCell+Helpers.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/08/21.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    func toggleIsHighlighted() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.alpha = self.isHighlighted ? 0.95 : 1.0
            self.transform = self.isHighlighted ?
                CGAffineTransform.identity.scaledBy(x: 0.98, y: 0.98) :
                CGAffineTransform.identity
        })
    }
}
