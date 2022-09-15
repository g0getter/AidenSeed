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
import RealmSwift

class SearchUserViewReactor: Reactor {
    var gitHubProvider = MoyaProvider<GitHubProvider>()
    
    var results = PublishRelay<[UserInfo?]>()
    
    /// 계속 쌓아나갈 유저이름 배열
    private var userInfo: [UserInfo] = []

    enum Action {
        case loadMore(String?, String?, Int?)
    }
    
    enum Mutation {
        case loadMoreUserNames([UserInfo?])
    }
    
    struct State {
        var pageNumber: Int? = 0
        var userInfo: [UserInfo?] = [] // 추가!!
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadMore(let userName, let createdBefore, let nextPage):
            
            return Observable.concat([
                self.loadMoreUsers(userName, createdBefore: createdBefore, nextPage: nextPage).map {
                    Mutation.loadMoreUserNames($0)
                }
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = State()
        switch mutation {
        case .loadMoreUserNames(let userInfo):
            state.userInfo = userInfo
        }
        
        return state
    }
    
    var initialState: State = State()
}

extension SearchUserViewReactor {
    
    private func loadMoreUsers(_ userName: String?, createdBefore: String? = nil, nextPage: Int?) -> Observable<[UserInfo]> {
        
        if nextPage == nil { // 검색해서 처음 로드 시
            self.userInfo = []
        }
        gitHubProvider.request(.getUsers(userName: userName, createdBefore: createdBefore, pageNumber: nextPage)) { result in
            switch result {
            case let .success(result):
                guard let response = try? result.map(SearchUsersResponse.self) else { return }
                guard let items = response.items else { return }
                
                var sortedItems = items
                sortedItems.sort { (a, b) in
                    return a.login ?? "" < b.login ?? ""
                }

                self.userInfo.append(contentsOf: sortedItems) // 09/14 추가
                self.results.accept(self.userInfo)
                // TODO: Observable<Mutation> 리턴
                
            case let .failure(result):
                print("Error occurred!:\n\(result)")
                print(result.failureReason ?? "")
            }
        }
        
        return .just(self.userInfo) // 사실상 무의미
    }
    
}
