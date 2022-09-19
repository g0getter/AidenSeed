//
//  SearchHistoryViewReactor.swift
//  AidenSeed
//
//  Created by Aiden on 2022/09/06.
//

import Foundation
import ReactorKit

class SearchHistoryViewReactor: Reactor {
    enum Action {
        case refresh
        case loadMore(Int)
    }
    
    enum Mutation {
        case loading(Bool)
        case loadHistory([History])
        case loadHistoryMore([History])
    }
    
    struct State {
        var isLoading: Bool = false
        var history: [History?]?
    }
    
    var initialState = State(isLoading: true, history: [])
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let firstHistoryUnit = realmManager.retrieveUserInfo(startIndex: 0).map { $0.asHistory }
            return Observable.concat([
                .just(.loading(true)),
                .just(.loadHistory(firstHistoryUnit)),
                .just(.loading(false))
            ])
        case let .loadMore(startIndex):
            let newHistory = realmManager.retrieveUserInfo(startIndex: startIndex)
                .map { $0.asHistory }
            return Observable.concat([
                .just(.loadHistoryMore(newHistory)),
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loading(let isLoading):
            newState.isLoading = isLoading
        case .loadHistory(let history):
            newState.history = history
        case .loadHistoryMore(let moreHistory):
            if let previousHistory = state.history {
                newState.history = previousHistory + moreHistory
            }
        }
        
        return newState
    }
}

struct History {
    var cellType: KeywordType?
    var userInfo: UserInfo?
}

enum KeywordType {
    case imageLeft
    case imageRight
    
    static func getKeywordType(userID: Int?) -> KeywordType {
        
        guard let userID = userID else {
            return .imageLeft
        }
        
        let firstDigit = self.getFirstDigit(userID)
        
        if firstDigit <= "5" {
            return .imageRight
        } else {
            return .imageLeft
        }

    }
    
    static func getFirstDigit(_ userID: Int) -> String {
        let firstCharactor = "\(userID)".first ?? "0"
        return "\(firstCharactor)"
    }
}
