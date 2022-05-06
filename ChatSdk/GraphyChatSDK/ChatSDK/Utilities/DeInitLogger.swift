//
//  DeInitLoggerViewController.swift
//  Graphy
//
//  Created by Raj Dhakate on 09/09/21.
//

import UIKit

class DeInitLoggerViewController: UIViewController {
    deinit {
        print("🪵 DeInit Logger: \(String.init(describing: self))")
    }
}

class DeInitLoggerNSObject: NSObject {
    deinit {
        print("🪵 DeInit Logger: \(String.init(describing: self))")
    }
}
