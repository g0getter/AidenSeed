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
        FirebaseLogger.screenLogEvent("\(self)", #file, #function)
        
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
        tableView.contentSize = CGSize(width: self.view.frame.size.width, height: 500)
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
            .map { .resetAndSearch($0, self.datePicker.date.toString()) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        datePicker.rx.value.changed
//            .asObservable()
            .map { .resetAndSearch(self.textField.text, $0.toString()) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
        
//        tableView.detect80Scroll(disposeBag: disposeBag) { nextIndex in
//            // First page number: 1
//            let nextPageNum = nextIndex / UserInfoListConstant.listLength + 1
//
//            self.reactor?.action.onNext(.loadMore(self.textField.text, self.datePicker.date.toString(), nextPageNum))
//        }
        
//        tableView.detect80Scroll()
//            .subscribe(onNext: { nextIndex in
//                let nextPageNum = nextIndex / UserInfoListConstant.listLength + 1
//                //
//                self.reactor?.action.onNext(.loadMore(self.textField.text, self.datePicker.date.toString(), nextPageNum))
//            }).disposed(by: disposeBag)
        
        // Q. 매번 방출하는 것이 아니니까 .map{}.bind(to: reactor.action)이 불가능하고 .bind(onNext:)로만 가능한 게 맞는지?
        tableView.detect80ScrollItself()
            .debug("TEST MSG")
            .bind(onNext: { isDetected in
                if isDetected {
                    reactor.action.onNext(.loadNextPage(self.textField.text,
                                         self.datePicker.date.toString()))
                }
            }).disposed(by: disposeBag)
        
        
//            .map { isDetected in
//                if isDetected {
//                    return .loadNextPage(self.textField.text,
//                                         self.datePicker.date.toString())
//                }
//            }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchUserViewReactor) {
        
        reactor.state.map { $0.userInfo }
            .bind(to: tableView.rx.items) { (tableView, index, userInfo) -> ResultCell in

                let cell = self.getFilledResultCell(userInfo: userInfo)

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
