//
//  String+Helpers.swift
//  Graphy
//
//  Created by Rahul Kumar on 18/02/21.
//

import Foundation
import UIKit
import emojidataios

extension String {
    /// Bool Variable to indicate whether the invoker string is of valid email format
    public var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
    
    /// Function to return date converted to string in provided format
    /// - Parameter format: Required format of the Date
    /// - Returns: Date object
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        guard let date = dateFormatter.date(from: self) else {
            //            print("date formats don't match")
            return nil
        }
        
        return date
    }
    
    /// Function to format date in Streaming Time and Date ('time' on 'date') format
    /// - Parameter dateString: Date in string form
    /// - Returns: Streaming date in string format
    func toStreamingTimeAndDate() -> String {
        var receivedDate: Date?
        
        // check date for both formats #legacybackendbug
        if let date = self.toDate(format: AppDateFormats.longTime_Without_MilliSeconds.rawValue) {
            receivedDate = date
        } else if let date = self.toDate(format: AppDateFormats.longTime.rawValue) {
            receivedDate = date
        }
        
        let time = receivedDate?.toStringCurrentTimezone(dateFormat: AppDateFormats.onlyTime.rawValue)
        let date = receivedDate?.toStringWithDaySuffix(withTime: false)
        
        return "\(time ?? "") on \(date ?? "")"
    }
    
    /// Function to format date in Streaming Time and Date ('time' on 'date') format
    /// - Parameter dateString: Date in string form
    /// - Returns: Streaming date in string format
    func toUpcomingLiveSessionTime(year: Bool = true) -> String {
        var receivedDate: Date?
        
        // check date for both formats #legacybackendbug
        if let date = self.toDate(format: AppDateFormats.longTime_Without_MilliSeconds.rawValue) {
            receivedDate = date
        } else if let date = self.toDate(format: AppDateFormats.longTime.rawValue) {
            receivedDate = date
        }
        
        let time = receivedDate?.toStringCurrentTimezone(dateFormat: AppDateFormats.onlyTime.rawValue)
        let date = receivedDate?.toStringWithDaySuffix(withTime: false, withYear: year)
        
        return "\(date ?? "") · \(time ?? "")"
    }
    
    
    /// Convert UTC time to current timezone with abbreviation (eg. 6PM)
    /// - Parameter dateString: Date in string format
    /// - Returns: Current time with abbreviation in string format
    func toCurrentTime() -> String {
        var receivedDate: Date?
        
        // check date for both formats #legacybackendbug
        if let date = self.toDate(format: AppDateFormats.longTime_Without_MilliSeconds.rawValue) {
            receivedDate = date
        } else if let date = self.toDate(format: AppDateFormats.longTime.rawValue) {
            receivedDate = date
        }
        
        let time = receivedDate?.toStringCurrentTimezone(dateFormat: AppDateFormats.onlyTime.rawValue)
        return "\(time ?? "")"
    }
    
    
    func messageTime() -> String {
        var receivedDate: Date?
        receivedDate = self.toDate(format: AppDateFormats.longTime.rawValue)
        let time = receivedDate?.toStringCurrentTimezone(dateFormat: AppDateFormats.onlyTime.rawValue)
        return "\(time ?? "")"
    }
    
    func messageDate() -> Date {
        var receivedDate: Date?
        if let date = self.toDate(format: AppDateFormats.longTime_Without_MilliSeconds.rawValue) {
            receivedDate = date
        } else if let date = self.toDate(format: AppDateFormats.longTime.rawValue) {
            receivedDate = date
        }
        return receivedDate ?? Date()
    }
    
    func sectionMessagesDate() -> String {
        var receivedDate: Date?
        receivedDate = self.toDate(format: AppDateFormats.longTime.rawValue)
        if Calendar.current.isDateInToday(receivedDate ?? Date()) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(receivedDate ?? Date()) {
            return "Yesterday"
        }
        let date = receivedDate?.toStringWithDaySuffix(withTime: false)
        return "\(date ?? "")"
    }
        
    func channelCreatedDate() -> String {
        var receivedDate: Date?
        
        // check date for both formats #legacybackendbug
        if let date = self.toDate(format: AppDateFormats.longTime_Without_MilliSeconds.rawValue) {
            receivedDate = date
        } else if let date = self.toDate(format: AppDateFormats.longTime.rawValue) {
            receivedDate = date
        }
        
        let date = receivedDate?.toStringWithDaySuffix(withTime: false)
        return "Created on \(date ?? "")"
    }
    
    func toCourseStartDate() -> String {
        
        var receivedDate: Date?
        // check date for both formats #legacybackendbug
        if let date = self.toDate(format: AppDateFormats.longTime_Without_MilliSeconds.rawValue) {
            receivedDate = date
        } else if let date = self.toDate(format: AppDateFormats.longTime.rawValue) {
            receivedDate = date
        }
        
        let date = receivedDate?.toStringWithDaySuffix(withTime: false, withYear: false)
        
        return "\(date ?? "")"
    }
    
    func toCourseEndDate() -> String {
        var receivedDate: Date?
        // check date for both formats #legacybackendbug
        if let date = self.toDate(format: AppDateFormats.longTime_Without_MilliSeconds.rawValue) {
            receivedDate = date
        } else if let date = self.toDate(format: AppDateFormats.longTime.rawValue) {
            receivedDate = date
        }
        
        let date = receivedDate?.toStringWithDaySuffix(withTime: false, withYear: true)
        
        return "\(date ?? "")"
    }
    
    func toPurhcaseDateAndTime() -> String {
        var receivedDate: Date?
        
        // check date for both formats #legacybackendbug
        if let date = self.toDate(format: AppDateFormats.longTime_Without_MilliSeconds.rawValue) {
            receivedDate = date
        } else if let date = self.toDate(format: AppDateFormats.longTime.rawValue) {
            receivedDate = date
        }
        
        let time = receivedDate?.toStringCurrentTimezone(dateFormat: AppDateFormats.onlyTime.rawValue)
        let date = receivedDate?.toStringWithDaySuffix(withTime: false)
        
        return "\(time ?? "") on \(date ?? "")"
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}


extension String {
    func getEmojiShortName() -> String {
        let emojiDictionary = EmojiParser.emojisByUnicode
        let emoji = emojiDictionary[self]
        return emoji?.shortName ?? ""
    }
    func getEmojiUnicode() -> String {
        let uni = self.unicodeScalars // Unicode scalar values of the string
        let unicode = uni[uni.startIndex].value // First element as an UInt32
        let emojiUnicode = String(unicode, radix: 16, uppercase: true)
        return emojiUnicode
    }
    
    func unicodeToEmoji() -> String {
        if let validUnicodeScalarValue = Int(self, radix: 16) {
            guard let str = Unicode.Scalar(validUnicodeScalarValue) else { return ""}
            return "\(str)"
        }
        return ""
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    public func convertHtmlToAttributedStringWithColor(font: UIFont?, csscolor: String) -> NSAttributedString? {
        guard let font = font else {
            return htmlToAttributedString
        }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor);}</style>\(self)"
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print(error)
            return nil
        }
    }
    
    func containsUrl(str: String) -> Bool {
        var url = ""
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: str, options: [], range: NSRange(location: 0, length: self.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: str) else { continue }
            url = String(str[range])
        }
        return !url.isEmpty
    }
    
    func getFileType() -> String {
        if self.hasSuffix("jpg") {
            return "jpg"
        } else if self.hasSuffix("jpeg") {
            return "jpeg"
        } else if self.hasSuffix("png") {
            return "png"
        } else {
            return ""
        }
    }
    
    func isImageType() -> Bool {
        let imageTypes = ["jpeg", "jpg", "png", "webp", "svg+xml", "image", "gif"]
        return imageTypes.contains(self)
    }
    
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    var htmlStripped : String {
        return self.replacingOccurrences(of: "<br>", with: "",
                                         options: .regularExpression, range: nil)
    }
    
    public func getSessionStartedTime(startTime: String) -> String {
        let timeInterval = Date.getTimeIntervalBetween(startTimeStamp: startTime, endTimeStamp: nil)
        return "LIVE : Started At \(timeInterval)"
    }
    
    public func getSessionScheduledTime(startTime: String, endTime: String, passedEndDate: Bool = false) -> String {
        
        if passedEndDate {
            return startTime.toUpcomingLiveSessionTime()
        } else {
            // get the minutes and seconds remaining to start
            let minutesWithSecondsToStart = Date.sessionRemainingTime(from: startTime)
            
            if let hour = minutesWithSecondsToStart?.hour, let minutes = minutesWithSecondsToStart?.minutes,
               let seconds = minutesWithSecondsToStart?.seconds {
                if hour < 1 {
                    if minutes <= 10 && minutes > 0 {
                        return "Starting in \(minutes) mins"
                    } else if minutes == 0 && seconds > 0 {
                        return "Starting in \(seconds) secs"
                    } else {
                        return "Starting soon"
                    }
                }
            }
            return startTime.toUpcomingLiveSessionTime()
        }
    }
    
    func getTransactionTime() -> String {
        var receivedDate: Date?
        
        // check date for both formats #legacybackendbug
        if let date = self.toDate(format: AppDateFormats.longTime_Without_MilliSeconds.rawValue) {
            receivedDate = date
        } else if let date = self.toDate(format: AppDateFormats.longTime.rawValue) {
            receivedDate = date
        }
        
        let time = receivedDate?.toStringCurrentTimezone(dateFormat: AppDateFormats.onlyTime.rawValue)
        let date = receivedDate?.toStringWithDaySuffix(withTime: false, withYear: true)
        
        return "\(time ?? "")  \(date ?? "")"
    }
    
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        return (self as NSString).substring(with: result.range)
    }
    
    func genarateThumbnailFromYouTubeID() -> String {
        let urlString = "http://img.youtube.com/vi/\(self.youtubeID ?? "")/hqdefault.jpg"
        return urlString
    }
    
    func getSchoolSubdomain() -> String {
        return self.components(separatedBy: ".").first ?? ""
    }
    
    public func getUpcomingSessionScheduledTime(startTime: String, endTime: String, passedEndDate: Bool = false) -> String {
        
        if passedEndDate {
            return startTime.toUpcomingLiveSessionTime()
        } else {
            // get the minutes and seconds remaining to start
            let minutesWithSecondsToStart = Date.sessionRemainingTime(from: startTime)
            let dateInSameYear = Date.dateIsInSameYear(from: startTime)
            let sessionTime = startTime.messageTime()
            if let week = minutesWithSecondsToStart?.week,
               let hour = minutesWithSecondsToStart?.hour,
               let minutes = minutesWithSecondsToStart?.minutes,
               let seconds = minutesWithSecondsToStart?.seconds {
                if !dateInSameYear {
                    return startTime.toUpcomingLiveSessionTime(year: true)
                } else if dateInSameYear && week >= 1 {
                    return startTime.toUpcomingLiveSessionTime(year: false)
                } else if week < 1 && hour > 48 {
                    return startTime.upcomingSessionTimeInDay(startTime: startTime)
                } else if Calendar.current.isDateInTomorrow(startTime.messageDate()) {
                    return "Tomorrow \(startTime.toUpcomingLiveSessionTime(year: false))"
                } else if  Calendar.current.isDateInToday(startTime.messageDate()) && hour > 3 {
                    return "Today \(startTime.toUpcomingLiveSessionTime(year: false))"
                } else if hour < 3 && hour > 1 {
                    return "Starts in \(hour) hrs \(minutes) min · \(sessionTime)"
                } else if minutes > 10 && hour < 1 {
                    return "Starts in \(minutes) mins · \(sessionTime)"
                } else if hour < 1 {
                    if minutes <= 10 && minutes > 0 {
                        return "Starting in \(minutes) mins"
                    } else if minutes == 0 && seconds > 0 {
                        return "Starting in \(seconds) secs"
                    } else {
                        return "Scheduled to start \(sessionTime)"
                    }
                }
            }
            return startTime.toUpcomingLiveSessionTime()
        }
    }
    
    func upcomingSessionTimeInDay(startTime: String) -> String {
        var receivedDate: Date?
        
        // check date for both formats #legacybackendbug
        if let date = self.toDate(format: AppDateFormats.longTime_Without_MilliSeconds.rawValue) {
            receivedDate = date
        } else if let date = self.toDate(format: AppDateFormats.longTime.rawValue) {
            receivedDate = date
        }
        let day = receivedDate?.getTodayWeekDay()
        let dateTime = startTime.toUpcomingLiveSessionTime(year: false)
        return "\(day ?? ""), \(dateTime )"
    }
}

extension Optional where Wrapped == String {
    
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}


extension String {
    /**
     Returns a substring in that range

     - Parameter range: The range to substring.

     - Returns: A new string.
     */
    subscript(_ range: NSRange) -> String {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        let subString = self[start..<end]
        return String(subString)
    }

}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
