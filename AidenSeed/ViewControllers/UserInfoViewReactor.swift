//
//  UserInfoViewReactor.swift
//  AidenSeed
//
//  Created by Aiden on 2022/09/02.
//

import Foundation
import ReactorKit
import Moya
import RxRelay
import RealmSwift

class UserInfoViewReactor: Reactor {
    
    init(navigateFromSearchUser: Bool = false) {
        self.navigateFromSearchUser = navigateFromSearchUser
    }
    
    var navigateFromSearchUser: Bool
    
    var gitHubProvider = MoyaProvider<GitHubProvider>()
    
    enum Action {}
    
    enum Mutation {}
    
    struct State {}
    
    var initialState = State()
    
    var userInfoRelay = PublishRelay<UserInfo>()
    
    func getUserInfo(_ userInfo: UserInfo?) {
//        guard let userName = userInfo?.name else { return }
        guard let userName = userInfo?.login else { return }
        // TODO: 이름(login, blog, bio 출력)
        
        guard let realm = realm else { return }
        
        // SearchUserViewController에서 이동 시: request API
        if self.navigateFromSearchUser {
            // request API
            gitHubProvider.request(.getAUserInfo(userName: userName)) { result in
                switch result {
                case let .success(result):
                    guard let response = try? result.map(UserInfo.self) else { return }
                    self.userInfoRelay.accept(response)
                
                    // TODO: realm.write 가 실행되지 않는 경우 어떤 경우인지.(예상: DB에 해당 primaryKey 존재하는 경우)
                    try? realm.write {
                        // TODO: 재조회했을 때 삭제하고 다시 추가하도록 수정(Deal with 'Can only delete an object from the Realm it belongs to')
                        if realm.object(ofType: UserInfo.self, forPrimaryKey: userInfo?.id) != nil {
//                            realm.delete(response)
                            return
                        }
                        
                        // Local DB에 저장
                        realm.add(response)
                    }
                    
                case let .failure(result):
                    print(result.failureReason ?? "")
                }
                
            }
            
        } else {
            // SearchHistoryViewController에서 이동 시: Local DB에서 조회
            guard let existingUser = realm.object(ofType: UserInfo.self, forPrimaryKey: userInfo?.id) else { return }
            self.userInfoRelay.accept(existingUser)
            
        }
        
        
        
    }
}
