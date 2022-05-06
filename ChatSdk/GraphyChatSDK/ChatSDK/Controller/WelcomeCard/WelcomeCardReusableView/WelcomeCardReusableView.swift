//
//  WelcomeCardReusableView.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 21/09/21.
//

import Foundation
import UIKit

final class WelcomeCardReusableView: UIView {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let nibName = "WelcomeCardReusableView"
    private var data = [WelcomeCardType]()
    private var channelType: ChannelType = .general
    
    // MARK: - View life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        setupTableView()
    }
    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(UINib(nibName: "WelcomeCardCell", bundle: nil), forCellReuseIdentifier: "WelcomeCardCell")
    }
    
    // MARK: - Data
    public func config(with data: [WelcomeCardType], channelType: ChannelType) {
        self.data = data
        self.channelType = channelType
        self.tableView.reloadData()
    }
}

extension WelcomeCardReusableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeCardCell") as? WelcomeCardCell else {
            return UITableViewCell()
        }
        cell.configData(with: data[indexPath.item], channelType: channelType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
