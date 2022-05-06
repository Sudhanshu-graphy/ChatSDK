//
//  PrefilledMessageBottomSheet.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/09/21.
//

import UIKit
import PanModal

protocol PrefilledMessageBottomSheetProtocol:AnyObject {
    func sendMessageData(with data: String)
}

final class PrefilledMessageBottomSheet: DeInitLoggerViewController {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var startConversationLabel: UILabel!
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    public var messageData = [String]()
    public weak var delegate: PrefilledMessageBottomSheetProtocol?
    private var panmodalHeight = CGFloat(100)

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupData()
    }
    
    override func viewDidLayoutSubviews() {
        tableViewHeight.constant = tableView.contentSize.height
        panmodalHeight = tableViewHeight.constant + CGFloat(60)
        if panmodalHeight > 600 {
            panmodalHeight = 600
            tableViewHeight.constant = 480
        }
        panModalSetNeedsLayoutUpdate()
        panModalTransition(to: .longForm)
    }
    
    // MARK: - Setup
    private func setupUI() {
        startConversationLabel.font = AppFont.fontOf(type: .Bold, size: 16)
        startConversationLabel.textColor = .black
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "PrefilledMessageBottomSheetCell", bundle: nil), forCellReuseIdentifier: "PrefilledMessageBottomSheetCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    // MARK: - Data
    private func setupData() {
        tableView.reloadData()
    }
}

extension PrefilledMessageBottomSheet: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PrefilledMessageBottomSheetCell", for: indexPath) as? PrefilledMessageBottomSheetCell else {
            return UITableViewCell()
        }
        cell.config(with: messageData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.sendMessageData(with: self.messageData[indexPath.row])
        }
    }
}

extension PrefilledMessageBottomSheet: PanModalPresentable {
    
    var panScrollable:
        UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(panmodalHeight)
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
