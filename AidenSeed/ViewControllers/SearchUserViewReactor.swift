//
//  SearchUserViewReactor.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/24.
//

import ReactorKit

class SearchUserViewReactor: Reactor {
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
            // TODO: API request, response
            print("Result of \(userName ?? "")")
            userNames = ["\(userName ?? "")1", "\(userName ?? "")2"]
            userNames.append(contentsOf: userNames)
            userNames.append(contentsOf: userNames)
            userNames.append(contentsOf: userNames)
            userNames.append(contentsOf: userNames)
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

