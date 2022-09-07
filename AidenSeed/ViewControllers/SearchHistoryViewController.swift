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
        
        // TODO: LocalDB에서 데이터 가져오기
        self.retrieveHistory()
        
    }
    
    private func bindAction() {
        
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
    
    private func retrieveHistory() {
        
        let userInfo = [
            UserInfo(login: nil, id: nil, nodeID: nil, avatarURL: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/cute-cat-photos-1593441022.jpg?crop=0.669xw:1.00xh;0.166xw,0&resize=640:*", gravatarID: nil, url: nil, htmlURL: nil, followersURL: nil, subscriptionsURL: nil, organizationsURL: nil, reposURL: nil, receivedEventsURL: nil, type: nil, score: nil, followingURL: nil, gistsURL: nil, starredURL: nil, eventsURL: nil, siteAdmin: nil, name: "Aiden", blog: nil, bio: nil),
            UserInfo(login: nil, id: nil, nodeID: nil, avatarURL: "https://ichef.bbci.co.uk/news/976/cpsprodpb/17638/production/_124800859_gettyimages-817514614.jpg", gravatarID: nil, url: nil, htmlURL: nil, followersURL: nil, subscriptionsURL: nil, organizationsURL: nil, reposURL: nil, receivedEventsURL: nil, type: nil, score: nil, followingURL: nil, gistsURL: nil, starredURL: nil, eventsURL: nil, siteAdmin: nil, name: "Ziden", blog: nil, bio: nil)
        ]
        
        let observable = Observable.of(userInfo)
        
        observable.bind(to: tableView.rx.items) { (tableView, index, userInfo) -> UITableViewCell in
            
            guard let name = userInfo.name, let avatarURL = userInfo.avatarURL else { return UITableViewCell() }
            if name < "N" {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "searchHistoryImageRightCell") as? SearchHistoryImageRightCell {
                    cell.userNameLabel.text = name
                    let url = avatarURL.url ?? URL(string: "")
                    cell.userImageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "searchHistoryImageLeftCell") as? SearchHistoryImageLeftCell {
                    cell.userNameLabel.text = name
                    let url = avatarURL.url ?? URL(string: "")
                    cell.userImageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
                    return cell
                }
            }

            return UITableViewCell()

        }.disposed(by: disposeBag)
    }
    
    


}
