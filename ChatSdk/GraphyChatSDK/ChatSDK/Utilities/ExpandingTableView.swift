//
//  ExpandingTableView.swift
//  Graphy
//
//  Created by Raj Dhakate on 21/10/21.
//

import Foundation
import UIKit

final class ExpandingTableView: UITableView {

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

}
