//
//  TableView+Extension.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 03/07/21.
//

import Foundation
import UIKit

extension UITableView {

    func scrollToBottom(animation: Bool = true) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                if indexPath.item >= 0 && indexPath.section >= 0 {
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animation)
                }
            }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: 0,
                section:0 )
            
            self.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
