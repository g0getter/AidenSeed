//
//  SearchHistoryImageCell.swift
//  AidenSeed
//
//  Created by Aiden on 2022/09/13.
//

import UIKit

// TODO: 프로토콜만 UITableViewCell 채택
protocol SearchHistoryImageCell: UITableViewCell {
    var userInfo: UserInfo? { get set }
    
    var userNameLabel: UILabel! { get }
    var userImageView: UIImageView! { get }
}
