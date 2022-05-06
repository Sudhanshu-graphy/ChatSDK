//
//  NSAttributedString+Helpers.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 08/07/21.
//

import Foundation
import UIKit

extension NSAttributedString {
    func toHtml() -> String? {
        let documentAttributes = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
        do {
            let htmlData = try self.data(from: NSRange(location: 0, length: self.length), documentAttributes:documentAttributes)
            if let htmlString = String(data:htmlData, encoding:String.Encoding.utf8) {
                return htmlString
            }
        } catch {
            print("error creating HTML from Attributed String")
        }
        return nil
    }
}


extension NSMutableAttributedString {
    func htmlSimpleTagString() -> String {
        enumerateAttributes(in: fullRange(), options: []) { (attributes, range, _) in
            let occurence = self.attributedSubstring(from: range).string
            var replacement: String = occurence
            if let font = attributes[.font] as? UIFont {
                replacement = self.font(initialString: replacement, fromFont: font)
            }
            if let underline = attributes[.underlineStyle] as? Int {
                replacement = self.underline(text: replacement, fromStyle: underline)
            }
            if let striked = attributes[.strikethroughStyle] as? Int {
                replacement = self.strikethrough(text: replacement, fromStyle: striked)
            }
            self.replaceCharacters(in: range, with: replacement)
        }
        return self.string
    }
}

// MARK: In multiple loop
extension NSMutableAttributedString {
    func htmlSimpleTagString(options: [NSAttributedString.Key]) -> String {
        if options.contains(.underlineStyle) {
            enumerateAttribute(.underlineStyle, in: fullRange(), options: []) { (value, range, _) in
                let occurence = self.attributedSubstring(from: range).string
                guard let style = value as? Int else { return }
                if NSUnderlineStyle(rawValue: style) == NSUnderlineStyle.single {
                    let replacement = self.underline(text: occurence, fromStyle: style)
                    self.replaceCharacters(in: range, with: replacement)
                }
            }
        }
        if options.contains(.strikethroughStyle) {
            enumerateAttribute(.strikethroughStyle, in: fullRange(), options: []) { (value, range, _) in
                let occurence = self.attributedSubstring(from: range).string
                guard let style = value as? Int else { return }
                let replacement = self.strikethrough(text: occurence, fromStyle: style)
                self.replaceCharacters(in: range, with: replacement)
            }
        }
        if options.contains(.font) {
            enumerateAttribute(.font, in: fullRange(), options: []) { (value, range, _) in
                let occurence = self.attributedSubstring(from: range).string
                guard let font = value as? UIFont else { return }
                let replacement = self.font(initialString: occurence, fromFont: font)
                self.replaceCharacters(in: range, with: replacement)
            }
        }
        return self.string

    }
}

// MARK: Replacing
extension NSMutableAttributedString {

    func font(initialString: String, fromFont font: UIFont) -> String {
        let isBold = font.fontDescriptor.symbolicTraits.contains(.traitBold)
        let isItalic = font.fontDescriptor.symbolicTraits.contains(.traitItalic)
        var retString = initialString
        if isBold {
            retString = "<b>" + retString + "</b>"
        }
        if isItalic {
            retString = "<i>" + retString + "</i>"
        }
        return retString
    }

    func underline(text: String, fromStyle style: Int) -> String {
        return "<u>" + text + "</u>"
    }

    func strikethrough(text: String, fromStyle style: Int) -> String {
        return "<s>" + text + "</s>"
    }
}

// MARK: Utility
extension NSAttributedString {
    func fullRange() -> NSRange {
        return NSRange(location: 0, length: self.length)
    }
}
