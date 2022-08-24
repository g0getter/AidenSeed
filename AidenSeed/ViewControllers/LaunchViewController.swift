//
//  LaunchViewController.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/24.
//

import UIKit
import Lottie
import SnapKit

class LaunchViewController: UIViewController {

    let animationView: AnimationView = {
        
        return AnimationView(name: "flying-rocket-in-the-sky")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        self.setLottie()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
        }
    }
    
    private func setLottie() {
        view.addSubview(animationView)
        animationView.play()
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(300)
        }
    }
    

}


