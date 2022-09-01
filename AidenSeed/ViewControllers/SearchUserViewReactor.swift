//
//  SearchUserViewReactor.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/24.
//

import ReactorKit
import Moya
import RxSwift
import Then
import RxRelay

class SearchUserViewReactor: Reactor {
    var gitHubProvider = MoyaProvider<GitHubProvider>()
    
    var results = PublishRelay<[String?]>()
    
    enum Action {
        case search(String?)
    }
    
    enum Mutation {
        case searchUserNames([String?])
    }
    
    struct State {
        var userNames: [String?] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let userName):
            var userNames = [""]
            
            gitHubProvider.request(.getUsers(userName: userName)) { result in
                switch result {
                case let .success(result):
                    guard let response = try? result.map(SearchUsersResponse.self) else { return }
                    guard let items = response.items else { return }
                    let responseUserNames = items.map{$0.login ?? ""}
                    userNames = responseUserNames
                    
                    // TODO: Observable<Mutation> 리턴
                    
                case let .failure(result):
                    print("Error occurred!:\n\(result)")
                    print(result.failureReason ?? "")
                }
                
            }
            
            return Observable.just(.searchUserNames(userNames))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = State()
        switch mutation {
        case .searchUserNames(let userNames):
            state.userNames = userNames
        }
        
        return state
    }
    
    var initialState: State = State()
}

extension SearchUserViewReactor {
    func searchUsers(_ userName: String?, createdBefore: String? = nil) {
        var userNames = [""]
        
        gitHubProvider.request(.getUsers(userName: userName, createdBefore: createdBefore)) { result in
            switch result {
            case let .success(result):
                guard let response = try? result.map(SearchUsersResponse.self) else { return }
                guard let items = response.items else { return }
                let responseUserNames = items.map{ $0.login ?? "" }
                userNames = responseUserNames
                
                userNames.sort(by: >) // sort descending

                self.results.accept(userNames)
                
            case let .failure(result):
                print("Error occurred!:\n\(result)")
                print(result.failureReason ?? "")
            }
        }
    }
}
