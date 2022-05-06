//
//  UIImage+Helper.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 23/07/21.
//

import Foundation
import UIKit

extension UIImage {
    
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: 4
        ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }
    
    func getSizeIn(_ type: DataUnits) -> Int {
        
        guard let data = self.pngData() else {
            return 0
        }
        
        var size: Int = 0
        
        switch type {
        case .byte:
            size = Int(data.count)
        case .kilobyte:
            size = Int(data.count) / 1024
        case .megabyte:
            size = Int(data.count) / 1024 / 1024
        case .gigabyte:
            size = Int(data.count) / 1024 / 1024 / 1024
        }
        
        return size
    }
    
    func upOrientationImage() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
    
    class func imageForToolBar(with color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context!.setFillColor(color.cgColor)
        context!.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}
