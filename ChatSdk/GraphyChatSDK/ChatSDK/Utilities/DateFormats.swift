//
//  DateFormats.swift
//  Graphy
//
//  Created by Rahul Kumar on 26/03/21.
//

import Foundation

enum AppDateFormats: String {
    // Date formats
    case longTime_With_Z = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case longTime = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case longTime_Without_MilliSeconds = "yyyy-MM-dd'T'HH:mm:ssZ"
    case year_Month_Day = "yyyy-MM-dd"
    case time_Day_Month_Year = "HH:mm a, DD MMMM yyyy"
    case year_Month_Day_Time = "yyyy-MM-dd h:mm:ss a"
    case day_Month_Year = "dd-MM-yyyy"
    case day_slash_Month_slash_Year = "dd/MM/yyyy"
    case onlyTime = "hh:mm a"
    case onlyDate = "dd"
    case onlyMonthLong = "MMM"
}
