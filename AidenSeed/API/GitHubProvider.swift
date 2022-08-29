//
//  GitHubProvider.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/29.
//

import Moya

enum GitHubProvider {
    case getUsers(userName: String?)
//    case getAUserInfo
}

extension GitHubProvider: TargetType {
    var baseURL: URL {
        return "https://api.github.com".url!
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return "/search/users"
            
        }
    }
    
    var method: Method {
        switch self {
        case .getUsers:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUsers(let userName):
            var searchKeyword = "\"\""
            let numberPerPage = 20
//            TODO: var pageNumber(출력할 페이지 넘버)
            if let userName = userName, userName.isEmpty == false {
                searchKeyword = userName
            }
            let params: [String : Any] = ["q": searchKeyword,
                                          "per_page": numberPerPage]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            // TODO: encoding: URLEncoding.queryString or JSONEncoding.default
        }
    }
    
    /// 적절한 HTTP header 반환.
    /// - JSON 응답일 경우 Content-Type:application/json
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
