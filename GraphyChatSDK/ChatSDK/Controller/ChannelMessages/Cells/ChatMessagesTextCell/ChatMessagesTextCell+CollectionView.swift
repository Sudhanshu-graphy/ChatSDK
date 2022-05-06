//
//  ChatMessagesTextCell+CollectionView.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 23/06/21.
//

import Foundation
import UIKit

extension ChatMessagesTextCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.emojiCollectionView :
            return (emojiVM?.numberOfItems ?? 0) + 1
        case self.imageCollectionView:
            return (imageVM?.numberOfItems ?? 0)
        case self.actionableCollectionView:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        
        case self.emojiCollectionView :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatMessagesEmojiCell", for: indexPath) as? ChatMessagesEmojiCell else {
                return UICollectionViewCell()
            }
            
            if indexPath.item != (emojiVM?.numberOfItems ?? 0) {
                if let vm = emojiVM?.getCellViewModel(at: indexPath) {
                    cell.configure(with: vm)
                }
            }
            cell.isToShowAddEmoji(isToshow: emojiVM?.isToShowAddEmoji(at: indexPath) ?? false)
            return cell
        
        case self.imageCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatMessagesImageCell", for: indexPath) as? ChatMessagesImageCell else {
                return UICollectionViewCell()
            }
            if let data = imageVM?.getCellViewModel(at: indexPath) {
                cell.config(with: data)
            }
            return cell
    
        case self.actionableCollectionView:
            guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageUpcomingSessionCell", for: indexPath) as? MessageUpcomingSessionCell else {
                return UICollectionViewCell()
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        
        case self.emojiCollectionView :
            return CGSize(width: 38, height: 24)
        case self.imageCollectionView:
            var height = 60.0
            if (imageVM?.isSvgType(at: indexPath)) == true {
                height = 60.0
            } else if (imageVM?.isImageType(at: indexPath)) == true {
                height = 150.0
            }
            let cellSize = CGSize(width: collectionView.bounds.width -
                                    10, height: CGFloat(height))
            return cellSize
        case self.actionableCollectionView:
            let height = 160
            return CGSize(width: UIScreen.screenWidth - 80, height: CGFloat(height))
        default:
            return CGSize(width: collectionView.bounds.width -
                          10, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.emojiCollectionView :
            hapticGenerator.impactOccurred(intensity: 6)
            if indexPath.item == (emojiVM?.numberOfItems ?? 0) {
                delegate?.sendData(messageUUID: self.messageUUID ?? "")
            } else {
                let emojiData = emojiVM?.getCellViewModel(at: indexPath)
                emojiVM?.sendEmoji(emojiName: emojiData?.first?.emojiName ?? "", messageUUID: messageUUID ?? "", unicode: emojiData?.first?.unicode ?? "")
            }
        case self.imageCollectionView:
            if let data = imageVM?.data {
                delegate?.openImagePopUp(data: data, index: indexPath.item, messageUUID: messageUUID ?? "")
            }
        default:
            break
      }
    }
  }
