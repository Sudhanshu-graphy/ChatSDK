//
//  ViewEmbeder.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 15/09/21.
//

import Foundation
import UIKit
enum ViewEmbedder {
    
    static func embed(
        parent:UIViewController,
        container:UIView,
        child:UIViewController,
        previous:UIViewController?) {
        
        if let previous = previous {
            removeFromParent(vc: previous)
        }
        child.willMove(toParent: parent)
        parent.addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: parent)
        let w = container.frame.size.width
        let h = container.frame.size.height
        child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }
    
    static func removeFromParent(vc:UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    static func embed(child: UIViewController, parent:UIViewController, container:UIView, completion:((UIViewController) -> Void)? = nil) {
        embed(
            parent: parent,
            container: container,
            child: child,
            previous: parent.children.first
        )
        completion?(child)
    }
    
}
