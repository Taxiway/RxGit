//
//  RepositoryService.swift
//  RxGit
//
//  Created by Hang on 3/11/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift

protocol RepositoryService {
    func run() -> Single<Repository>
}

class RepositoryServiceImpl: RepositoryService {
    var requestFactory: RequestFactory
    var request: GitRequest?
    var bag: DisposeBag
    var userTokenManager: UserTokenManager
    var owner: String
    var name: String
    
    init(requestFactory: RequestFactory, userTokenManager: UserTokenManager, owner: String, name: String) {
        self.requestFactory = requestFactory
        self.userTokenManager = userTokenManager
        self.request = requestFactory.newRequest()
        self.bag = DisposeBag()
        self.owner = owner
        self.name = name
        setupRequest()
    }
    
    func setupRequest() {
        self.request?.method = .post
        self.request?.queryJSON = ["query": String(format: JSONQueries.Repository.rawValue, owner, name)]
    }
    
    func run() -> Single<Repository> {
        return Single<Repository>.create(subscribe: { single in
            let disposable = Disposables.create()
            guard let request = self.request else {
//                single(.error(NSError()))
                return disposable
            }
            request.start()
                .subscribe(onSuccess: { json in
                    guard let repository = Repository.init(json: json) else {
//                        single(.error(NSError()))
                        return
                    }
                    single(.success(repository))
                }, onError: { error in
//                    single(.error(error))
                })
                .disposed(by: self.bag)
            return disposable
        })
    }
}
