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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            guard let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
            homeVC.reactor = HomeViewReactor()
            
            self.navigationController?.viewControllers = [homeVC]
        }
    }
    
    private func setLottie() {
        view.addSubview(animationView)
        animationView.play()
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    

}


