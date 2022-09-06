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
        case loading
    }
    
    enum Mutation {
        case loadHistory
        case showHistory
    }
    
    struct State {
        var history: [History?]?
    }
    
    var initialState = State(history: nil)
    
}

struct History {
    var cellType: KeywordType?
    var userName: String?
    var userImageName: String?
}

enum KeywordType {
    case imageLeft
    case imageRight
}
