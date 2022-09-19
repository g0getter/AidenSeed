//
//  UserInfo.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/29.
//

import Foundation
import RealmSwift
import ReactorKit

struct SearchUsersResponse: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [UserInfo]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

class UserInfo: Object, Codable {
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var login: String?
    @Persisted var avatarURL: String?
    @Persisted var name: String?
    @Persisted var blog: String?
    @Persisted var bio: String?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case name = "name"
        case blog = "blog"
        case bio = "bio"
    }
}

extension UserInfo {
    /// Converts UserInfo to History
    var asHistory: History {
        return History(cellType: KeywordType.getKeywordType(userID: self.id), userInfo: self)
    }
}
