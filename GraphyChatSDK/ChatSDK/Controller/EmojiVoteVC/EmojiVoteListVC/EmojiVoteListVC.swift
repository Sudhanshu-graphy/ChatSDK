//
//  EmojVoteListVC.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 12/07/21.
//

import UIKit
import PanModal
import emojidataios

class EmojiVoteListVC: DeInitLoggerViewController {
    @IBOutlet weak var tableView: UITableView!
    internal var memberData = [Reaction]()
    internal var showAllEmojiList = false
    internal var emojiVM: MessageEmojiVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    private func setupTableView() {
        let cellNib = UINib(nibName: "EmojiAllVoteListCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "EmojiAllVoteListCell")
        tableView.register(UINib(nibName: "ChannelDetailMemberCell",
                                 bundle: nil), forCellReuseIdentifier: "ChannelDetailMemberCell")
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
}


extension EmojiVoteListVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return showAllEmojiList ? emojiVM.numberOfItems : memberData.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if showAllEmojiList {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiAllVoteListCell", for: indexPath) as? EmojiAllVoteListCell else {
                return UITableViewCell()
            }
            let name = emojiVM.getAllUsername(at: indexPath)
            let emoji = emojiVM.getCellViewModel(at: indexPath)
            let emojiText = EmojiParser.parseAliases(emoji.first?.emojiName ?? "")
            cell.config(with: name, emojiText: emojiText)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelDetailMemberCell", for: indexPath) as? ChannelDetailMemberCell else {
                return UITableViewCell()
            }
            cell.configFromEmoji(with: memberData[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return showAllEmojiList ? UITableView.automaticDimension : 70
    }
}
