//
//  AppController.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

class AppController: NSObject, UITabBarControllerDelegate {
    private weak var loginViewController: LoginViewController?
    private var appController : UITabBarController!
    private var userInfo : User?
    
    func appDidFinishLaunching(with window: UIWindow?) {
        guard let controller = window?.rootViewController as? UITabBarController else {
            fatalError("...")
        }
        appController = controller
        appController.delegate = self
    }
    
    func showLogin() {
        guard let controller = LoginViewController.make(self) else { return }
        if let user = userInfo, user.token.count > 0 { return }
        loginViewController = controller
        appController.present(controller, animated: false)
    }
    
    func enterLibrary() {
        if let presented = appController.presentedViewController, presented is LoginViewController {
            presented.dismiss(animated: false, completion: nil)
        }
    }
    
    func didLoginWith(user: User) {
        userInfo = user
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title?.compare("Logout").rawValue == 0 {
            let alert = UIAlertController(title: "Do you want to sign out?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
                self?.userInfo = nil
                self?.showLogin()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            appController.present(alert, animated: !UIAccessibility.isReduceMotionEnabled)
            return false
        }
        return true
    }
    
    
    
}
