//
//  ChatMessagesTextCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 09/07/21.
//

import UIKit

class ImagePopUpController: DeInitLoggerViewController {
    
    @IBOutlet private weak var sliderView: SliderView!
    internal var index = 0
    private var imagesData = [String]()
    var assetData = [Asset]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    private func setupUI() {
        sliderView.index = index
    }
    
    
    private func setupData() {
        for value in assetData {
            if let url = value.url {
                imagesData.append(url)
            }
        }        
        sliderView.list = imagesData
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
}
