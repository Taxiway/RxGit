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
        let requestFactory = RequestFactoryImpl(userTokenManager: userTokenManager)
        let token = "c3b18274feacadbbf91956daf4170a0ef7c3f4e3"

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

