//
//  Label.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 12/07/21.
//

import Foundation
import UIKit

extension UILabel {
    
    func addTrailing(image: UIImage, text:String) {
        let attachment = NSTextAttachment()
        attachment.image = image
        
        let attachmentString = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: text, attributes: [:])

        string.append(attachmentString)
        self.attributedText = string
    }
    
    func addLeading(image: UIImage, text:String) {
        let attachment = NSTextAttachment()
        attachment.image = image

        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)
        
        let string = NSMutableAttributedString(string: text, attributes: [:])
        mutableAttributedString.append(string)
        self.attributedText = mutableAttributedString
    }
    
    func addInterlineSpacing(spacingValue: CGFloat = 1.6, centerAlign: Bool = false) {
        
        guard let textString = text else { return }
        let attributedString = NSMutableAttributedString(string: textString)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = spacingValue
        if centerAlign {
            paragraphStyle.alignment = .center
        }
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
            ))
        
        attributedText = attributedString
    }
}
