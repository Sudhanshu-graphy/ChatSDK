//
//  LocalData.swift
//  Graphy
//
//  Created by Rahul Kumar on 24/02/21.
//

import Foundation

enum LocalData {
//    @SavedCodable(key: "school")
//    static var school: School?
    
    @SavedCodable(key: "loggedInUser")
    static var loggedInUser: User?
    
    @SavedValue(key: "subdomain")
    static var subdomain: String?
    
    @SavedCodable(key: "tokens")
    static var token: Token?
    
    @SavedValue(key: "pushNotificationToken")
    static var pushNotificationToken: String?
    
    @SavedValue(key: "deeplinkData")
    static var deeplinkData: [String:Any]?
    
    // MARK: Required data for New Community flow
    @SavedCodable(key: "savedCommunities")
    static var savedSchools: [School]?
    
    // MARK: Required data for Login Analytics
    @SavedCodable(key: "loggedInProvider")
    static var loggedInProvider: String?
    
    @SavedValue(key: "sessionReminders")
    static var sessionReminders: [String]?
    
    @SavedValue(key: "schoolUUID")
    static var schoolUUID: String?
    
    @SavedValue(key: "deeplink")
    static var deeplink: String?
    
    @SavedValue(key: "isOpenCommunityEnabled")
    static var isOpenCommunityEnabled: Bool?
    
    @SavedValue(key: "totalMembers")
    static var totalMembers: String?
    
    static func removeAll() {
//        school = nil
        loggedInUser = nil
        subdomain = nil
        token = nil
        pushNotificationToken = nil
        deeplinkData = nil
        sessionReminders = nil
        schoolUUID = nil
        deeplink = nil
        loggedInProvider = nil
        isOpenCommunityEnabled = nil
        totalMembers = nil
    }
}

// MARK:- Codable Structure/Class Property Wrapper
@propertyWrapper
class SavedCodable<Type: Codable> {
    let key: String
    let loc: UserDefaults = UserDefaults.standard
    var actualValue: Type?
    
    init(key: String) {
        self.key = "\(Bundle.main.bundleIdentifier ?? "")\(key)"
    }
    
    var wrappedValue: Type? {
        get {
            if actualValue == nil {
                let decoder = JSONDecoder()
                if let data = loc.data(forKey: key), let value = try? decoder.decode(Type.self, from: data) {
                    actualValue = value
                }
            }
            return actualValue
        }
        set {
            actualValue = newValue
            if let obj = newValue {
                let encoder = JSONEncoder()
                if let data = try? encoder.encode(obj) {
                    loc.set(data, forKey: key)
                    loc.synchronize()
                }
            } else {
                loc.set(nil, forKey: key)
                loc.synchronize()
            }
        }
    }
}

// MARK:- Single Value Property Wrapper
@propertyWrapper
class SavedValue<Type> {
    let key: String
    let loc: UserDefaults = UserDefaults.standard
    var actualValue: Type?
    
    init(key: String) {
        self.key = "\(Bundle.main.bundleIdentifier ?? "")\(key)"
    }
    
    var wrappedValue: Type? {
        get {
            if actualValue == nil {
                if let data = loc.object(forKey: key) {
                    actualValue = data as? Type
                }
            }
            return actualValue
        }
        set {
            actualValue = newValue
            if let obj = newValue {
                loc.set(obj, forKey: key)
                loc.synchronize()
            } else {
                loc.set(nil, forKey: key)
                loc.synchronize()
            }
        }
    }
}
