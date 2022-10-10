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
import ReactorKit

class SearchUserViewReactor: Reactor {

    var userInfoList: [UserInfo] = [] // TODO: 필요한지 아닌지 결정
    
    enum Action {
        case resetAndSearch(String?, String?)
        case loadMore(String?, String?, Int?)
        case loadNextPage(String?, String?) // FIXME: 수정 후 사용
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
                gitHubAPI.loadMoreUsers(userName, createdBefore: createdBefore, nextPage: 1)
                // TODO: 원하는 것 >> Array의 extension인 sortedItems를 사용해서 아래와 비슷하게'.sortedItems'로 사용
//                    .sortedItems()
                    .map {
                        .resetAndSearchUserNames($0.sortedItems())
                }
            ])
        case .loadMore(let userName, let createdBefore, let nextPage):
            return Observable.concat([
                gitHubAPI.loadMoreUsers(userName, createdBefore: createdBefore, nextPage: nextPage).map {
                    .loadMoreUserNames($0.sortedItems())
                }
            ])
        case let .loadNextPage(userName, createdBefore):
            let nextIndex = self.userInfoList.count + 1
            let nextPageNum = nextIndex / UserInfoListConstant.listLength + 1
            return Observable.concat([
                gitHubAPI.loadMoreUsers(userName,
                                        createdBefore: createdBefore,
                                        nextPage: nextPageNum)
                .map {
                    self.userInfoList = self.userInfoList + $0.sortedItems() // TODO: 합친 것/새로운 것
                    return .loadMoreUserNames($0.sortedItems())
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

