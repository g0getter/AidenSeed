//
//  UITableView+Extensions.swift
//  AidenSeed
//
//  Created by 여나경 on 2022/09/26.
//

import UIKit
import RxSwift

extension UITableView {
    
    func detect80ScrollItself() -> Observable<Bool> {
        self.rx.contentOffset
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .map { $0.y }
            .map { contentTopOffset in
                let contentBottomOffset = contentTopOffset + self.frame.height
                let contentSize = self.contentSize.height
                
                // 등호를 넣어야 가장 처음(contentSize가 0)에도 true가 리턴됨.
                if contentSize - contentBottomOffset <= contentSize * 0.2 {
                    return true
                }
                return false
            }
    }
    
    // TODO: 삭제
    func detect80Scroll() -> Observable<Int> {
        
        self.rx.contentOffset
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .map { $0.y }
            .map { contentTopOffset in
                let contentBottomOffset = contentTopOffset + self.frame.height
                let contentSize = self.contentSize.height

                if contentSize - contentBottomOffset < contentSize * 0.2 {
                    let numberOfCells = self.numberOfRows(inSection: 0)
                    let nextIndex = numberOfCells

                    // TODO: 다음 페이지 로드하라는 신호 보내기
                    return nextIndex
                }
                return 0
            }
        
    }
}
