//
//  SearchHistoryImageLeftCell.swift
//  AidenSeed
//
//  Created by Aiden on 2022/09/06.
//

import UIKit

class SearchHistoryImageLeftCell: UITableViewCell, SearchHistoryImageCell {

    static let identifier = "searchHistoryImageLeftCell"
    
    var userInfo: UserInfo?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = .yellow.withAlphaComponent(0.2)
        self.backgroundColor = .clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
