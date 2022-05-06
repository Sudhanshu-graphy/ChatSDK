//
//  ChannelDetail.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 29/06/21.
//

import Foundation

class ChannelDetailVM {
    
    internal var channelDetail : ChannelDetails?
    internal var showError: ((String) -> Void)?
    internal var configureData: (() -> Void)?
    
    internal var channelName: String {
        let channelName = channelDetail?.title ?? ""
        return "#\(channelName)"
    }
    
    internal var totalMessagesCount: Int {
        return channelDetail?.totalMessageCount ?? 0
    }
    
    internal var channeldescription: String {
        return channelDetail?.channelDetailsDescription ?? ""
    }
    
    internal var totalMember: Int {
        return channelDetail?.totalMembers ?? 0
    }
    
    internal var channelUUID: String {
        return channelDetail?.uuid ?? ""
    }
    
    internal var channelCreatedAt: String {
        return channelDetail?.createdAt?.channelCreatedDate() ?? ""
    }
    
    internal var entityUUID: String {
        return channelDetail?.entityExternalUUID ?? ""
    }
    
    
    internal func getData(channelSlug: String, entityUUID: String) {
        ChannelsDetailsAPI.getChannelDetails(workspaceSubDomain: LocalData.savedSchools?.first?.subdomain ?? "", entityUUID:  entityUUID, channelSlug: channelSlug) { [weak self] response in
            guard let self = self else { return }
            if response.status == .success, let data = response.json {
                self.channelDetail = data
                self.configureData?()
            } else {
                if let errorMessage = response.errorMsg {
                    self.showError?(errorMessage)
                }
            }
        }
    }
}
