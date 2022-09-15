//
//  SearchUserViewController.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/24.
//

import UIKit
import RxSwift
import ReactorKit
import RealmSwift

///
let realm = try? Realm() // 여기서 끝.

final class SearchUserViewController: UIViewController, UITextFieldDelegate {

    var safeAreaView = UIView()
    
    var disposeBag = DisposeBag()
    
    var textField = UITextField().then {
        $0.textColor = .black
        $0.borderStyle = .roundedRect
        $0.backgroundColor = .yellow
    }
    
    // TODO: 필터링뷰 어떻게 구성할지 알아본 후 수정
    var filterView = UIView()
    
    var filteringCreatedLabel = UILabel().then {
        $0.text = "Created before"
    }

    var datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko-KR")
//        $0.preferredDatePickerStyle = .automatic
    }
    
    var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .gray.withAlphaComponent(0.1)
        $0.allowsSelection = true
        
        $0.register(ResultCell.self, forCellReuseIdentifier: ResultCell.identifier)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHandler.screenLogEvent("\(self)", #file, #function)
        
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
        
        filterView.do { filterView in
            safeAreaView.addSubview(filterView)
            
            filterView.snp.makeConstraints {
                $0.leading.trailing.equalTo(textField)
                $0.top.equalTo(textField.snp.bottom).offset(5)
                $0.height.equalTo(40)
            }
            
            filteringCreatedLabel.do { label in
                filterView.addSubview(label)
                
                label.snp.makeConstraints {
                    $0.leading.equalToSuperview()
                    $0.centerY.equalToSuperview()
                    $0.width.equalTo(label.intrinsicContentSize)
                }
            }
            
            datePicker.do { datePicker in
                filterView.addSubview(datePicker)
                
                datePicker.snp.makeConstraints {
                    $0.centerY.equalToSuperview()
                    $0.leading.equalTo(self.filteringCreatedLabel.snp.trailing).offset(5)
                }
            }
        }
        
        tableView.do { tableView in
            safeAreaView.addSubview(tableView)
            tableView.snp.makeConstraints {
                $0.top.equalTo(filterView.snp.bottom).offset(10)
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
            .bind(onNext: { userName in
                reactor.action.onNext(.loadMore(userName, self.datePicker.date.toString(), nil))
            }).disposed(by: disposeBag)
        
        datePicker.rx.value.changed.asObservable()
            .subscribe({ event in
                guard let date = event.element else { return }
                reactor.action.onNext(.loadMore(self.textField.text, date.toString(), nil))
            }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                guard let cell = self.tableView.cellForRow(at: indexPath) as? ResultCell else { return }
                guard let userInfoVC = UIStoryboard(name: "UserInfoViewController", bundle: nil).instantiateViewController(withIdentifier: "UserInfoViewController") as? UserInfoViewController else { return }
                // cell의 userInfo 전달
                userInfoVC.userInfo = cell.userInfo
                userInfoVC.reactor = UserInfoViewReactor(navigateFromSearchUser: true)
                
                self.navigationController?.pushViewController(userInfoVC, animated: true)
                
            }).disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchUserViewReactor) {
        // TODO: Reactor 이용해서 화면 업데이트하기. 현재는 사실상 사용하고 있지 않음.
        // table view cell 구성
//        reactor.state.map { $0.userInfo }
//            .bind(to: tableView.rx.items(cellIdentifier: ResultCell.identifier)) {
//                index, userInfo, cell in
//                guard let cell = cell as? ResultCell else { return }
//                cell.selectionStyle = .none
//                cell.resultLabel.text = userInfo?.name
//                cell.userInfo = userInfo
//
//                let numberOfCells = self.tableView.numberOfRows(inSection: 0)
//                let nextPageNum = numberOfCells / 20
//                if index == numberOfCells - 3 { // 뒤에서 세 번째 cell이면
//                    print(index)
//
//                    self.reactor?.action.onNext(.loadMore(self.textField.text, nil, nextPageNum))
//                }
//            }.disposed(by: disposeBag)
        
        reactor.results
            .bind(to: tableView.rx.items) { (tableView, index, userInfo) -> ResultCell in
            
                let cell = self.getFilledResultCell(userInfo: userInfo)

                // TODO: 스크롤 방식 변경
                let numberOfCells = self.tableView.numberOfRows(inSection: 0)
                let nextPageNum = numberOfCells / 20

                if index == numberOfCells - 3 { // 뒤에서 세 번째 cell이면
                    print(index)

                    reactor.action.onNext(.loadMore(self.textField.text, self.datePicker.date.toString(), nextPageNum))
                }

                

                return cell

            }.disposed(by: disposeBag)
        
        
    }
    
    /// 데이터를 채운 ResultCell을 반환
    private func getFilledResultCell(userInfo: UserInfo?) -> ResultCell {
        let cell = ResultCell()
        
        guard let userID = userInfo?.login else { return cell }
        
        cell.selectionStyle = .none
        cell.resultLabel.text = userID // 삭제하면 안됨. 여기 대신 Cell 내부에서 UI 세팅 시 하면 안됨.
        cell.userInfo = userInfo
        return cell
        
    }

}

