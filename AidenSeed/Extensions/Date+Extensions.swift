//
//  Date+Extensions.swift
//  AidenSeed
//
//  Created by Aiden on 2022/09/01.
//

import Foundation

extension Date {
    /// 2022.09.01 -> 2022-09-01
    func toString() -> String {
        let formatter = DateFormatter().then {
            $0.locale = Locale(identifier: "ko_KR")
        }
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
