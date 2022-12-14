//
//  GitHubProvider.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/29.
//

import Moya
import RxSwift

var gitHubProvider = MoyaProvider<GitHubProvider>()
var gitHubAPI = GitHubAPI()

enum GitHubProvider {
    case getUsers(userName: String?, createdBefore: String? = nil, pageNumber: Int? = 0)
    case getAUserInfo(userName: String)
}

extension GitHubProvider: TargetType {
    var baseURL: URL {
        return "https://api.github.com".url!
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return "/search/users"
        case .getAUserInfo(let userName):
            return "/users/\(userName)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUsers, .getAUserInfo:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUsers(let userName, let createdBefore, let pageNumber):
            var searchKeyword = "\"\""
            let numberPerPage = 20
            
            if let userName = userName, userName.isEmpty == false {
                searchKeyword = userName
            }
            if let createdBefore = createdBefore {
                let createdBeforeQuery = "created:<\(createdBefore)"
                if searchKeyword == "\"\"" {
                    searchKeyword = createdBeforeQuery
                } else {
                    searchKeyword = "\(searchKeyword) \(createdBeforeQuery)"
                }
            }
            
            var params: [String : Any] = ["q": searchKeyword,
                                          "per_page": numberPerPage]
            if let pageNum = pageNumber {
                params.updateValue(pageNum, forKey: "page")
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            // TODO: encoding: URLEncoding.queryString or JSONEncoding.default
        case .getAUserInfo:
            return .requestPlain

        }
    }
    
    /// 적절한 HTTP header 반환.
    /// - JSON 응답일 경우 Content-Type:application/json
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}

class GitHubAPI {
    
    /// 새로운 UserInfo 배열을 반환
    func loadMoreUsers(_ userName: String?, createdBefore: String? = nil, nextPage: Int?) -> Observable<[UserInfo]> {
        
        return Observable.create { observer in
            
            gitHubProvider.request(.getUsers(userName: userName, createdBefore: createdBefore, pageNumber: nextPage)) { result in
                switch result {
                case let .success(result):
                    guard let response = try? result.map(SearchUsersResponse.self) else { return }
                    guard let items = response.items else { return }
                    
                    // Observable<Mutation> 리턴 대신 observer에 방출
                    observer.onNext(items)
                    
                case let .failure(result):
                    print("Error occurred!:\n\(result)")
                    print(result.failureReason ?? "")
                }
            }
            
            return Disposables.create()
            
        }
    }
}
