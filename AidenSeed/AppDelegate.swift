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
        self.window?.rootViewController = UINavigationController()
        
        guard let navigationController = self.window?.rootViewController as? UINavigationController else { return false }
        
        let launchVC = LaunchViewController()
        navigationController.viewControllers = [launchVC]
        
        return true
    }


}

