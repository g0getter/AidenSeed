//
//  AppDelegate.swift
//  AidenSeed
//
//  Created by Aiden on 2022/08/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        // TODO: LaunchViewController
//        self.window?.rootViewController = LaunchViewController()
//        self.window?.rootViewController = HomeViewController()
        self.window?.rootViewController = UINavigationController()
        
        guard let navigationController = self.window?.rootViewController as? UINavigationController else { return false }
        guard let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return false }
        homeVC.reactor = HomeViewReactor()
        navigationController.viewControllers = [homeVC]
        
        return true
    }


}

