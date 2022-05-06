//
//  ImageSourceBottomSheet.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 27/07/21.
//

import UIKit
import PanModal

protocol ImageSourceBottomSheetProtocol: AnyObject {
    func sendInfo(fileType: PickerFileSource)
}

enum PickerFileSource: String {
    case gallery
    case camera
    case files
}

class ImageSourceBottomSheet: DeInitLoggerViewController {

    @IBOutlet private weak var takePhotoPlaceholder: UILabel!
    @IBOutlet private weak var galleryPlaceholder: UILabel!
    @IBOutlet private weak var cameraStackView: UIStackView!
    @IBOutlet private weak var galleryStackView: UIStackView!
    @IBOutlet private weak var filesStackView: UIStackView!
    @IBOutlet private weak var filesPlaceholder: UILabel!
    weak var delegate: ImageSourceBottomSheetProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTapGesture()
    }
    
    private func setupUI() {
        takePhotoPlaceholder.font = AppFont.fontOf(type: .Medium, size: 14)
        takePhotoPlaceholder.textColor = AppColors.slate02
        galleryPlaceholder.font = AppFont.fontOf(type: .Medium, size: 14)
        galleryPlaceholder.textColor = AppColors.slate02
        filesPlaceholder.font = AppFont.fontOf(type: .Medium, size: 14)
        filesPlaceholder.textColor = AppColors.slate02
    }
    
    private func addTapGesture() {
        let cameraTapGesture = UITapGestureRecognizer(target: self,
                                                      action: #selector(self.cameraTapAction))
        let galleryTapGesture = UITapGestureRecognizer(target: self,
                                                       action: #selector(self.galleryTapAction))
        let filesTapGesture = UITapGestureRecognizer(target: self,
                                                     action: #selector(self.filesTapAction))
        cameraStackView.addGestureRecognizer(cameraTapGesture)
        galleryStackView.addGestureRecognizer(galleryTapGesture)
        filesStackView.addGestureRecognizer(filesTapGesture)
    }

    
    @objc private func cameraTapAction() {
        self.dismiss(animated: true) {
            self.delegate?.sendInfo(fileType: .camera)
        }
    }
    
    @objc private func galleryTapAction() {
        self.dismiss(animated: true) {
            self.delegate?.sendInfo(fileType: .gallery)
        }
    }
    
    @objc private func filesTapAction() {
        self.dismiss(animated: true) {
            self.delegate?.sendInfo(fileType: .files)
        }
    }
}

extension ImageSourceBottomSheet: PanModalPresentable {
    
    var panScrollable:
        UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(150)
    }
    
    var springDamping: CGFloat {
        return 1.0
    }
    
    var transitionDuration: Double {
        return 0.5
    }
    
    var transitionAnimationOptions: UIView.AnimationOptions {
        return [.allowUserInteraction, .allowUserInteraction]
    }
    
    var shouldRoundTopCorners: Bool {
        return true
    }
    
    var showDragIndicator: Bool {
        return false
    }
    
    var allowsDragToDismiss: Bool {
        return true
    }
}
