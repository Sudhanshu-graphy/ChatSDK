//
//  EasyMention.swift
//  EasyMention
//
//  Created by Sudhanshu Dwivedi on 04/08/21.
//

import UIKit
import NextGrowingTextView

public protocol EasyMentionDelegate: AnyObject {
    func mentionSelected(in textView: EasyMention, mention: MentionUserData)
    func startMentioning(in textView: EasyMention, mentionQuery: String, showFullList: Bool)
    func textViewDidChange()
    func showTableView(mentionData: [MentionUserData])
    func hideTableView()
}


public class EasyMention : NextGrowingTextView {
    
    ////////////////////////////////////////////////////////////////////////
    // Public interface
    
    /// Force the results list to adapt to RTL languages
    open var forceRightToLeft = false
    
    // Move the table around to customize for your layout
    open var tableCornerRadius: CGFloat = 4.0
    weak var mentionDelegate: EasyMentionDelegate?
    
    open var textViewBorderColor: UIColor = .clear {
        didSet {
            if #available(iOS 14.0, *) {
                self.layer.borderColor = AppColors.slate04.cgColor
            } else {
                self.layer.borderColor = UIColor.gray.cgColor
            }
        }
    }
    
    open var textViewBorderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = textViewBorderWidth
            
        }
    }
    
    ////////////////////////////////////////////////////////////////////////
    // Private implementation
    open var currentMentions = [Int :MentionUserData ]()
    fileprivate var mentionsIndexes = [Int:Int]()
    fileprivate var keyboardHieght:CGFloat?
    internal var isMentioning = Bool()
    internal var mentionQuery = String()
    fileprivate var startMentionIndex = Int()
    fileprivate var tableView = UITableView()
    fileprivate var timer: Timer?
    fileprivate static let cellIdentifier = "MentionsCell"
    fileprivate var maxTableViewSize: CGFloat = 0
    fileprivate var socketMessage = ""
    fileprivate var mentions = [MentionUserData]()
    fileprivate var filteredMentions = [MentionUserData]()

    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.textView.delegate = self
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = self.textViewBorderWidth
        self.layer.borderColor = self.textViewBorderColor.cgColor
    }

    public func setMentions(mentions: [MentionUserData]) {
        self.mentions = mentions
        self.filteredMentions = mentions
        mentionDelegate?.showTableView(mentionData: mentions)
    }
    
    /// get current metions in textView
    ///
    /// - Returns: list of mentions
    public func getCurrentMentions() -> [MentionUserData] {
        var mItems = [MentionUserData]()
        for (_, mentions) in self.currentMentions {
            mItems.append(mentions)
        }
        return mItems
    }

    fileprivate func updatePosition() {
        self.tableView.frame.size.height = UIScreen.main.bounds.height - (self.keyboardHieght ?? 0) - self.frame.height
    }
    
    internal func setDidSelectData(data: MentionUserData) {
        currentMentions[self.startMentionIndex] = data
        if mentionDelegate != nil {
            self.mentionDelegate?.mentionSelected(in: self, mention: data)
        }
    }
    
    internal func resetAllValues() {
        currentMentions.removeAll()
        mentionsIndexes.removeAll()
        isMentioning = false
        mentionQuery = ""
        startMentionIndex = 0
        mentions.removeAll()
        filteredMentions.removeAll()
        textView.text = ""
        textView.textColor = AppColors.slate02
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font : AppFont.fontOf(type: .Medium, size: 14), NSAttributedString.Key.foregroundColor : AppColors.slate02])
        textView.attributedText = attributedString
    }
}


// MARK:- TextView Delegate

extension EasyMention: UITextViewDelegate {
    
    
    public func textViewDidChange(_ textView: UITextView) {
        mentionDelegate?.textViewDidChange()
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if isMentioning {
            self.mentionDelegate?.startMentioning(in: self, mentionQuery: self.mentionQuery, showFullList: false)
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentString: NSString = textView.text as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
        
        if newString == "" {
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font : AppFont.fontOf(type: .Medium, size: 14), NSAttributedString.Key.foregroundColor : AppColors.slate02])
            self.textView.attributedText = attributedString
            self.mentionsIndexes.removeAll()
            self.isMentioning = false
            self.mentionQuery = ""
            mentionDelegate?.hideTableView()
            return true
        }
                
        // when want to delete mention
        if mentionsIndexes.count != 0 {
            guard let char = text.cString(using: .utf8) else { return false}
            let isBackSpace = strcmp(char, "\\b")
            
            if isBackSpace == -92 {
                for (index, length) in mentionsIndexes {
                    if case index ... index+length = range.location {
                        // If start typing within a mention range delete that name:
                        if let range = textView.textRangeFromNSRange(range: NSRange(location: index, length: length + 1)) {
                            textView.replace(range, withText: "")
                        }
                        textView.textColor = AppColors.slate02
                        mentionsIndexes.removeValue(forKey: index)
                        self.currentMentions.removeValue(forKey: index)
                    }
                }
            }
        }
        
        if isMentioning {
            if text == " " || (text.count == 0 &&  self.mentionQuery == "") { // If Space or delete the "@"
                self.mentionQuery = ""
                self.isMentioning = false
                self.filteredMentions = mentions
                mentionDelegate?.hideTableView()
            } else if text.count == 0 {
                self.mentionQuery.remove(at: self.mentionQuery.index(before: self.mentionQuery.endIndex))
                timer?.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(EasyMention.textViewDidEndEditing(_:)), userInfo: self, repeats: false)
            } else {
                self.mentionQuery += text.lowercased()
                timer?.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(EasyMention.textViewDidEndEditing(_:)), userInfo: self, repeats: false)
            }
        } else {
            if text == "@" { /* (Beginning of textView) OR (space then @) */
                self.isMentioning = true
                self.startMentionIndex = range.location
                mentionDelegate?.showTableView(mentionData: self.filteredMentions)
                self.mentionDelegate?.startMentioning(in: self, mentionQuery: self.mentionQuery, showFullList: true)
            }
        }
        
        return true
    }
    
    // Add a mention name to the UITextView
    func addMentionToTextView(name: String) {
        mentionsIndexes[self.startMentionIndex] = name.count
        var reversedText =  String(textView.text.reversed())
        let reverseMentionQuery = String(mentionQuery.reversed())
        let reversename = String(name.reversed())
        guard let range: Range<String.Index> = reversedText.range(of: "\(reverseMentionQuery)@") else {return}
        reversedText.replaceSubrange(range, with: reversename)
        self.textView.text = String(reversedText.reversed())
        let theText = self.textView.text + " "
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: theText, attributes: [NSAttributedString.Key.font : AppFont.fontOf(type: .Medium, size: 14), NSAttributedString.Key.foregroundColor : AppColors.slate02])
        
        for (startIndex, length) in mentionsIndexes {
            // Add attributes for the mention
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.dashBlueDefault, range: NSRange(location: startIndex, length: length))
                attributedString.addAttribute(NSAttributedString.Key.font, value: AppFont.fontOf(type: .Medium, size: 14), range: NSRange(location: startIndex, length: length))
        }
        self.textView.attributedText = attributedString
    }
}

extension UITextView {
    func textRangeFromNSRange(range:NSRange) -> UITextRange? {
        let beginning = self.beginningOfDocument
        guard let start = self.position(from: beginning, offset: range.location), let end = self.position(from: start, offset: range.length) else {
            return self.textRange(from: beginning, to: beginning)
        }
        return self.textRange(from: start, to: end)
    }
}

	
