//
//  ChannelMessagesVC+CollectionVIew.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/07/21.
//

import Foundation
import UIKit

extension ChannelMessagesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addedFiles.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == addedFiles.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendImagesCell", for: indexPath) as? SendImagesCell else {
                return UICollectionViewCell()
            }
            cell.hideAddImageView(hidden: false)
            return cell
        } else if addedFiles[indexPath.row].fileType.rawValue.isImageType() {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendImagesCell", for: indexPath) as? SendImagesCell else {
                return UICollectionViewCell()
            }
            
            if let image = addedFiles[indexPath.row].image {
                cell.configData(with: image, index: indexPath.row)
            }
            cell.hideAddImageView(hidden: true)
            cell.delegate = self
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendFilesCell", for: indexPath) as? SendFilesCell else {
                return UICollectionViewCell()
            }
            cell.configData(with: addedFiles[indexPath.item], index: indexPath.item)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item != addedFiles.count && !addedFiles[indexPath.item].fileType.rawValue.isImageType() {
            return CGSize(width: 220, height: 55)
        }
        return CGSize(width: 55, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == addedFiles.count {
            let vc = ImageSourceBottomSheet()
            vc.delegate = self
            self.presentPanModal(vc)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
