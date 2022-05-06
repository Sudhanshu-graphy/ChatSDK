//
//  MessageThreadsVC+TableView.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/06/21.
//

import Foundation
import UIKit

extension MessageThreadsVC:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == mentionsTableView {
            return 1
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == mentionsTableView {
            return nil
        } else {
            repliesCount = repliesVM.numberOfRows
            let sectionType = MessageThreadsSectionType(rawValue: section)
            switch sectionType {
            case .message:
                let headerView = self.getHeaderView(font: AppFont.fontOf(type: .Medium, size: 12), color: AppColors.slate03, text: "Message in \(channelName)")
                return headerView
                
            case .replies:
                var repliesLabel = ""
                if repliesCount > 0 {
                    let repliesText = (repliesCount == 1) ? "reply" : "replies"
                    repliesLabel = "\(repliesCount) \(repliesText)"
                }
                let headerView = self.getHeaderView(font: AppFont.fontOf(type: .Medium, size: 12), color: AppColors.dashBlueDefault, text: repliesLabel)
                return headerView
                
            default:
                return UIView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == mentionsTableView {
            return 0
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == mentionsTableView {
            return 0
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mentionsTableView {
            return filteredMentions.count
        } else {
            let sectionType = MessageThreadsSectionType(rawValue: section)
            switch sectionType {
            case .message:
                return messageVM?.numberOfItem ?? 0
                
            case .replies:
                return repliesVM.numberOfRows
                
            default:
                return 0
            }

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == mentionsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MentionsCell", for: indexPath) as? MentionsCell
            else {
                return UITableViewCell()
            }
            cell.configData(with: filteredMentions[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessagesTextCell", for: indexPath) as? ChatMessagesTextCell else {
                return UITableViewCell()
            }
            
            let sectionType = MessageThreadsSectionType(rawValue: indexPath.section)
            
            switch sectionType {
            
            case .message:
                guard let dataVM = messageVM else { return UITableViewCell()}
                cell.configure(with: dataVM.getCellViewModel(at: indexPath))
                cell.showRepliesSection(isHidden: true)
                cell.showSeperatorView(isHidden: false)
                cell.delegate = self
                
            case .replies:
               cell.showEmojiSection(isHidden: true)
               cell.showRepliesSection(isHidden: true)
                if let data = repliesVM.getCellViewModel(at: indexPath) {
                    cell.configure(with: data)
                }
               cell.showSeperatorView(isHidden: true)
               cell.delegate = self
            default:
                break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == mentionsTableView {
            return 40
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == mentionsTableView {
            let firstName = filteredMentions[indexPath.row].firstName ?? ""
            let lastName = filteredMentions[indexPath.row].lastName ?? ""
            let uuid = filteredMentions[indexPath.row].uuid ?? ""
            let isEducator = filteredMentions[indexPath.row].isEducator ?? 0
            var mentionType = ""
            if firstName == "channel" {
                mentionType = firstName
            } else if firstName == "here" {
                mentionType = firstName
            } else if isEducator == 1 {
                mentionType = "is_instructor"
            } else {
                mentionType = "is_member"
            }
            if lastName != "" {
                let fullName = "\(firstName) \(lastName)"
                sendMessageTextView.addMentionToTextView(name: "@\(String(describing: fullName))")
            } else {
                sendMessageTextView.addMentionToTextView(name: "@\(String(describing: firstName))")
            }
            sendMessageTextView.mentionQuery = ""
            sendMessageTextView.isMentioning = false
            sendMessageTextView.setDidSelectData(data: filteredMentions[indexPath.row])
            UIView.animate(withDuration: 0.2, animations: {
                self.mentionsTableView.isHidden = true
            })
        }
    }
}
