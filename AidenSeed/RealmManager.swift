//
//  RealmManager.swift
//  AidenSeed
//
//  Created by Aiden on 2022/09/15.
//

import RealmSwift
import ReactorKit

let realm = try? Realm()
let realmManager = RealmManager()

class RealmManager {
    /// 한 번에 뽑아오는 UserInfo의 개수
    static let numberUnit = 20
    
    func retrieveUserInfo(startIndex: Int) -> [UserInfo] {
        guard let realm = realm else { return [] }
        
        let allUserInfo = realm.objects(UserInfo.self)
        let totalUserInfoNumber = allUserInfo.count
        let lastValidIndex = totalUserInfoNumber - 1
        
        // TODO: 보완
        if startIndex > lastValidIndex {
            return []
        } else if startIndex == lastValidIndex {
            return [allUserInfo[startIndex]]
        } else { // startIndex < lastValidIndex
            let lastIndex = min(lastValidIndex, startIndex + RealmManager.numberUnit - 1)
            
            return Array(allUserInfo[startIndex...lastIndex])
        }
    }
    
}
