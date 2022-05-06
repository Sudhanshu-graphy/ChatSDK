//
//  UIView+Helpers.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 23/06/21.
//

import Foundation
import UIKit

extension UIView {
    func setCornerRadiusAndBorderToView(cornerRadius:Int = 0, borderWidth:CGFloat = 0.0, borderColor:UIColor = .clear, withMask: Bool = false) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.cgColor
        withMask == true ? self.layer.masksToBounds = true : nil
    }
    
    public var safeAreaFrame: CGRect {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide.layoutFrame
        }
        return bounds
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func makeRounded() {
        let radius = self.frame.width/2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func applyGradient(colours: [UIColor]?, horizontal: Bool = false) {
        if let colours = colours {
            if horizontal {
                self.applyGradient(colours: colours, locations: nil, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
            } else {
                self.applyGradient(colours: colours, locations: nil, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
            }
        } else {
            self.layer.sublayers?.first(where: { $0.name == "gradient" })?.removeFromSuperlayer()
        }
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?, startPoint: CGPoint, endPoint: CGPoint, frame: CGRect? = nil) {
        let gradient: CAGradientLayer = self.layer.sublayers?.first(where: { $0.name == "gradient" }) as? CAGradientLayer ?? CAGradientLayer()
        gradient.name = "gradient"
        gradient.frame = frame ?? bounds
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.cornerRadius = layer.cornerRadius
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}
