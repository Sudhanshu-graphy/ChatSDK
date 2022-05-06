//
//  ChannelDetailFilesCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/06/21.
//

import UIKit

final class ChannelDetailFilesCell: UITableViewCell {
    
    @IBOutlet private weak var fileTypeIcon: UIImageView!
    @IBOutlet private weak var fileImage: UIImageView!
    @IBOutlet private weak var fileNameLabel: UILabel!
    @IBOutlet private weak var fileDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK:UI
    private func setupUI() {
        fileTypeIcon.backgroundColor =  AppColors.slate05
        fileTypeIcon.layer.cornerRadius = 4
        fileTypeIcon.clipsToBounds = true
        fileImage.backgroundColor =  AppColors.slate05
        fileImage.layer.cornerRadius = 4
        fileImage.clipsToBounds = true
        fileNameLabel.font = AppFont.fontOf(type: .Medium, size: 14)
        fileNameLabel.textColor = AppColors.slate01
        fileDateLabel.font = AppFont.fontOf(type: .Medium, size: 12)
        fileDateLabel.textColor = AppColors.slate03
        fileTypeIcon.isHidden = true
    }
    
    internal func config(with data: FilesData) {
        if data.url?.fileExtension() == "svg" {
            fileTypeIcon.image = data.type?.icon
            fileTypeIcon.isHidden = false
            fileImage.image = nil
        } else if data.type?.rawValue.isImageType() ?? false {
            if let urlString = data.url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                let picUrl = URL(string: urlString)
                fileImage.sd_setImage(with: picUrl, placeholderImage: nil)
                fileTypeIcon.isHidden = true
            }
        } else {
            fileTypeIcon.image = data.type?.icon
            fileTypeIcon.isHidden = false
            fileImage.image = nil
        }
        fileNameLabel.text = data.title
        fileDateLabel.text = data.createdAt?.toStreamingTimeAndDate() ?? ""
    }
}
