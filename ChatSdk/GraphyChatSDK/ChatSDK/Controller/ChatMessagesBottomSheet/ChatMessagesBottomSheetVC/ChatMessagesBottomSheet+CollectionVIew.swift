//
//  ChatMessagesBottomSheet+CollectionVIew.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 25/06/21.
//

import Foundation
import UIKit

extension ChatMessagesBottomSheet:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiVM.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomSheetEmojiCell", for: indexPath) as? BottomSheetEmojiCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: emojiVM.getCellViewModel(at: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == emojiVM.numberOfItems - 1 {
            weak var presentingVC = self.presentingViewController
            self.dismiss(animated: true, completion: {
                let vc = EmojiViewController()
                vc.messageUUID = self.messageUUID ?? ""
                vc.entityUUID = self.entityUUID
                vc.channelName = self.channelName
                vc.courseName = self.courseName
                vc.channelSlug = self.channelSlug
                vc.channelUUID = self.channelUUID
                vc.parentMessageUUID = self.parentMessageUUID
                vc.analyticsChannelType = self.analyticsChannelType
                presentingVC?.presentPanModal(vc)
            })
        } else {
            let emoji = emojiVM.getCellViewModel(at: indexPath).emoji
            emojiVM.sendEmoji(emojiName: emoji?.getEmojiShortName() ?? "", messageUUID: messageUUID ?? "", unicode: emoji?.getEmojiUnicode() ?? "")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
