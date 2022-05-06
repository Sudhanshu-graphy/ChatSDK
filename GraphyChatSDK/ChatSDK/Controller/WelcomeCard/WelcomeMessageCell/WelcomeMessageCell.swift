//
//  WelcomeMessageCell.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 22/09/21.
//

import UIKit

class WelcomeMessageCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var imageIcon: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    private var data = [WelcomeCardType]()
    private var type: ChannelType = .general
    
    // MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupTableView()
    }
    
    // MARK: - Setup
    private func setupUI() {
        imageIcon.setCornerRadiusAndBorder(cornerRadius: 4, borderWidth: Int(0.5), borderColor: .clear)
        titleLabel.textColor = AppColors.slate01
        titleLabel.font = AppFont.fontOf(type: .Regular, size: 14)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(UINib(nibName: "WelcomeCardCell", bundle: nil), forCellReuseIdentifier: "WelcomeCardCell")      
    }
    
    // MARK: - Data
    public func config(with data: [WelcomeCardType], type: ChannelType) {
        titleLabel.text = type.welcomeMessageTitle
        self.data = data
        self.type = type
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        tableViewHeight.constant = tableView.contentSize.height
    }
}


extension WelcomeMessageCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeCardCell", for: indexPath) as? WelcomeCardCell else {
            return UITableViewCell()
        }
        cell.configData(with: data[indexPath.item], channelType: type, backgroundColor: AppColors.slate05)
        cell.backgroundColor = AppColors.slate05
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
