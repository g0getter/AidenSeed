//
//  SearchHistoryImageRightCell.swift
//  AidenSeed
//
//  Created by Aiden on 2022/09/06.
//

import UIKit

class SearchHistoryImageRightCell: UITableViewCell, SearchHistoryImageCell {

    static let identifier = "searchHistoryImageRightCell"
    
    var userInfo: UserInfo?
    
    /// Username
    @IBOutlet weak var userNameLabel: UILabel!
    
    /// User ImageView
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .orange.withAlphaComponent(0.2)
        // ReuseIdentifier, XIB의 identifier 지정하지 않아도 잘 register 됨.
//        self.reuseIdentifier = SearchHistoryImageRightCell.identifier
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
