//
//  HomeViewReactor.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/24.
//

import Foundation
import ReactorKit

enum PressedButton {
    case nothing
    case searchUser
    case searchHistory
}

class HomeViewReactor: Reactor {
    enum Action {
        case pressSearchUserButton
        case pressSearchHistoryButton
    }
    
    enum Mutation {
        case searchUserButtonPressed
        case searchHistoryButtonPressed
    }
    
    struct State {
        var pressedButton: PressedButton
    }

    var initialState = State(pressedButton: .nothing)
    
    // 온갖 일을 함(필요 시 API 호출)
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .pressSearchUserButton:
            return Observable.concat([
                Observable.just(Mutation.searchUserButtonPressed)
            ])
        case .pressSearchHistoryButton:
            return Observable.concat([
                Observable.just(Mutation.searchHistoryButtonPressed)
            ])
        }
        
    }
    
    // state만 방출
    func reduce(state: State, mutation: Mutation) -> State {
        var state = State(pressedButton: .nothing)
        switch mutation {
        case .searchUserButtonPressed:
            state.pressedButton = .searchUser
        case .searchHistoryButtonPressed:
            state.pressedButton = .searchHistory
        }
        
        return state
    }
}

extension PressedButton {
    var backgroundColor: UIColor {
        switch self {
        case .nothing:
            return .clear
        case .searchUser:
            return .green.withAlphaComponent(0.7)
        case .searchHistory:
            return .red.withAlphaComponent(0.7)
        }
    }
}
