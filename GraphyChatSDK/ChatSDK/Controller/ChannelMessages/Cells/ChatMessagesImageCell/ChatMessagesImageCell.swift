//
//  ChatMessagesImageCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 09/07/21.
//

import UIKit

final class ChatMessagesImageCell: UICollectionViewCell {

    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var assetIcon: UIImageView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var asssetTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        imageView.backgroundColor =  AppColors.slate05
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        asssetTitle.font = AppFont.fontOf(type: .SemiBold, size: 14)
        asssetTitle.textColor = AppColors.slate02
        cellView.setCornerRadiusAndBorderToView(cornerRadius: 4, borderWidth: 0, borderColor: .clear)
        cellView.backgroundColor = AppColors.slate05
    }
    
    internal func config(with data: Asset) {
        if data.url?.fileExtension() == "svg" {
            asssetTitle.text = data.title
            assetIcon.image = data.type?.icon
            showAssetView(show: true)
        } else if data.type?.rawValue.isImageType() ?? false {
            if let urlString = data.url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                let picUrl = URL(string: urlString)
//                imageView.sd_setImage(with: picUrl, completed: nil)
            }
            showAssetView(show: false)
        } else {
            asssetTitle.text = data.title
            assetIcon.image = data.type?.icon
            showAssetView(show: true)
        }
    }
    
    private func showAssetView(show: Bool = false) {
        if show {
            assetIcon.isHidden = false
            asssetTitle.isHidden = false
            imageView.isHidden = true
        } else {
            assetIcon.isHidden = true
            asssetTitle.isHidden = true
            imageView.isHidden = false
        }
    }
}
