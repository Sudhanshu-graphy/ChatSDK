//
//  ChannelMemberVM.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 07/07/21.
//

import Foundation

class ChannelMemberVM {
    internal var member = [ChannelMembers]()
    internal var reloadTableView: (() -> Void)?
    internal var showError: ((String) -> Void)?
    internal var showLoading: (() -> Void)?
    internal var hideLoading: (() -> Void)?
    internal var totalMemberCount = 0
    internal func getData(offset: Int, entityExternalUUID: String) {
        showLoading?()
        ChannelsDetailsAPI.getMembersList(entityExternalUUID: entityExternalUUID, limit: 20, offset: offset) { [weak self] response in
            guard let self = self else { return }
            self.hideLoading?()
            if response.status == .success, let data = response.json, let channelData = data.results {
                self.totalMemberCount = data.count ?? 0
                for value in channelData {
                    let firstName = value.userDetails?.firstName ?? ""
                    let secondName = value.userDetails?.lastName ?? ""
                    let fullName = firstName + " " + secondName
                    if fullName != " " {
                        self.member.append(value)
                    }
                }
                self.reloadTableView?()
            } else {
                if let errorMessage = response.errorMsg {
                    self.showError?(errorMessage)
                }
            }
        }
    }
    
    internal var numberOfItem: Int {
        return self.member.count
    }
    
    internal func getCellViewModel(at indexPath: IndexPath) -> ChannelMembers {
        return member[indexPath.row]
    }
    
    internal func removeMembersData() {
        self.member.removeAll()
    }
}
