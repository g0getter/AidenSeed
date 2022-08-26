//
//  HomeViewController.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/24.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import ReactorKit

class HomeViewController: UIViewController, StoryboardView {
    @IBOutlet weak var searchUserButton: UIButton!
    @IBOutlet weak var searchHistoryButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        searchUserButton.do { button in
            button.setYellowTheme()
            
            UILabel().do { label in
                view.addSubview(label)
                label.text = "유저 검색"
                label.textColor = .black
                
                label.snp.makeConstraints {
                    $0.center.equalTo(button)
                }
            }
            
        }
        
        searchHistoryButton.do { button in
            button.setYellowTheme()
            
            UILabel().do { label in
                view.addSubview(label)
                label.text = "검색 이력"
                label.textColor = .black
                
                label.snp.makeConstraints {
                    $0.center.equalTo(button)
                }
            }
            
        }
    }
}

extension HomeViewController {
    func bind(reactor: HomeViewReactor) {
        // Action
        // debounce 사용 이유: 마지막 입력만 유효하게
        searchUserButton.rx.tap.debounce(.milliseconds(5), scheduler: MainScheduler.instance)
            .map{ .pressSearchUserButton }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        searchHistoryButton.rx.tap.debounce(.milliseconds(3), scheduler: MainScheduler.instance)
            .map{ .pressSearchHistoryButton }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.pressedButton }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] button in
                guard let self = self else { return }
                self.view.backgroundColor = button.backgroundColor
                self.navigateToNextScreen(relatedTo: button)
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToNextScreen(relatedTo button: PressedButton) {
        var vc: UIViewController?
        switch button {
        case .nothing:
            break
        case .searchUser:
            let searchUserVC = SearchUserViewController()
            searchUserVC.reactor = SearchUserViewReactor()
            vc = searchUserVC
        case .searchHistory:
            vc = SearchHistoryViewController()
        }
        
        guard let vc = vc else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension UIButton {
    func setYellowTheme() {
        self.do { button in
            button.setTitle("", for: .normal)
            button.backgroundColor = .yellow
            button.layer.cornerRadius = 10
            
        }
    }
}
