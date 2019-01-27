//
//  GitRequest.swift
//  RxGit
//
//  Created by Hang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

protocol GitRequest {
    func start() -> Single<Data>
    var queryJSON: [String: String] { get set }
    var method: HTTPMethod { get set }
}

class GitRequestImpl: GitRequest {
    var queryJSON = [String: String]()
    var method: HTTPMethod = .post
    var baseURL: URL = URL(string: "https://api.github.com/graphql")!
    var userTokenManager: UserTokenManager
    var headers: HTTPHeaders {
        get {
            return ["Authorization": "bearer " + self.userTokenManager.userToken]
        }
    }

    func start() -> Single<Data> {
        return Single<Data>.create(subscribe: { [unowned self] single in
            let disposable = Disposables.create()
            AF.request(self.baseURL, method: self.method, parameters: self.queryJSON, encoding: JSONEncoding.default, headers: self.headers)
                .responseJSON(completionHandler: { response in
                    guard let data = response.data else {
                        single(.error(NSError()))
                        return
                    }
                    single(.success(data))
                })
            return disposable
        })
    }

    init(userTokenManager: UserTokenManager) {
        self.userTokenManager = userTokenManager
    }
}
