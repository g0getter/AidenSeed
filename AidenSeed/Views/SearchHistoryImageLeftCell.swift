//
//  SearchHistoryImageLeftCell.swift
//  AidenSeed
//
//  Created by Aiden on 2022/09/06.
//

import UIKit

class SearchHistoryImageLeftCell: UITableViewCell {

//    static let identifier = "searchHistoryImageLeftCell"
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.reuseIdentifier = "searchHistoryImageLeftCell"
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
