//
//  ChannelDetailsVC+TableView.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/06/21.
//

import Foundation
import UIKit

enum SegmentType: Int {
    case member = 0
    case files = 1
}

extension ChannelDetailsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let type = SegmentType(rawValue: segmentControl.selectedSegmentIndex)
        
        switch type {
        case .member:
            if channelMemberVM.numberOfItem > 0 {
                self.hideEmptyState()
                return channelMemberVM.numberOfItem
            } else {
                self.showEmptyState()
                return 0
            }
        case .files:
            if channelRecentFilesVM.numberOfItem > 0 {
                return channelRecentFilesVM.numberOfItem
            } else {
                self.showEmptyState()
                return 0
            }

        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = SegmentType(rawValue: segmentControl.selectedSegmentIndex)
        switch type {
        case .member:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelDetailMemberCell", for: indexPath) as? ChannelDetailMemberCell else {
                return UITableViewCell()
            }
            
            cell.config(with: channelMemberVM.getCellViewModel(at: indexPath))
            return cell
            
        case .files:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelDetailFilesCell", for: indexPath) as? ChannelDetailFilesCell else {
                return UITableViewCell()
            }
            
            cell.config(with: channelRecentFilesVM.getCellViewModel(at: indexPath))
            return cell
        default:
            break
        }
    
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = SegmentType(rawValue: segmentControl.selectedSegmentIndex)
        
        switch type {
        case .member:
            return 60
        case .files:
            return 70
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = SegmentType(rawValue: segmentControl.selectedSegmentIndex)
        
        switch type {
        
        case .member:
//            let vc = ProfileBottomSheetVC()
//            let firstName = channelMemberVM.getCellViewModel(at: indexPath).userDetails?.firstName ?? ""
//            let secondName = channelMemberVM.getCellViewModel(at: indexPath).userDetails?.lastName ?? ""
//            let fullName = firstName + " " + secondName
//            vc.name = fullName
//            vc.profilePicUrl =  channelMemberVM.getCellViewModel(at: indexPath).userDetails?.avatar
//            self.presentPanModal(vc)
            
            let username = channelMemberVM.getCellViewModel(at: indexPath).userDetails?.profileUsername ?? ""
//            ProfileNavigator.openProfileCard(username: username)
//            guard let profile = R.storyboard.profileCard().instantiateInitialViewController() as? ProfileCardViewController else { return }
//            profile.profileCardViewModel = ProfileCardViewModel(username: username)
//            presentPanModal(profile)
            
        case .files:
            
            if channelRecentFilesVM.getCellViewModel(at: indexPath).type?.rawValue.isImageType() ?? false &&
                channelRecentFilesVM.getCellViewModel(at: indexPath).url?.fileExtension() != "svg"{
                var data = [Asset]()
                if let imageUrl = channelRecentFilesVM.getCellViewModel(at: indexPath).url {
                    let storyBoard = UIStoryboard(name: "ImagePopUpController", bundle: nil)
                    guard let vc = storyBoard.instantiateViewController(withIdentifier: "ImagePopUpController") as? ImagePopUpController else { return }
                    data.append(Asset(uuid: "", type: .Image, url: imageUrl, size: 0, createdAt: "", title: ""))
                    vc.index = 0
                    vc.assetData = data
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                if let url  = channelRecentFilesVM.getCellViewModel(at: indexPath).url {
                    openLink(url: url)
                }
            }

        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if segmentControl.selectedSegmentIndex == 0 {
            if totalMemberCount > channelMemberVM.numberOfItem && indexPath.row == channelMemberVM.numberOfItem - 1 {
                channelMemberVM.getData(offset: offset + 20, entityExternalUUID: entityUUID)
            }
        }
    }
}
