//
//  SendImagesCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/07/21.
//

import UIKit

protocol sendImagesCellProtocol: AnyObject {
    func sendInfo(index: Int)
}

class SendImagesCell: UICollectionViewCell {

    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var addImage: UIImageView!
    @IBOutlet private weak var crossImageButton: UIButton!
    weak var delegate: sendImagesCellProtocol?
    private var index: Int?
    override func awakeFromNib() {
        setupUI()
        super.awakeFromNib()
    }
    
    private func setupUI() {
        bgView.setCornerRadiusAndBorderToView(cornerRadius: 4, borderWidth: 0, borderColor: .clear)
        bgView.backgroundColor = AppColors.slate05
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
    }

    internal func configData(with image: UIImage, index: Int) {
        imageView.image = image
        self.index = index
    }
    
    @IBAction func crossButtonClicked(_ sender: Any) {
        if let index = index {
            delegate?.sendInfo(index: (index == 0) ? 0 : index)
        }
    }
    
    internal func hideAddImageView(hidden: Bool) {
        self.crossImageButton.isHidden = !hidden
        self.addImage.isHidden = hidden
        self.imageView.isHidden = !hidden
    }
}
