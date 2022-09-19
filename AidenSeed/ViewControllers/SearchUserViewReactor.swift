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

    enum Action {
        case resetAndSearch(String?, String?)
        case loadMore(String?, String?, Int?)
    }
    
    enum Mutation {
        case resetAndSearchUserNames([UserInfo?])
        case loadMoreUserNames([UserInfo?])
    }
    
    struct State {
        var userInfo: [UserInfo?] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .resetAndSearch(let userName, let createdBefore):
            return Observable.concat([
                gitHubAPI.loadMoreUsers(userName, createdBefore: createdBefore, nextPage: 1).map {
                    .resetAndSearchUserNames($0)
                }
            ])
        case .loadMore(let userName, let createdBefore, let nextPage):
            return Observable.concat([
                gitHubAPI.loadMoreUsers(userName, createdBefore: createdBefore, nextPage: nextPage).map {
                    .loadMoreUserNames($0)
                }
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .resetAndSearchUserNames(let userInfo):
            newState.userInfo = userInfo
        case .loadMoreUserNames(let userInfo):
            newState.userInfo = state.userInfo + userInfo
        }
        
        return newState
    }
    
    var initialState: State = State()
}
