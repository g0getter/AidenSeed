//
//  UserInfoViewController.swift
//  AidenSeed
//
//  Created by Aiden on 2022/09/01.
//

import UIKit
import Kingfisher
import ReactorKit

class UserInfoViewController: UIViewController {
    
    var disposeBag = DisposeBag()

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var bioView: UITextView!
    @IBOutlet weak var blogView: UITextView!
    
    var userInfo: UserInfoTest?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUserImage(userInfo?.avatarURL)
        self.setTextView()
        
        userInfoLabel.numberOfLines = 0
    }
    
    private func setUserImage(_ url: String?) {
        
        userImage.do { imageView in
            guard let userImageUrl = URL(string: url ?? "") else { return }
            imageView.kf.setImage(with: userImageUrl,
            placeholder: UIImage(named: "defaultImage"))
        }
    }
    
    /// `bioView`, `blogView`링크 선택되도록 세팅
    private func setTextView() {
        self.bioView.do {
            $0.textAlignment = .center
            $0.dataDetectorTypes = .link
            $0.isEditable = false
            $0.isScrollEnabled = false // 유동 높이 위해 필요
        }
        
        self.blogView.do {
            $0.delegate = self
            $0.textAlignment = .center
            $0.dataDetectorTypes = .link
            $0.isEditable = false
            $0.isScrollEnabled = false // 유동 높이 위해 필요
        }
        
    }
    
    private func setUserInfo(_ loginID: String?, bio: String?, blog: String?) {
        userInfoLabel.text = loginID
        bioView.text = bio
        blogView.text = blog
    }
    
    private func bindAction() {
        
    }
    
    private func bindState() {
        self.reactor?.userInfoRelay
            .bind(onNext: { [weak self] userInfo in
                guard let self = self else { return }
                self.setUserImage(userInfo.avatarURL)
                self.setUserInfo(userInfo.login, bio: userInfo.bio, blog: userInfo.blog)
            }).disposed(by: disposeBag)
    }
}

extension UserInfoViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let webViewController = WebViewController(URL)
        self.present(webViewController, animated: true)
        return false // Safari 앱 열지 않음
    }
}

extension UserInfoViewController: StoryboardView {
    
    func bind(reactor: UserInfoViewReactor) {
        reactor.getUserInfo(userInfo)
        self.bindAction()
        self.bindState()
    }
}
