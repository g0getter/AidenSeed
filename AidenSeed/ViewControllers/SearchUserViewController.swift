//
//  SearchUserViewController.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/24.
//

import UIKit
import RxSwift
import ReactorKit

final class SearchUserViewController: UIViewController, UITextFieldDelegate {

    var safeAreaView = UIView()
    
    var disposeBag = DisposeBag()
    
    var textField = UITextField().then {
        $0.textColor = .black
        $0.borderStyle = .roundedRect
        $0.backgroundColor = .yellow
    }
    
    var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .gray.withAlphaComponent(0.1)
        $0.allowsSelection = true
        
        $0.register(ResultCell.self, forCellReuseIdentifier: ResultCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        self.setUI()
        self.setTableView()
        self.setKeyboardView()
    }
    
    /// 키보드 올라오면 올라온만큼 테이블뷰의 높이 조정
    private func setKeyboardView() {
        
        let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        
        let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        
        let keyboardHeight = Observable.from([
            keyboardWillShow
                .map { notification in
                    return (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                },
            keyboardWillHide
                .map{ _ in 0 }
        ]).merge()
        
        keyboardHeight.subscribe(onNext: { [weak self] height in
            guard let self = self else { return }
            self.tableView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-height)
            }
        }).disposed(by: disposeBag)

    }
    
    private func setUI() {
        view.addSubview(safeAreaView)
        self.safeAreaView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        
        textField.do { textField in
            safeAreaView.addSubview(textField)
            textField.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(10)
                $0.height.equalTo(40)
            }
        }
        
        tableView.do { tableView in
            safeAreaView.addSubview(tableView)
            tableView.snp.makeConstraints {
                $0.top.equalTo(textField.snp.bottom).offset(10)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    private func setTableView() {
        
    }
}
    
extension SearchUserViewController: View {
    func bind(reactor: SearchUserViewReactor) {
        self.bindAction(reactor)
        self.bindState(reactor)
    }
    
    private func bindAction(_ reactor: SearchUserViewReactor) {
        textField.rx.text
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map { .search($0) }
            .bind(to: reactor.action )
            .disposed(by: disposeBag)
       
        // FIXME: 아래 바인딩 삭제
        textField.rx.text
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind(onNext: { userName in
                reactor.searchUsers(userName)
            }).disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchUserViewReactor) {
        // TODO: Reactor 이용해서 화면 업데이트하기. 현재는 사실상 사용하고 있지 않음.
        // table view cell 구성
//        reactor.state.map { $0.userNames }
//            .bind(to: tableView.rx.items(cellIdentifier: ResultCell.identifier)) {
//                index, userName, cell in
//                guard let cell = cell as? ResultCell else { return }
//                cell.selectionStyle = .none
//                cell.resultLabel.text = userName
//            }.disposed(by: disposeBag)
        
        reactor.results
            .bind(to: tableView.rx.items(cellIdentifier: ResultCell.identifier)) {
                index, userName, cell in
                guard let cell = cell as? ResultCell else { return }
                cell.selectionStyle = .none
                cell.resultLabel.text = userName
            }.disposed(by: disposeBag)
        
        
    }
}

