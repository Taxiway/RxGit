//
//  RepositoriesService.swift
//  RxGit
//
//  Created by Hang on 2/15/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift

protocol RepositoriesService {
    func run() -> Single<Repositories>
}

class RepositoriesServiceImpl: RepositoriesService {
    var requestFactory: RequestFactory
    var request: GitRequest?
    var bag: DisposeBag
    var userTokenManager: UserTokenManager
    
    init(requestFactory: RequestFactory, userTokenManager: UserTokenManager) {
        self.requestFactory = requestFactory
        self.userTokenManager = userTokenManager
        self.request = requestFactory.newRequest()
        self.bag = DisposeBag()
        setupRequest()
    }

    func setupRequest() {
        self.request?.method = .post
        self.request?.queryJSON = ["query": JSONQueries.Repositories.rawValue]
    }

    func run() -> Single<Repositories> {
        return Single<Repositories>.create(subscribe: { single in
            let disposable = Disposables.create()
            guard let request = self.request else {
//                single(.error(NSError()))
                return disposable
            }
            request.start()
                .subscribe(onSuccess: { json in
                    guard let repositories = Repositories.init(json: json) else {
//                        single(.error(NSError()))
                        return
                    }
                    single(.success(repositories))
                }, onError: { error in
//                    single(.error(error))
                })
                .disposed(by: self.bag)
            return disposable
        })
    }
}
