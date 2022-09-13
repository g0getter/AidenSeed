//
//  UserInfo.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/29.
//

import Foundation
import RealmSwift

// MARK: - Welcome
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

struct SearchUsersResponseTest: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [UserInfoTest]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

class UserInfoTest: Object, Codable {
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

// MARK: - Item
struct UserInfo: Codable {
    let login: String?
    let id: Int?
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url, htmlURL, followersURL, subscriptionsURL: String?
    let organizationsURL, reposURL, receivedEventsURL: String?
    let type: String?
    let score: Int?
    let followingURL, gistsURL, starredURL, eventsURL: String?
    let siteAdmin: Bool?
    let name, blog, bio: String?

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case receivedEventsURL = "received_events_url"
        case type, score
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case eventsURL = "events_url"
        case siteAdmin = "site_admin"
        case name = "name"
        case blog = "blog"
        case bio = "bio"
    }
}
