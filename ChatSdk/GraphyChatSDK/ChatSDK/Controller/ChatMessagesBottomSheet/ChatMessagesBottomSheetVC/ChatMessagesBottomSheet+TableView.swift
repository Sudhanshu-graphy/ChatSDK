//
//  ChatMessagesBottomSheet+TableView.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 25/06/21.
//

import Foundation
import UIKit

enum ActionRowType: Int {
    case replyThread = 0
    case copyText = 1
    case deleteMessage = 2
    case copyLink = 3
}

extension ChatMessagesBottomSheet : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionsVM.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetActionsCell", for: indexPath) as? BottomSheetActionsCell else {
            return UITableViewCell()
        }
        cell.configure(with: actionsVM.getCellViewModel(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFromThread {
            self.dismiss(animated: true) {
                UIPasteboard.general.string = self.message
                self.delegate?.dismissSheet()
            }
        } else {
            let type = ActionRowType(rawValue: indexPath.row)
            switch type {
            case .replyThread:
                self.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.sendInfo(indexPath: self.indexPath)
                }
            case .copyText:
                self.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    UIPasteboard.general.string = self.message
                    self.delegate?.dismissSheet()
                }
            case .copyLink:
                // Copy link
                break
            case .deleteMessage:
                self.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.sendDeleteMessageInfo(indexPath: self.indexPath)
                }
            default:
                break
            }
        }
    }
}
