//
//  PDFViewController.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 01/09/21.
//

import UIKit
import PDFKit

class PDFViewController: DeInitLoggerViewController {

    // MARK: - Outlets
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var navItem: UINavigationItem!
    @IBOutlet private weak var pdfView: UIView!
    
    // MARK: - Properties
    private var backButtonItem: UIBarButtonItem {
        let backButton = UIBarButtonItem(image: AppAssets.crossIcon,
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.backButtonAction))
        backButton.tintColor = AppColors.slate02
        return backButton
    }
    
    public var assetUrl = ""
    public var assetTitle = ""
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupPDFView()
    }
    
    // MARK: - Setup
    private func setupPDFView() {

        let pdfView = PDFView(frame: self.pdfView.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.pdfView.addSubview(pdfView)
        
        pdfView.autoScales = true
        
        if let url = URL(string: assetUrl) {
            pdfView.document = PDFDocument(url: url)
        }
    }
    
    private func setupNavBar() {
        navigationBar.barTintColor = .white
        let navTitle = UILabel()
        navTitle.text = assetTitle
        navTitle.font = AppFont.fontOf(type: .Medium, size: 14)
        navTitle.sizeToFit()
        let titleItem = UIBarButtonItem(customView: navTitle)
        navItem.leftBarButtonItems = [backButtonItem, titleItem]
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: - Action
    @objc private func backButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
