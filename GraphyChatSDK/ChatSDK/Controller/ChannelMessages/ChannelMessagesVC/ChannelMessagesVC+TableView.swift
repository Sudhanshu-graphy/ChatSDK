//
//  ChannelMessagesVC+TableView.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/06/21.
//

import Foundation
import UIKit

extension ChannelMessagesVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == mentionsTableView {
            return 1
        } else {
            return messagesVM.totalSections
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == mentionsTableView {
            return nil
        } else {
            if let headerView = self.messagesTableView.dequeueReusableHeaderFooterView(withIdentifier: "MessagesTableHeaderView") as? MessagesTableHeaderView {
                headerView.transform = CGAffineTransform(scaleX: 1, y: -1)
                let firstMessages = messagesVM.getSectionViewModel(at: section).first
                headerView.dateLabel.text = firstMessages?.createdAt?.sectionMessagesDate()
                return headerView
            }
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == mentionsTableView {
            return 0
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mentionsTableView {
            return filteredMentions.count
        } else {
            return messagesVM.numberOfRows(at: section)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Mentions TableView
        if tableView == mentionsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MentionsCell", for: indexPath) as? MentionsCell
            else {
                return UITableViewCell()
            }
            cell.configData(with: filteredMentions[indexPath.row])
            return cell
            
        } else {
            if tableView.hasRowAtIndexPath(indexPath: indexPath) {
                if messagesVM.showWelcomeMessage(indexPath: indexPath, channelType: self.channelType) {
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeMessageCell", for: indexPath) as? WelcomeMessageCell else {
                        return UITableViewCell()
                    }
                    if let type = ChannelType(rawValue: channelSlug) {
                        cell.config(with: type.welcomeMessageCellArray, type: type)
                    }
                    cell.backgroundColor = AppColors.slate02
                    cell.transform =  CGAffineTransform(scaleX: 1, y: -1)
                    return cell
                } else if messagesVM.showOpenChannelWelcomeMessage(indexPath: indexPath, channelType: self.channelType) {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpenChannelWelcomeCell", for: indexPath) as? OpenChannelWelcomeCell else {
                        return UITableViewCell()
                    }
                    cell.config(with: self.channelName)
                    cell.delegate = self
                    cell.backgroundColor = AppColors.slate02
                    cell.transform =  CGAffineTransform(scaleX: 1, y: -1)
                    return cell
                } else {
                    guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: "ChatMessagesTextCell", for: indexPath) as? ChatMessagesTextCell else {
                        return UITableViewCell()
                    }
                    
                    cell.transform =  CGAffineTransform(scaleX: 1, y: -1)
                    cell.configure(with: messagesVM.getCellViewModel(at: indexPath))
                    cell.delegate = self
                    return cell
                }
            }
        }
        
        return UITableViewCell()
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
            
        } else if messagesVM.showWelcomeMessage(indexPath: indexPath, channelType: self.channelType) {
            return
        } else if messagesVM.showOpenChannelWelcomeMessage(indexPath: indexPath, channelType: self.channelType) {
            return 
        } else {
            let messageData = messagesVM.getCellViewModel(at: indexPath)
            let vc = MessageThreadsVC()
            vc.channelName = self.channelName
            vc.messageData = messageData
            vc.channelUUID = messagesVM.channelUUID
            vc.entityUUID = self.messagesVM.entityUUID
            vc.courseName = courseName
            vc.channelSlug = channelSlug
            vc.communityType = communityType
            vc.analyticsChannelType = analyticsChannelType
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView != mentionsTableView {
            if indexPath.section == (messagesVM.totalSections - 1) && !messagesVM.allMessagesDisplayed && (indexPath.item == messagesVM.numberOfRows(at: indexPath.section) - 1) {
                lastMessageDate = messagesVM.getCellViewModel(at: indexPath).createdAt ?? ""
                let mostRecentDate = messagesVM.getCellViewModel(at: IndexPath(row: 0, section: 0)).createdAt ?? ""
                messagesVM.getData(offsetDate: lastMessageDate, entityUUID: self.messagesVM.entityUUID, channelUUID: messagesVM.channelUUID, type: self.channelType, communityType: self.communityType)
            }
        }
    }
}
