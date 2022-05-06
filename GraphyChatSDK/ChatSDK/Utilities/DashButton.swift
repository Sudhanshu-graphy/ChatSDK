//
//  DashButton.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 26/08/21.
//

import Foundation
import UIKit

class DashButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedBottomLine"
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = (AppColors.slate04 ?? UIColor.gray).cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [2, 2]

        let path = CGMutablePath()
        path.move(to: CGPoint(x:0, y: frame.height))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        shapeLayer.path = path

        layer.addSublayer(shapeLayer)

    }
}
