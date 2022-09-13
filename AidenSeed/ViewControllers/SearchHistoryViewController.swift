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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    func bind(reactor: SearchHistoryViewReactor) {
        self.bindAction()
        self.bindState()
        
        self.retrieveHistory()
        
    }
    
    private func bindAction() {
        
        // TODO: model이 왜 SearchHistoryImageCell이 아니라 UserInfo인가?
        tableView.rx.modelSelected(UserInfo.self)
            .subscribe(onNext: { userInfo in
                guard let userInfoVC = UIStoryboard(name: "UserInfoViewController", bundle: nil).instantiateViewController(withIdentifier: "UserInfoViewController") as? UserInfoViewController else { return }
                // cell의 userInfo 전달
                userInfoVC.userInfo = userInfo
                userInfoVC.reactor = UserInfoViewReactor(navigateFromSearchUser: false)
                
                self.navigationController?.pushViewController(userInfoVC, animated: true)
            }).disposed(by: disposeBag)
        
               
    }
    
    private func bindState() {
        guard let reactor = reactor else { return }
        
//        reactor.state.map{ $0.history }
//            .bind(onNext: { history in
//
//            }).disposed(by: disposeBag)
        
        // 🔐 TODO: bind(to:) 완벽히 이해
//        reactor.state.map{ $0.history ?? [] }
//            .bind(to: tableView.rx.items) { (tableView, index, item) -> UITableViewCell in
////                switch item
//                let cell = SearchHistoryImageLeftCell()
//                cell.userNameLabel.text = item?.userName
//                cell.userImageView.image = UIImage(named: item?.userImageName ?? "")
//                return cell
//
//            }.disposed(by: disposeBag)
        
    }
    
    // TODO: Reactor로 옮기기
    private func retrieveHistory() {
        guard let realm = realm else { return }
        let history = realm.objects(UserInfo.self)
        
        Observable.just(history).bind(to: tableView.rx.items) { (tableView, index, userInfo) -> UITableViewCell in
            
            var cell: SearchHistoryImageCell?
            
            guard let name = userInfo.name else { return UITableViewCell() }
            if name < "N" {
                cell = tableView.dequeueReusableCell(withIdentifier: "searchHistoryImageRightCell") as? SearchHistoryImageRightCell
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "searchHistoryImageLeftCell") as? SearchHistoryImageLeftCell
            }
            
            guard let cell = cell else { return UITableViewCell() }
            
            cell.userInfo = userInfo
            
            cell.userNameLabel.text = name
            let url = userInfo.avatarURL?.url ?? URL(string: "")
            cell.userImageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
            cell.selectionStyle = .none
            
            return cell

        }.disposed(by: disposeBag)
    }
    
    


}
