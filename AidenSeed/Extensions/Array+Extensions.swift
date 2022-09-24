//
//  Array+Extensions.swift
//  AidenSeed
//
//  Created by 여나경 on 2022/09/24.
//

extension Array where Element: UserInfo {
    /// login(닉네임) 따라 정렬
    func sortedItems() -> [UserInfo] {
        return self.sorted { (a, b) in
            return a.login ?? "" < b.login ?? ""
        }
    }
}
