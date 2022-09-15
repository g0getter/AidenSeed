//
//  ResultCell.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/25.
//

import UIKit

class ResultCell: UITableViewCell {
    
    static let identifier = "ResultCell"
    
    var userInfo: UserInfo?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
    }

    var resultLabel = UILabel().then {
        $0.textColor = .black
//        $0.backgroundColor = .gray.withAlphaComponent(0.1)
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        resultLabel.textColor = .blue
    }
    
    /// UI만 세팅하고 내용물은 채우지 않음
    private func setUI() {
        resultLabel.do { label in
            contentView.addSubview(label)
            
            label.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(5)
                $0.leading.trailing.equalToSuperview().inset(10)
                $0.height.equalTo(35)
            }
        }
    }

}
