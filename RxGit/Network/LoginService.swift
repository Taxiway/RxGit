//
//  LoginService.swift
//  RxGit
//
//  Created by Hang on 1/23/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift

protocol LoginService {
    var token: String { get set }
    func run() -> Single<User>
}

class LoginServiceImpl: LoginService {
    var token: String
    var requestFactory: RequestFactory
    var request: GitRequest
    var bag: DisposeBag
    var userTokenManager: UserTokenManager

    init(token: String, requestFactory: RequestFactory, userTokenManager: UserTokenManager) {
        self.token = token
        self.requestFactory = requestFactory
        self.userTokenManager = userTokenManager
        self.request = requestFactory.newRequest(.LoginRequest)
        self.bag = DisposeBag()
        setupRequest()
        setupToken()
    }

    func setupRequest() {
        self.request.method = .post
        self.request.queryJSON = ["query": "query { viewer { login } }"]
    }

    func setupToken() {
        self.userTokenManager.userToken = self.token
    }

    func run()-> Single<User> {
        return Single<User>.create(subscribe: { single in
            self.request.start()
                .subscribe(onSuccess: { json in
                    guard let user = User.init(json: json) else {
                        single(.error(NSError()))
                        return
                    }
                    single(.success(user))
                }, onError: { error in
                    single(.error(error))
                })
                .disposed(by: self.bag)
            return Disposables.create()
        })
    }
}
