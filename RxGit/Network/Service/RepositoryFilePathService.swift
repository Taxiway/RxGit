//
//  RepositoryFilePathService.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 4/7/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift

protocol RepositoriesFilesService {
    func run(queryString: String?) -> Single<Files>
}

class RepositoriesFilesServiceImpl: RepositoriesFilesService {
    var requestFactory: RequestFactory
    var request: GitRequest?
    var bag: DisposeBag
    var userTokenManager: UserTokenManager
    var queryString: String
    var owner: String
    var name: String
    
    init(requestFactory: RequestFactory, userTokenManager: UserTokenManager, owner: String, name: String) {
        self.requestFactory = requestFactory
        self.userTokenManager = userTokenManager
        self.request = requestFactory.newRequest()
        self.bag = DisposeBag()
        self.queryString = ""
        self.owner = owner
        self.name = name
        self.request?.method = .post
    }
    
    func setupRequest() {
        self.request?.queryJSON = ["query": String(format: JSONQueries.CodeDirectory.rawValue, owner, name, queryString)]
    }
    
    func run(queryString: String?) -> Single<Files> {
        self.queryString = queryString ?? ""
        self.setupRequest()
        return Single<Files>.create(subscribe: { single in
            let disposable = Disposables.create()
            guard let request = self.request else {
//                single(.error(NSError()))
                return disposable
            }
            request.start()
                .subscribe(onSuccess: { json in
                    guard let files = Files.init(json: json) else {
//                        single(.error(NSError()))
                        return
                    }
                    single(.success(files))
                }, onError: { error in
//                    single(.error(error))
                })
                .disposed(by: self.bag)
            return disposable
        })
    }
}
