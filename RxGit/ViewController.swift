//
//  ViewController.swift
//  RxGit
//
//  Created by Hang on 1/14/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    var bag = DisposeBag()
    var loginService: LoginService?

    override func viewDidLoad() {
        super.viewDidLoad()
        // To test the request
        let serviceFactory = ServiceFactoryImpl()
        let userTokenManager = UserTokenManagerImpl()
        let requestFactory = RequestFactoryImpl()
        requestFactory.userTokenManager = userTokenManager
        let token = "17c6ca673e2b54ede099ba77295aaeddceefb755"

        loginService = serviceFactory.newLoginService(token: token, requestFactory: requestFactory, userTokenManager: userTokenManager)
        
        loginService?.run()
            .subscribe(onSuccess: { user in
                print(user.name)
            }, onError: { error in
                print("Error")
            })
            .disposed(by: bag)
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

