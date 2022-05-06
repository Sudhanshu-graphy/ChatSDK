//
//  CollectionView+Helper.swift
//  CollectionView+Helper
//
//  Created by Sudhanshu Dwivedi on 19/08/21.
//

import Foundation
import UIKit


enum ElementKind: String {
    case badge = "badge-element-kind"
    case background = "background-element-kind"
    case sectionHeader = "section-header-element-kind"
    case sectionFooter = "section-footer-element-kind"
    case layoutHeader = "layout-header-element-kind"
    case layoutFooter = "layout-footer-element-kind"
}

extension UICollectionView {
    
    func registerHeader(with identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: ElementKind.sectionHeader.rawValue,
          withReuseIdentifier: identifier)
    }
    
    func registerFooter(with identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: ElementKind.sectionFooter.rawValue,
          withReuseIdentifier: identifier)
    }
}


extension UICollectionView {

    func isValid(indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections,
              indexPath.row < numberOfItems(inSection: indexPath.section)
            else { return false }
        return true
    }

}
