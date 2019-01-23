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

    func run( )-> Single<User> {
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

    init(token: String, requestFactory: RequestFactory) {
        self.token = token
        self.requestFactory = requestFactory
        self.request = requestFactory.newRequest(.LoginRequest)
        self.bag = DisposeBag()
    }
}
