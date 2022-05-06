//
//  DeleteMessageBottomSheet.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 26/10/21.
//

import UIKit
import PanModal

protocol DeleteMessageBottomSheetDelegate: AnyObject {
    func deleteMessage(indexPath: IndexPath)
}

class DeleteMessageBottomSheet: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var deleteMessagePlaceholderLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    // MARK: - Properties
    public var messageData: ChannelMessagesData?
    public var messageVM: MessageVM?
    public var channelId: String = ""
    private var panmodalHeight = CGFloat(100)
    public weak var delegate: DeleteMessageBottomSheetDelegate?
    public var indexPath: IndexPath!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupMessageVM()
    }
    
    override func viewDidLayoutSubviews() {
        tableViewHeight.constant = tableView.contentSize.height - 10
        panmodalHeight = tableViewHeight.constant + CGFloat(200)
        if panmodalHeight > 650 {
            panmodalHeight = 650
            tableViewHeight.constant = 450
        }
        panModalSetNeedsLayoutUpdate()
        panModalTransition(to: .longForm)
    }
    
    // MARK: - Setup
    private func setupUI() {
        deleteMessagePlaceholderLabel.textColor = AppColors.slate01
        deleteMessagePlaceholderLabel.font = AppFont.fontOf(type: .SemiBold, size: 14)
        deleteButton.titleLabel?.font = AppFont.fontOf(type: .Bold, size: 14)
        deleteButton.setTitleColors(with: AppColors.slate05)
        deleteButton.setCornerRadiusAndBorderToView(cornerRadius: 4, borderWidth: 0, borderColor: .clear, withMask: true)
        cancelButton.titleLabel?.font = AppFont.fontOf(type: .SemiBold, size: 14)
        cancelButton.setCornerRadiusAndBorderToView(cornerRadius: 4, borderWidth: 0.5, borderColor: UIColor.init(0x4A4A4A), withMask: true)
        cancelButton.setTitleColors(with: AppColors.slate01)
    }
    
    private func setupTableView() {
        let cellNib = UINib(nibName: "ChatMessagesTextCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ChatMessagesTextCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
    }
    
    // MARK: - Data
    private func setupMessageVM() {
        guard let data = messageData else { return}
        messageVM = MessageVM(data: data, channelUUID: self.channelId)
        self.tableView.reloadData()
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.tableView.reloadData()
    }
    
    // MARK: - Action
    @IBAction func deleteButtonAction(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.deleteMessage(indexPath: self.indexPath)
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    // MARK: - Helper
}

extension DeleteMessageBottomSheet:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessagesTextCell", for: indexPath) as? ChatMessagesTextCell else {
            return UITableViewCell()
        }
        
        guard let dataVM = messageVM else { return UITableViewCell()}
        cell.configure(with: dataVM.getCellViewModel(at: indexPath))
        cell.showRepliesSection(isHidden: true)
        cell.showSeperatorView(isHidden: true)
        cell.showEmojiSection(isHidden: true)
        cell.setBackgroundColor(color: AppColors.slate05)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension DeleteMessageBottomSheet: PanModalPresentable {
    
    var showDragIndicator: Bool {
        return false
    }
    
    var springDamping: CGFloat {
        return 1.0
    }
    
    var transitionDuration: Double {
        return 0.5
    }
    
    var panScrollable: UIScrollView? {
        return tableView
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(panmodalHeight)
    }
    
    var shouldRoundTopCorners: Bool {
        return true
    }
}
