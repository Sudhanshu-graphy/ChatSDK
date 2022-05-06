//
//  Date+Helpers.swift
//  Graphy
//
//  Created by Rahul Kumar on 26/03/21.
//

import Foundation

extension Date {
    func toStringUTCTimeZone(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func toStringCurrentTimezone(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func toStringWithDaySuffix(withTime: Bool, withYear: Bool = true) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = dateFormatWithSuffix(withTime: withTime, withYear: withYear)
        var dateString = dateFormatter.string(from: self)
        
        if dateString.prefix(1) == "0" {
            dateString = String(dateString.dropFirst())
        }
        return dateString
    }
    
    func dateAt(hours: Int, minutes: Int) -> Date {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        // get the month/day/year componentsfor today's date.
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        // Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
    
    /// Returns the amount of days from another date
    ///
    /// - Parameter date: date with which to compare
    /// - Returns: the difference in days
    func days(from date: Date) -> Int? {
        Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /// To check that date lies between two dates or not
    ///
    /// - Parameters:
    ///   - startDate: date must be greater then this date
    ///   - endDate: date must be less then this date
    /// - Returns: boolean indicating that date lies between startDate and endDate or not
    func isBetween(startDate: Date, endDate: Date) -> Bool {
        (startDate.compare(self) == .orderedAscending) && (endDate.compare(self) == .orderedDescending)
    }
    
    
    /// To calculate time to go for the receiver date
    /// - Returns: time difference in string form
    func timeAgoSinceDate() -> String {
        // From Time
        let fromDate = self
        // To Time
        let toDate = Date()
        
        // Estimation calculation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return "\(interval)" + " " + "min ago"// interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "just now"
    }
    
    /// To calculate time difference between the caller and receiver date with interval in words
    /// - Parameter fromDate: Date object from where difference will be calculated
    /// - Returns: time difference between two dates as string
    func differenceSinceDate(_ fromDate: Date) -> String {
        // Estimation calculation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: self, to: fromDate).year, interval > 0 {
            
            return interval == 1 ? "\(interval.asWord)" + " " + "year" : "\(interval.asWord)" + " " + "years"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: self, to: fromDate).month, interval > 0 {
            
            return interval == 1 ? "\(interval.asWord)" + " " + "month" : "\(interval.asWord)" + " " + "months"
        }
        
        // Week
        if let interval = Calendar.current.dateComponents([.weekOfMonth], from: self, to: fromDate).day, interval > 0 {
            
            return interval == 1 ? "\(interval.asWord)" + " " + "week" : "\(interval.asWord)" + " " + "weeks"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: self, to: fromDate).day, interval > 0 {
            
            return interval == 1 ? "\(interval.asWord)" + " " + "day" : "\(interval.asWord)" + " " + "days"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: self, to: fromDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval.asWord)" + " " + "hour" : "\(interval.asWord)" + " " + "hours"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: self, to: fromDate).minute, interval > 0 {
            
            return "\(interval.asWord)" + " " + "min"// interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "one month"
    }
    
    // Check if date is in x (or less) minutes of current time. Will return true if date is in past
    func isIn(minutes x: Int) -> Bool {
        guard self.isFuture() else { return true }
        
        let minutes = Int(self.timeIntervalSince1970 - Date().timeIntervalSince1970)/60
        
        return minutes <= x
    }
    
    private func dateFormatWithSuffix(withTime: Bool, withYear: Bool = true) -> String {
        if withYear {
            return withTime ? "HH:mm a, dd'\(self.daySuffix())' MMMM yyyy" : "dd'\(self.daySuffix())' MMM yyyy"
        } else {
            return withTime ? "HH:mm a, dd'\(self.daySuffix())' MMMM" : "dd'\(self.daySuffix())' MMM"
        }
    }
    
    private func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
    
    func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
    
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
    }
    
    static func timeStringFromTimeStamp(timeStamp: Int64) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let createdTime = Date.dateFromTimeStamp(timeStamp: timeStamp)
        let createdTimeString  = dateFormatter.string(from: createdTime)
        return createdTimeString
    }
    
    static func dateFromTimeStamp(timeStamp : Int64) -> Date {
        let messageTimeStamp = Double(timeStamp) / 1000.0
        let messageDate = Date(timeIntervalSince1970: messageTimeStamp)
        return messageDate
    }
    
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func getTodayWeekDay() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "EEEE"
          let weekDay = dateFormatter.string(from: self)
          return weekDay
    }
    
    static func getMonthAndYearBetween(from start: Date?, to end: Date?) -> [Date] {
        var allDates: [Date] = []
        guard let start = start,
              let end = end,
              start < end else { return allDates }
        
        let calendar = Calendar.current
        let month = calendar.dateComponents([.month], from: start, to: end).month ?? 0
        
        for i in 0...month {
            if let date = calendar.date(byAdding: .month, value: i, to: start) {
                allDates.append(date)
            }
        }
        return allDates
    }
    
    static func getTimeIntervalBetween(startTimeStamp: String, endTimeStamp: String?) -> String {
        // if start date is not available, return empty string
        var startDate = longDateFrom(string: startTimeStamp)
        
        if startDate == nil {
            startDate = longDateWithoutMilliSecFrom(string: startTimeStamp)
        }
        
        guard let startDate = startDate else { return "" }
        
        let startTime = timeStringFromTimeStamp(timeStamp: Int64((startDate.timeIntervalSince1970 * 1000.0).rounded()))
        
        // if end date string is not available, return start time
        guard let endTimeStamp = endTimeStamp else { return startTime }
        
        var endDate = longDateFrom(string: endTimeStamp)
        
        if endDate == nil {
            endDate = longDateWithoutMilliSecFrom(string: endTimeStamp)
        }
        
        // if end date is not available, return start time
        guard let endDate = endDate else { return startTime }
        
        let endTime = timeStringFromTimeStamp(timeStamp: Int64((endDate.timeIntervalSince1970 * 1000.0).rounded()))
        
        return "\(startTime) to \(endTime), \(startDate.toStringCurrentTimezone(dateFormat: AppDateFormats.onlyDate.rawValue))\(startDate.daySuffix()) \(startDate.toStringCurrentTimezone(dateFormat: AppDateFormats.onlyMonthLong.rawValue))"
    }
    
    static func longDateFrom(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.dateFormat = AppDateFormats.longTime.rawValue
        return dateFormatter.date(from: string)
    }
    
    static func longDateWithoutMilliSecFrom(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.dateFormat = AppDateFormats.longTime_Without_MilliSeconds.rawValue
        return dateFormatter.date(from: string)
    }
    
    // swiftlint:disable large_tuple
    static func sessionRemainingTime(from startTimeStamp: String?) -> (year: Int?, week: Int?, hour: Int?, minutes: Int?, seconds: Int?)? {
        guard let startTimeStamp = startTimeStamp else { return nil }
        
        var startDate = longDateFrom(string: startTimeStamp)
        
        if startDate == nil {
            startDate = longDateWithoutMilliSecFrom(string: startTimeStamp)
        }
        
        guard let startDate = startDate else { return nil }
        
        let difference = Calendar.current.dateComponents([.year, .weekOfMonth, .hour, .minute, .second], from: Date(), to: startDate)
        
        return (difference.year, difference.weekOfMonth, difference.hour, difference.minute, difference.second)
    }
    
    static func passedEndTime(from date: String) -> Bool {
        
        var endDate = longDateFrom(string: date)
        
        if endDate == nil {
            endDate = longDateWithoutMilliSecFrom(string: date)
        }
        
        guard let endDate = endDate else { return false }
        
        return endDate < Date()
    }
    
    static func dateIsInSameYear(from startTimeStamp: String?) -> Bool {
        guard let startTimeStamp = startTimeStamp else { return false }
        
        var startDate = longDateFrom(string: startTimeStamp)
        
        if startDate == nil {
            startDate = longDateWithoutMilliSecFrom(string: startTimeStamp)
        }
        
        guard let startDate = startDate else { return false }
        
        return startDate.isInThisYear

    }
}

extension Date {

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}


extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
