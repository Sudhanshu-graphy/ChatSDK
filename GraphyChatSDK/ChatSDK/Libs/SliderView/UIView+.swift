//
//  UIView+.swift
//  AstroYeti
//
//  Created by Sudhanshu Dwivedi on 12/12/20.
//  Copyright © 2020 Puneet Gupta. All rights reserved.
//

import UIKit

extension UIView {
    
     func blink() {
         self.alpha = 0.2
        UIView.animate(withDuration: 1.5, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse, .allowUserInteraction], animations: {self.alpha = 0.8}, completion: nil)
     }
    
    func bounce() {
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: { _ in
            
        })
    }
    
}
