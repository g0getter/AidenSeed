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

    var userInfoList: [UserInfo]? // Optional로 설정해야 초기 진입과 api에서 받은 값이 0일 때를 구분할 수 있음.
    
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
                        self.userInfoList = $0.sortedItems()
                        return .resetAndSearchUserNames($0.sortedItems())
                }
            ])
        case .loadMore(let userName, let createdBefore, let nextPage):
            return Observable.concat([
                gitHubAPI.loadMoreUsers(userName, createdBefore: createdBefore, nextPage: nextPage).map {
                    .loadMoreUserNames($0.sortedItems())
                }
            ])
        case let .loadNextPage(userName, createdBefore):
            var nextPageNum = 1 // 초기 진입 시 "1" page를 로드하기 위해 값 세팅 필요. // TODO: 진짜 필요한지 재고
            
            if let currentIndex = self.userInfoList?.count {
                let nextIndex = currentIndex + 1
                nextPageNum = nextIndex / UserInfoListConstant.listLength + 1
            }
//            let nextIndex = self.userInfoList.count + 1
//            let nextPageNum = nextIndex / UserInfoListConstant.listLength + 1
            return Observable.concat([
                gitHubAPI.loadMoreUsers(userName,
                                        createdBefore: createdBefore,
                                        nextPage: nextPageNum)
                .map {
                    self.userInfoList = (self.userInfoList ?? []) + $0.sortedItems() // self.userInfo 업데이트(전체)
                    return .loadMoreUserNames($0.sortedItems()) // 내보내는 것은 새로운 userInfo만.
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

