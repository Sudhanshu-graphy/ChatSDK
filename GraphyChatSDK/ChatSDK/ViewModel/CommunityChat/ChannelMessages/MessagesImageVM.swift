//
//  ChannelImageVM.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 09/07/21.
//

import Foundation

class MessagesImageVM {
    
    private var imageData = [Asset]()
    
    init(data: [Asset]) {
        self.setData(data: data)
    }
    
    private func setData(data: [Asset]) {
        for value in data {
            self.imageData.append(value)
        }
        imageData = imageData.sorted(by: { ($0.type?.rawValue ?? "") < ($1.type?.rawValue ?? "")})
    }
    
    internal var numberOfAssets: Int {
        return imageData.count
    }
    
    internal func getCellViewModel(at indexPath: IndexPath) -> Asset {
        return imageData[indexPath.item]
    }
    
    internal var data: [Asset] {
        return imageData
    }
    
    internal var numberOfItems: Int {
        return numberOfAssets
    }
    
    internal func isImageType(at indexPath: IndexPath) -> Bool {
        return imageData[indexPath.item].type?.rawValue.isImageType() ?? false
    }
    
    internal func isSvgType(at indexPath: IndexPath) -> Bool {
        return imageData[indexPath.item].url?.fileExtension() == "svg"
    }
}
