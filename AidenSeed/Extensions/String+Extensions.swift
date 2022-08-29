//
//  String+Extensions.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/29.
//

import Foundation

extension String {
    var url: URL? {
        return URL(string: self)
    }
}
