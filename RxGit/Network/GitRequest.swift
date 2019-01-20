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
    func start() -> Single<String>
    var queryJSON: JSONDictionary { get set }
    var method: HTTPMethod { get set }
}

class GitRequestImpl: GitRequest {
    var queryJSON: JSONDictionary = [:]
    var method: HTTPMethod = .get
    var baseURL: URL = URL(string: "https://api.github.com/graphql")!

    func start() -> Single<String> {
        return Single<String>.create(subscribe: { single in
            AF.request(self.baseURL, method: self.method, parameters: self.queryJSON)
                .responseJSON(completionHandler: { response in
                    single(.success("a"))
                })
            return Disposables.create()
        })
    }
}
