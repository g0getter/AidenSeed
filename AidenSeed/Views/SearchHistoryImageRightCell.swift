//
//  SearchHistoryImageRightCell.swift
//  AidenSeed
//
//  Created by Aiden on 2022/09/06.
//

import UIKit

class SearchHistoryImageRightCell: UITableViewCell {

    /// Username
    @IBOutlet weak var userNameLabel: UILabel!
    
    /// User ImageView
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
