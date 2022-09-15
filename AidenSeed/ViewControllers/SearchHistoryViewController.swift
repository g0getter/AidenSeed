//
//  SearchHistoryViewController.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/24.
//

import UIKit
import ReactorKit
import RxSwift
import SnapKit
import RealmSwift

class SearchHistoryViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()

    var tableView = UITableView().then {
        // TableView 세팅
        $0.backgroundColor = .blue.withAlphaComponent(0.2)
        
        let leftNib = UINib(nibName: "SearchHistoryImageLeftCell", bundle: nil)
        let rightNib = UINib(nibName: "SearchHistoryImageRightCell", bundle: nil)
        $0.register(leftNib, forCellReuseIdentifier: SearchHistoryImageLeftCell.identifier)
        $0.register(rightNib, forCellReuseIdentifier: SearchHistoryImageRightCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHandler.screenLogEvent("\(self)", #file, #function)
        
        view.backgroundColor = .white
        self.setUI()
        self.setTableView()
    }
    
    /// 화면 세팅
    private func setUI() {
        // 🔸NaivgationController 아닌 navigationItem이 드러나 있음.
//        self.navigationController?.title = "검색 이력"
        self.navigationItem.title = "검색 이력"
    }
    
    private func setTableView() {
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // Pull to refresh 구현
        tableView.refreshControl = UIRefreshControl().then {
            $0.rx.controlEvent(.valueChanged)
                .bind(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    print("refresh!!")
                    
                    self.reactor?.action.onNext(Reactor.Action.refresh)
                    
                }).disposed(by: disposeBag)
        }
        
        
    }
    
    func bind(reactor: SearchHistoryViewReactor) {
        self.bindAction(reactor)
        self.bindState(reactor)
        
        // TODO: Q. 아래 호출 위치 - viewWillAppear 혹은 bind()
        // TODO: refresh 대신 처음 호출하는 action 추가해야 하는지?
        reactor.action.onNext(Reactor.Action.refresh)        
    }
    
    private func bindAction(_ reactor: SearchHistoryViewReactor) {
        
        // TODO: model이 왜 SearchHistoryImageCell이 아니라 UserInfo인가?
        // TODO: model이 왜 UserInfo가 아니라 History인가?
        tableView.rx.modelSelected(History.self)
            .subscribe(onNext: { history in
                guard let userInfoVC = UIStoryboard(name: "UserInfoViewController", bundle: nil).instantiateViewController(withIdentifier: "UserInfoViewController") as? UserInfoViewController else { return }
                
                // cell의 userInfo 전달
                userInfoVC.userInfo = history.userInfo
                userInfoVC.reactor = UserInfoViewReactor(navigateFromSearchUser: false)
                
                self.navigationController?.pushViewController(userInfoVC, animated: true)
            }).disposed(by: disposeBag)
    }
    
    // TODO: Q: 파라미터 reactor와 self.reactor의 관계
    private func bindState(_ reactor: SearchHistoryViewReactor) {
        
        reactor.state.map { $0.isLoading }
            .bind(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                
                self.tableView.refreshControl?.rx.isRefreshing.onNext(isLoading)
            }).disposed(by: disposeBag)
        
        // 🔐 TODO: bind(to:) 완벽히 이해
        reactor.state.map{ $0.history ?? [] }
            .bind(to: tableView.rx.items) { (tableView, index, history) -> UITableViewCell in

                var cell: SearchHistoryImageCell?
                
                guard let history = history else { return UITableViewCell() }
                guard let cellType = history.cellType else { return UITableViewCell() }

                switch cellType {
                case .imageLeft:
                    cell = tableView.dequeueReusableCell(withIdentifier: "searchHistoryImageLeftCell") as? SearchHistoryImageLeftCell
                case .imageRight:
                    cell = tableView.dequeueReusableCell(withIdentifier: "searchHistoryImageRightCell") as?
                    SearchHistoryImageRightCell
                }
                
                guard let cell = cell else { return UITableViewCell() }
                
                cell.userInfo = history.userInfo
                
                cell.userNameLabel.text = history.userInfo?.name
                let url = history.userInfo?.avatarURL?.url ?? URL(string: "")
                cell.userImageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
                cell.selectionStyle = .none
                
                return cell

            }.disposed(by: disposeBag)
        
    }
}
