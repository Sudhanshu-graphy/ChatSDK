//
//  ImagePicker.swift
//  GraphyApp-iOS
//
//  Created by Rahul Kumar on 26/08/20.
//  Copyright © 2020 graphy. All rights reserved.
//

import Foundation
import UIKit

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?, imageUrl: String)
}

final class UIKitImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
        self.pickerController.sourceType = .photoLibrary
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present() {

//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        if let action = self.action(for: .camera, title: "Take photo") {
//            alertController.addAction(action)
//        }
//        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
//            alertController.addAction(action)
//        }
//        if let action = self.action(for: .photoLibrary, title: "Photo library") {
//            alertController.addAction(action)
//        }
//
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            alertController.popoverPresentationController?.sourceView = sourceView
//            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
//            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
//        }
//
//        self.presentationController?.present(alertController, animated: true)
        
        self.presentationController?.present(self.pickerController, animated: true)
        self.presentationController?.modalPresentationStyle = .fullScreen
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?, imageUrl: String) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image, imageUrl: imageUrl)
    }
}

extension UIKitImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil, imageUrl: "")
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var urlString = ""
        if let assetPath = info[.imageURL] as? URL {
            urlString = assetPath.absoluteString.lowercased()
        }
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil, imageUrl: urlString)
        }
        self.pickerController(picker, didSelect: image, imageUrl: urlString)
    }
}
