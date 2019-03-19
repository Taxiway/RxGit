//
//  LoginViewController.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    private weak var appController : AppController!
    let serviceFactory = ServiceFactoryImpl.sharedInstance
    let requestFactory = RequestFactoryImpl.sharedInstance
    let userTokenManager = UserTokenManagerImpl()
    var bag = DisposeBag()
    var loginService: LoginService!
    var state : Variable<State> = Variable(.standby)
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var tokenButton: UIButton!
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    
    enum State {
        case standby
        case fetching
    }
    
    static func make(_ appController : AppController!) -> LoginViewController? {
        let controller = UIStoryboard(
            name: "Login",
            bundle: Bundle(for: AppDelegate.self))
            .instantiateInitialViewController() as? LoginViewController
        controller?.appController = appController
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestFactory.userTokenManager = userTokenManager
        loginService = serviceFactory.newLoginService(token: "", requestFactory: requestFactory, userTokenManager: userTokenManager)
        activeIndicator.hidesWhenStopped = true
        //test
        state.asObservable().subscribe(onNext: { [unowned self] state in
            switch state {
            case .standby:
                self.activeIndicator.isHidden = true
                self.signInButton.setTitle("Sign in", for: .normal)
            case .fetching:
                self.activeIndicator.isHidden = false
                self.activeIndicator.startAnimating()
                self.signInButton.setTitle("Login...", for: .normal)
            }
        }).disposed(by: bag)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignInButton(_ sender: Any) {
        state.value = .fetching
    }
    
    @IBAction func onTokenButton(_ sender: Any) {
        let alert = UIAlertController(title: "Personal Access Token", message: "Sign in with a Personal Access Token", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Personal Access Token"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { [weak alert, unowned self] _ in
            alert?.actions.forEach { $0.isEnabled = false }
//            let token = alert?.textFields?.first?.text ?? ""
            let token = "f82a53401ced79613d70d5b8bd0bd01e02bda56b"
            self.loginService.token = token
            self.loginService.run()
                .subscribe(onSuccess: { [unowned self] user in
                        print(user)
                        self.state.value = .standby
                        self.appController.didLoginWith(user: user)
                    }, onError: { error in
                        print("Error")
                        self.state.value = .standby
                        self.handleError()
                })
                .disposed(by: self.bag)
            self.state.value = .fetching
        }))
        
        present(alert, animated: !UIAccessibility.isReduceMotionEnabled)
    }
    
    private func handleError() {
        let alert = UIAlertController(title: "Error", message: "Login failed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: !UIAccessibility.isReduceMotionEnabled)
    }

}
