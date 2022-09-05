//
//  UserInfoViewReactor.swift
//  AidenSeed
//
//  Created by Aiden on 2022/09/02.
//

import Foundation
import ReactorKit
import Moya
import RxRelay

class UserInfoViewReactor: Reactor {
    
    var gitHubProvider = MoyaProvider<GitHubProvider>()
    
    enum Action {}
    
    enum Mutation {}
    
    struct State {}
    
    var initialState = State()
    
    var userInfo = PublishRelay<UserInfo>()
    
    func getUserInfo(_ userName: String?) {
        guard let userName = userName else { return }

        gitHubProvider.request(.getAUserInfo(userName: userName)) { result in
            switch result {
            case let .success(result):
                guard let response = try? result.map(UserInfo.self) else { return }
                self.userInfo.accept(response)
            case let .failure(result):
                print(result.failureReason ?? "")
            }
            
        }
    }
}
