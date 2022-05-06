//
//  Configuration.swift
//  Graphy
//
//  Created by Rahul Kumar on 29/03/21.
//

import Foundation

enum Configuration {
    enum Environment: String {
        case page
        case development
        case staging
        case production
        
        var scheme: String {
            switch self {
            case .page: return "https://"
            case .development: return "http://"
            case .staging: return "https://"
            case .production: return "https://"
            }
        }
        
        var domain: String {
            switch self {
            case .page: return "graphyapp.page" // staging
            case .development: return "graphyapp.in" // dev
            case .staging: return "graphyapp.in" // beta
            case .production: return "graphy.com" // prod
            }
        }
        
        var baseURL: String {
            switch self {
            case .page: return "https://api.graphyapp.page/v1"
            case .development: return "http://dev.graphyapp.in/v1"
            case .staging: return "https://api.graphyapp.in/v1"
            case .production: return "https://api.graphy.com/v1"
            }
        }
        
        var forwardedHost: String {
            switch self {
            case .page: return "\(LocalData.savedSchools?.first?.subdomain ?? "").graphyapp.page"
            case .development: return "\(LocalData.savedSchools?.first?.subdomain ?? "").localhost:3000"
            case .staging: return "\(LocalData.savedSchools?.first?.subdomain ?? "").graphyapp.in"
            case .production: return "\(LocalData.savedSchools?.first?.subdomain ?? "").graphy.com"
            }
        }
        
        var forwardedHostEndPoint: String {
            switch self {
            case .page: return ".graphyapp.page"
            case .development: return ".localhost:3000"
            case .staging: return ".graphyapp.in"
            case .production: return ".graphy.com"
            }
        }
        
        var amplitudeAPIKey: String {
            switch self {
            #if DEBUG
            case .production: return "fea8d624c074d67ad01122201dff4d9b"
            #else
            case .production: return "392ad80116a9dd648009869c44b94992"
            #endif
            default: return "fea8d624c074d67ad01122201dff4d9b"
            }
        }
        
        var chatBaseURL: String {
            switch self {
            case .page: return "https://chat.graphyapp.page/api/v1/web/"
            case .development: return "https://chat.graphyapp.page/api/v1/web/"
            case .staging: return "https://chat.graphyapp.in/api/v1/web/"
            case .production: return "https://chat.graphy.com/api/v1/web/"
            }
        }
        
        var chatUploadBaseURL: String {
            switch self {
            case .page: return "https://chat.graphyapp.page/api/v2/misc/"
            case .development: return "https://chat.graphypp.in/api/v2/misc/"
            case .staging: return "https://chat.graphyapp.in/api/v2/misc/"
            case .production: return "https://chat.graphy.com/api/v2/misc/"
            }
        }
        
        var socketBaseURL: String {
            switch self {
            case .page: return "wss://chat.graphyapp.page"
            case .development: return "wss://chat.graphyapp.in"
            case .staging: return "wss://chat.graphyapp.in"
            case .production: return "wss://chat.graphy.com"
            }
        }
        
        var baseV2URL: String {
            switch self {
            case .page: return "https://api.graphyapp.page/v2"
            case .development: return "http://dev.graphyapp.in/v2"
            case .staging: return "https://api.graphyapp.in/v2"
            case .production: return "https://api.graphy.com/v2"
            }
        }
        
        var analyticsBaseURL: String {
            switch self {
            case .production: return "https://analytics.graphy.com"
            default: return "https://analytics.graphyapp.in"
            }
        }
        
        var chatBaseV2URL: String {
            switch self {
            case .page: return "https://chat.graphyapp.page/api/v2/web/"
            case .development: return "https://chat.graphyapp.page/api/v2/web/"
            case .staging: return "https://chat.graphyapp.in/api/v2/web/"
            case .production: return "https://chat.graphy.com/api/v2/web/"
            }
        }
    }
    
    // MARK:- Environment Variables
    #if DEBUG
    static private let selectedEnvironment = Environment.production
    #else
    static private let selectedEnvironment = Environment.production
    #endif
    
    static var schemeString: String {
        selectedEnvironment.scheme
    }
    
    static var domainString: String {
        selectedEnvironment.domain
    }
    
    static var environmentString: String {
        selectedEnvironment.rawValue
    }
    
    static var baseURLString: String = {
        selectedEnvironment.baseURL
    }()
    
    static var forwardedHost: String {
        selectedEnvironment.forwardedHost
    }
    
    static var forwardedHostEndpoint: String {
        selectedEnvironment.forwardedHostEndPoint
    }
    
    static var amplitudeAPIKey: String {
        selectedEnvironment.amplitudeAPIKey
    }
    
    static var version: String = {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }()
    
    static var build: String = {
        return (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }()
    
    static var chatBaseURLString: String {
        selectedEnvironment.chatBaseURL
    }
    
    static var socketBaseURLString: String {
        selectedEnvironment.socketBaseURL
    }
    
    static var chatUploadBaseURLString: String {
        selectedEnvironment.chatUploadBaseURL
    }
    
    static var baseV2URLString: String {
        selectedEnvironment.baseV2URL
    }
    
    static var chatbaseV2URLString: String {
        selectedEnvironment.chatBaseV2URL
    }
    
    static var analyticsBaseURL: String {
        selectedEnvironment.analyticsBaseURL
    }
    
    static var termsURL: String {
        "https://graphy.com/terms"
    }
    
    static var privacyURL: String {
        "https://graphy.com/privacy"
    }
    
    static var supportEmail: String {
        "support@graphy.com"
    }
    
    static var faqURL: String {
        "https://getgraphy.notion.site/FAQs-b1ff308a2b374b1e9e198a8d90663981"
    }
    
    static var supportEmailBody: String {
        "Email: \(LocalData.loggedInUser?.email ?? "NA")\nApp Version: iOS \(Configuration.version) (\(Configuration.build))\nSchool: \(LocalData.loggedInUser?.school?.title ?? "NA")\nCustomer id: \(LocalData.loggedInUser?.UUID ?? "NA")"
    }
    
    static var appName: String {
        Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
    }
    
    static func appendDomainURL(domain: String) -> String {
        switch selectedEnvironment {
        case .page: return "\(domain).graphyapp.page"
        case .development: return "\(domain).localhost:3000"
        case .staging: return "\(domain).graphyapp.in"
        case .production: return "\(domain).graphy.com"
        }
    }
    
    static var verloopClientID: String {
        "graphy"
    }
    
    static var verloopRecipeID: String {
        "KscbamZgFMKEiBoPL"
    }
    
    static var isDebugging: Bool {
        #if DEBUG
        return true
        #else
        return true
        #endif
    }
    
    static var intercomApiKey: String {
        if selectedEnvironment != .production {
            return "ios_sdk-9660a823f25339fc8e24cf9be0b5d5e5c79c3062"
        }
        return "ios_sdk-4551f662ac5c92c964b54d5e134d452cf6644397"
    }
    
    static var intercomAppID: String {
        if selectedEnvironment != .production {
            return "jdd9mtxn"
        }
        return "xt1fnubq"
    }
    
    static var zoomSDKKey: String {
        return "QMxUccGJpbfSXYKS9a048bCbGPSyy3kBBh7l"
    }
    
    static var zoomSDKSecret: String {
        return "miydSHX8QmGFOvfa63Jo8zSqZf0KRSqEvJw5"
    }
    
    static var pusherKey: String {
        if selectedEnvironment != .production {
            return "f403d7844b2f275877de"
        }
        return "3f96b407d964b7dd2597"
    }
    
    static var pusherCluster: String {
        return "ap2"
    }
    
    static func getSchoolURL(from subdomain: String) -> URL? {
        return URL(string: schemeString + subdomain + forwardedHostEndpoint)
    }
    
    static func getProfileURL(for username: String) -> URL? {
        return URL(string: schemeString + domainString + "/u/" + username)
    }
}
