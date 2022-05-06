//
//  ChannelRecentFilesVM.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 07/07/21.
//

import Foundation

class ChannelRecentFilesVM {
    internal var filesList = [FilesData]()
    internal var reloadTableView: (() -> Void)?
    internal var showError: (() -> Void)?
    internal var showLoading: (() -> Void)?
    internal var hideLoading: (() -> Void)?
    
    internal func getData(channelUUID: String) {
        showLoading?()
        ChannelsDetailsAPI.getRecentFiles(channelUUID: channelUUID) { response in
            self.hideLoading?()
            if response.status == .success, let data = response.json, let fileData = data.results {
                for value in fileData {
                    self.filesList.append(value)
                }
                self.reloadTableView?()
            } else {
                self.showError?()
            }
        }
    }
    
    internal var numberOfItem: Int {
        return self.filesList.count
    }
    
    internal func getCellViewModel(at indexPath: IndexPath) -> FilesData {
        return filesList[indexPath.row]
    }
}
