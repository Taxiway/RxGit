//
//  AppController.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

class AppController: NSObject {
    private weak var loginViewController: LoginViewController?
    private var appController : UIViewController!
    private var userInfo : User?
    
    func appDidFinishLaunching(with window: UIWindow?) {
        guard let controller = window?.rootViewController else {
            fatalError("...")
        }
        appController = controller
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
    
    
    
}
