//
//  ToastView.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 09/07/21.
//

import UIKit


/// Position where toast is to be displayed
/// - `top`: Top of the screen. Default offset downward by `window.safeAreaInsets.top`
/// - `bottom`: Bottom of the screen. Default offset upward by `window.safeAreaInsets.bottom + 50 (tabbar height)`
/// - `center`: Center of the screen. Default offset downward by 50
public enum ToastPosition {
    /// Top of the screen. Default offset downward by `window.safeAreaInsets.top`
    case top
    /// Bottom of the screen. Default offset upward by `window.safeAreaInsets.bottom + 50 (tabbar height)`
    case bottom
    /// Center of the screen. Default offset downward by 50
    case center
}


public protocol ToastView: AnyObject {
    /// Shows the toast at the `position` on screen  (with alpha animation)
    /// - Parameters:
    ///   - position: Position on the screen. Defaults to `bottom`
    ///   - offset: Y-Offset from the middle of the screen. +ve value to shift it downwards and -ve value to shift it upwards. Default is `nil` and calculated based on the value of `position`
    ///   - duration: Duration for which the toast is to be shown (Default 3)
    ///   - completion: Completion block to called when toast duration is over
    func show(at position: ToastPosition, offset: CGFloat?, duration: TimeInterval, completion: (() -> Void)?)
}


public extension ToastView where Self : UIView {

    func show(at position: ToastPosition = .bottom, offset: CGFloat? = nil, duration: TimeInterval = 2.0, completion: (() -> Void)? = nil) {
        
        
        guard let window = getKeyWindow() else { return }

        window.addSubview(self)
        window.bringSubviewToFront(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        let insetLR: CGFloat = 16
        var constraints = [
            trailingAnchor.constraint(greaterThanOrEqualTo: window.trailingAnchor, constant: -insetLR),
            leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: insetLR),
            centerXAnchor.constraint(equalTo: window.centerXAnchor)]


        var defaultOffsets = (top: CGFloat(20), bottom: CGFloat(10), center: CGFloat(50))
        // use safe area
        defaultOffsets.top = window.safeAreaInsets.top
        defaultOffsets.bottom = window.safeAreaInsets.bottom + 50 // 50 is tab bar height

        switch position {
        case .bottom:
            constraints.append(bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: offset ?? -defaultOffsets.bottom))
        case .center:
            constraints.append(centerYAnchor.constraint(equalTo: window.centerYAnchor, constant: offset ?? defaultOffsets.center))
        case .top:
            constraints.append(topAnchor.constraint(equalTo: window.topAnchor, constant: offset ?? defaultOffsets.top))
        }
        NSLayoutConstraint.activate(constraints)


        self.alpha = 0.0

        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.alpha = 1.0
        }, completion: { [weak self] _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: [.curveEaseInOut], animations: {
                self?.alpha = 0.0
            }, completion: { _ in
                self?.removeFromSuperview()
                completion?()
            })
        })
    }
}


@inline(__always)
func getKeyWindow() -> UIWindow? {
    UIApplication.shared.windows.first(where: \.isKeyWindow)
}
