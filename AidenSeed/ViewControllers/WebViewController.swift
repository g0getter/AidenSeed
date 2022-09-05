//
//  WebViewController.swift
//  AidenSeed
//
//  Created by Aiden on 2022/09/05.
//

import Foundation
import WebKit

/// 앱 내에서 웹뷰를 띄우기 위한 뷰 컨트톨러.
class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var url: URL?
    
    init(_ url: URL) {
        super.init(nibName: nil, bundle: nil) // 필요
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = url else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}

