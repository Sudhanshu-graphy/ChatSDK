//
//  sendFilesCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 02/08/21.
//

import UIKit

protocol sendFilesCellProtocol: AnyObject {
    func sendFileInfo(index: Int)
}

class SendFilesCell: UICollectionViewCell {
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var crossImageButton: UIButton!
    @IBOutlet private weak var assetImage: UIImageView!
    @IBOutlet private weak var assetLabel: UILabel!
    weak var delegate: sendFilesCellProtocol?
    private var index: Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        bgView.setCornerRadiusAndBorderToView(cornerRadius: 4, borderWidth: 0, borderColor: .clear)
        bgView.backgroundColor = AppColors.slate05
        assetLabel.font = AppFont.fontOf(type: .Medium, size: 12)
        assetLabel.textColor = AppColors.slate02
    }
    
    internal func configData(with data: UploadfileData, index: Int) {
        self.index = index
        assetImage.image = data.fileType.icon
        assetLabel.text = data.fileName
    }
    
    @IBAction func crossButtonClicked(_ sender: Any) {
        if let index = index {
            delegate?.sendFileInfo(index: (index == 0) ? 0 : index)
        }
    }
}
