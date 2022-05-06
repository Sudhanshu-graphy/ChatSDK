//
//  DebugUtil.swift
//  Graphy
//
//  Created by Akshit Talwar on 15/05/21.
//

import Foundation

/// Is this a testing build of some sort? Specifically, a debug build, TestFlight, simulator or
/// installed through Xcode?
var isTestingBuild: Bool {
    #if DEBUG
    return true
    #else
    return isRunningOnSimulator
        || isSandBoxReceiptPresent
        || isMobileProvisionPresent
        || true
    #endif
}

var isRunningOnSimulator: Bool {
    #if arch(i386) || arch(x86_64)
    NSLog("Running on simulator")
    return true
    #else
    return false
    #endif
}

/// Apps installed through Xcode/Testflight will have a sandbox receipt in them.
private var isSandBoxReceiptPresent: Bool {
    return Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
}

/// Apps installed through Xcode/Testflight will have a mobile provisioning profile embedded in them.
private var isMobileProvisionPresent: Bool {
    return Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil
}
