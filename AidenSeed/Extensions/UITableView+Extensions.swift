//
//  UITableView+Extensions.swift
//  AidenSeed
//
//  Created by 여나경 on 2022/09/26.
//

import UIKit
import RxSwift

extension UITableView {
    // TODO: @escaping closure() 이유와 적절한 방법인지 확인
    func detect80Scroll(disposeBag: DisposeBag, closure: @escaping((Int) -> ())) {
        
        self.rx.contentOffset
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .map { $0.y }
            .subscribe(onNext: { [weak self] contentTopOffset in
                guard let self = self else { return }
                let contentBottomOffset = contentTopOffset + self.frame.height
                let contentSize = self.contentSize.height

                // TODO: 아래 수식 다시 이해
                if contentSize - contentBottomOffset < contentSize * 0.2 {
                    let numberOfCells = self.numberOfRows(inSection: 0)
                    let nextIndex = numberOfCells

                    // TODO: 다음 페이지 로드하라는 신호 보내기
                    closure(nextIndex)
                }
            }).disposed(by: disposeBag)
        
//        withoutActuallyEscaping(closure, do: { escapableClosure in
//            self.rx.contentOffset
//                .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
//                .map { $0.y }
//                .subscribe(onNext: { [weak self] contentTopOffset in
//                    guard let self = self else { return }
//                    let contentBottomOffset = contentTopOffset + self.frame.height
//                    let contentSize = self.contentSize.height
//
//                    if contentSize - contentBottomOffset < contentSize * 0.2 {
//                        let numberOfCells = self.numberOfRows(inSection: 0)
//                        let nextIndex = numberOfCells
//
//                        // 정해진 클로저 실행!!
//                        // TODO: 다음 페이지 로드하라는 신호 보내기
//                        escapableClosure(nextIndex)
//                    }
//                }).disposed(by: disposeBag)
//        })
    }
}
