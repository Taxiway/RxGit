//
//  RepositorySearchService.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 2/24/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift

protocol RepositorySearchService {
    func run() -> Single<SearchResults>
}

class RepositorySearchServiceImpl: RepositorySearchService {
    var requestFactory: RequestFactory
    var request: GitRequest?
    var bag: DisposeBag
    var userTokenManager: UserTokenManager
    var queryString: String
    
    init(requestFactory: RequestFactory, userTokenManager: UserTokenManager, queryString: String?) {
        self.requestFactory = requestFactory
        self.userTokenManager = userTokenManager
        self.request = requestFactory.newRequest()
        self.bag = DisposeBag()
        self.queryString = queryString ?? ""
        setupRequest()
    }
    
    func setupRequest() {
        self.request?.method = .post
        self.request?.queryJSON = ["query": String(format: JSONQueries.RepositorySearch.rawValue, self.queryString)]
    }
    
    func run() -> Single<SearchResults> {
        return Single<SearchResults>.create(subscribe: { single in
            let disposable = Disposables.create()
            guard let request = self.request else {
                single(.error(NSError()))
                return disposable
            }
            request.start()
                .subscribe(onSuccess: { json in
                    guard let repositories = SearchResults.init(json: json) else {
                        single(.error(NSError()))
                        return
                    }
                    single(.success(repositories))
                }, onError: { error in
                    single(.error(error))
                })
                .disposed(by: self.bag)
            return disposable
        })
    }
}

