//
//  UIImagePickerController+Helper.swift
//  Graphy
//
//  Created by Raj Dhakate on 11/09/21.
//

import Foundation
import UIKit

// Extension to correct the editing box stuck at centre issue
extension UIImagePickerController {
    open override var childForStatusBarHidden: UIViewController? {
        return nil
    }

    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fixCannotMoveEditingBox()
    }
    
    func fixCannotMoveEditingBox() {
            if let cropView = cropView,
               let scrollView = scrollView,
               scrollView.contentOffset.y == 0 {
                
                var top: CGFloat = 0.0
                if #available(iOS 11.0, *) {
                    top = cropView.frame.minY // + self.view.safeAreaInsets.top // removed for buggy cropped frame in iPhone 11, redo logic is cropped frame is wrong for iPhone SE
                } else {
                    // Fallback on earlier versions
                    top = cropView.frame.minY
                }
                let bottom = scrollView.frame.height - cropView.frame.height - top
                scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
                
                var offset: CGFloat = 0
                if scrollView.contentSize.height > scrollView.contentSize.width {
                    offset = 0.5 * (scrollView.contentSize.height - scrollView.contentSize.width)
                }
                scrollView.contentOffset = CGPoint(x: 0, y: -top + offset)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.fixCannotMoveEditingBox()
            }
        }
        
        var cropView: UIView? {
            return findCropView(from: self.view)
        }
        
        var scrollView: UIScrollView? {
            return findScrollView(from: self.view)
        }
        
        func findCropView(from view: UIView) -> UIView? {
            let width = UIScreen.main.bounds.width
            let size = view.bounds.size
            if width == size.height, width == size.height {
                return view
            }
            for view in view.subviews {
                if let cropView = findCropView(from: view) {
                    return cropView
                }
            }
            return nil
        }
        
        func findScrollView(from view: UIView) -> UIScrollView? {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
            for view in view.subviews {
                if let scrollView = findScrollView(from: view) {
                    return scrollView
                }
            }
            return nil
        }
}