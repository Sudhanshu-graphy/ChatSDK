//
//  LinkResponsiveTextView.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 08/07/21.
//
import UIKit

class LinkTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        isScrollEnabled = false
        isEditable = false
        isUserInteractionEnabled = true
        isSelectable = true
        dataDetectorTypes = .link
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            // location of the tap
            var location = point
            location.x -= self.textContainerInset.left
            location.y -= self.textContainerInset.top
            
            // find the character that's been tapped
            let characterIndex = self.layoutManager.characterIndex(for: location, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            if characterIndex < self.textStorage.length - 1 {
                // if the character is a link, handle the tap as UITextView normally would
                if self.textStorage.attribute(NSAttributedString.Key.link, at: characterIndex, effectiveRange: nil) != nil {
                    return self
                }
            }
            
            // otherwise return nil so the tap goes on to the next receiver
            return nil
        }
    
    // Instead of overriding hitTest(_:with:), you can override point(inside:with:)
    
    /*
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // Get the character index from the tap location
        let characterIndex = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if we detect a link, handle the tap by returning true...
        if let _ = textStorage.attribute(NSLinkAttributeName, at: characterIndex, effectiveRange: nil) {
            return true
        }
        
        // ... otherwise return false ; the tap will go on to the next receiver
        return false
    }
    */
    
}
