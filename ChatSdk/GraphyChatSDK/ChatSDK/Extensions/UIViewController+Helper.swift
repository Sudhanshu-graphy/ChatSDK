//
//  UIViewController+Helper.swift
//  Graphy
//
//  Created by Raj Dhakate on 17/08/21.
//

import Foundation
import UIKit

enum MatchingViewType {
    case bounds, frame
}

extension UIViewController {
    func add(_ child: UIViewController, matching: MatchingViewType = .frame) {
        addChild(child)
        if matching == .bounds {
            child.view.frame = view.bounds
        } else {
            child.view.frame = view.frame
        }
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func add(_ child: UIViewController?, into view: UIView?) {
        guard let child = child,
              let view = view else { return }
        addChild(child)
        child.view.frame = view.bounds
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func add(_ child: UIViewController, asSubViewToStack stackView: UIStackView) {
        addChild(child)
        stackView.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    var className: String {
        String(describing: self.self)
    }
}
