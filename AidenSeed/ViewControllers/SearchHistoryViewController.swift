//
//  SearchHistoryViewController.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/24.
//

import UIKit
import ReactorKit

class SearchHistoryViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()

    var tableView = UITableView().then {
        // TableView 세팅
        $0.backgroundColor = .blue.withAlphaComponent(0.2)
        
        // TODO: Cell 등록
        $0.register(SearchHistoryImageLeftCell.self, forCellReuseIdentifier: "searchHistoryImageLeftCell")
        $0.register(SearchHistoryImageRightCell.self, forCellReuseIdentifier: "searchHistoryImageRightCell")
        
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
        
    }
    
    func bind(reactor: SearchHistoryViewReactor) {
        // TODO: LocalDB에서 데이터 가져오기
        self.retrieveHistory()
        
        self.bindAction()
        self.bindState()
    }
    
    private func bindAction() {
        
    }
    
    private func bindState() {
        self.reactor?.state.map{ $0.history }
//            .bind(to: tableView.rx.items()
        
    }
    
    private func retrieveHistory() {
        
    }
    
    


}
