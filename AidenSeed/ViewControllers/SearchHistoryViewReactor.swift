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
    }
    
    enum Mutation {
        case loading
        case loadHistory([History])
    }
    
    struct State {
        var isLoading: Bool = false
        var history: [History?]?
    }
    
    var initialState = State(isLoading: true, history: [])

    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat([
                Observable.just(Mutation.loading),
                
                // retrieve data
                self.retrieveHistory().map{
                    Mutation.loadHistory($0)
                }
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .loading:
            return State(isLoading: true, history: nil)
        case .loadHistory(let history):
            return State(isLoading: false, history: history)
        }
    }
}

extension SearchHistoryViewReactor {
    private func retrieveHistory() -> Observable<[History]> {
        let emptyResult: [History] = []
        guard let realm = realm else { return .just(emptyResult) }
        let userInfo = realm.objects(UserInfo.self)
        
        // TODO: Result<> 다루기(LazyMapSequence)
        let test = Array(userInfo)
        
        let history = test.map { return History(cellType: KeywordType.getKeywordType(userName: $0.name), userInfo: $0) }
        return .just(history)
    }

    
}



struct History {
    var cellType: KeywordType?
    var userInfo: UserInfo?
}

enum KeywordType {
    case imageLeft
    case imageRight
    
    static func getKeywordType(userName: String?) -> KeywordType {
        guard let userName = userName else {
            return .imageLeft
        }

        if userName < "N" {
            return .imageRight
        } else {
            return .imageLeft
        }
    }
}
