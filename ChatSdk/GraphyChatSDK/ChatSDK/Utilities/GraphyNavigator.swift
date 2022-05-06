//
//  GraphyNavigator.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 25/08/21.
//

import Foundation
import SafariServices
import UniformTypeIdentifiers
import MobileCoreServices
import UIKit

enum GraphyNavigator {
    
    static var window: UIWindow? {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
    
    static func resetWindow(with vc: UIViewController?) {
        window?.rootViewController = vc
    }
    
    static func playInYoutube(youtubeId: String) {
        if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
           UIApplication.shared.canOpenURL(youtubeURL) {
            // redirect to app
            UIApplication.shared.open(youtubeURL)
        } else if let youtubeURL = URL(
            string: "https://www.youtube.com/watch?v=\(youtubeId)") {
            // redirect through safari
            UIApplication.shared.open(youtubeURL)
        }
    }
    
    static func openResource(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            // not a valid URL
            return
        }

        if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
            // Can open with SFSafariViewController
            let safariViewController = SFSafariViewController(url: url)
            UIApplication.topViewController()?.present(safariViewController, animated: true, completion: nil)
        } else {
            let appendedUrlString = "https://\(urlString)"
            guard let url = URL(string: appendedUrlString) else { return }
            let safariViewController = SFSafariViewController(url: url)
            UIApplication.topViewController()?.present(safariViewController, animated: true, completion: nil)
        }
    }
    
    static func openImageController(data: [Asset], index: Int) {
        let storyBoard = UIStoryboard(name: "ImagePopUpController",
                                      bundle: nil)
        guard let vc = storyBoard.instantiateViewController(
            withIdentifier: "ImagePopUpController") as?
                ImagePopUpController else { return }
        
        vc.assetData  = data
        vc.index = index
        vc.modalPresentationStyle = .overFullScreen
        UIApplication.topViewController()?.present(vc,
                                                   animated: true,
                                                   completion: nil)
    }
}



// MARK: Channels
extension GraphyNavigator {
    static func showChannelList(courseSlug: String,
                                courseEmoji: String,
                                courseTitle: String,
                                courseUUID: String) {
        
        let data = FeedResult(title: courseTitle, uuid: courseUUID, slug: courseSlug,
                              emojiUnicode: courseEmoji)
//        setCourseRoot(data: data, type: .channel)
    }
}

// DocumentPicker
extension GraphyNavigator {
    static func openFilePicker(viewController: UIViewController) {
        if #available(iOS 14.0, *) {
            let supportedTypes = [UTType.png, UTType.plainText, UTType.utf8PlainText, UTType.utf16ExternalPlainText, UTType.utf16PlainText, UTType.delimitedText, UTType.commaSeparatedText, UTType.tabSeparatedText, UTType.utf8TabSeparatedText, UTType.rtf, UTType.pdf, UTType.webArchive, UTType.image, UTType.jpeg, UTType.tiff, UTType.gif, UTType.mpeg2TransportStream, UTType.aiff, UTType.wav, UTType.midi, UTType.archive, UTType.gzip, UTType.bz2, UTType.zip, UTType.appleArchive, UTType.spreadsheet, UTType.mp3, UTType.wav, UTType.mpeg, UTType.mpeg4Audio
            ]
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
            documentPicker.delegate = viewController as? UIDocumentPickerDelegate
            documentPicker.allowsMultipleSelection = false
            documentPicker.shouldShowFileExtensions = true
            viewController.present(documentPicker, animated: true, completion: nil)
        } else {
            let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText), String(kUTTypeContent), String(kUTTypeItem), String(kUTTypeData), String(kUTTypeJPEG), String(kUTTypeTIFF), String(kUTTypePNG), String(kUTTypePDF), String(kUTTypeMP3), String(kUTTypeWaveformAudio), String(kUTTypeMPEG), String(kUTTypeMPEG2Video), String(kUTTypeZipArchive), String(kUTTypeGIF), String(kUTTypeSpreadsheet), String(kUTTypeJPEG)], in: .import)
            documentPicker.delegate = viewController as? UIDocumentPickerDelegate
            documentPicker.allowsMultipleSelection = false
            documentPicker.shouldShowFileExtensions = true
            viewController.present(documentPicker, animated: true, completion: nil)
        }
    }
}


// Community
extension GraphyNavigator {
    static func presentPrefilledBottomSheet(viewController: UIViewController, data: [String]) {
        let vc = PrefilledMessageBottomSheet()
        vc.messageData = data
        vc.delegate = viewController as? PrefilledMessageBottomSheetProtocol
        UIApplication.topViewController()?.presentPanModal(vc)
    }
    
    static func openPDFController(assetTitle: String, assetUrl: String) {
        let vc = PDFViewController()
        vc.assetUrl = assetUrl
        vc.assetTitle = assetTitle
        vc.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(vc,
                                                   animated: true,
                                                   completion: nil)
    }
}

// Select Community
extension GraphyNavigator {
    static func showSelectAtLeastOneCommunityPopUp() {
        let alertController = UIAlertController(title: "", message: "Atleast one community must be selected", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
}

