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
    var queryJSON: [String : String] { get set }
    var method: HTTPMethod { get set }
}

class GitRequestImpl: GitRequest {
    var queryJSON = ["query" : "query{viewer{login}}"]
    var method: HTTPMethod = .post
    var baseURL: URL = URL(string: "https://api.github.com/graphql")!

    func start() -> Single<String> {
        // Use the following code to test the Git login API
        /*
        let headers: HTTPHeaders = [
            "Authorization": "bearer " + "fcc386db559023962a0c291e9c74f529cf90804a",
            ]
        AF.request(self.baseURL, method: self.method, parameters: self.queryJSON, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(completionHandler: { response in
                print(response)
            })
         */
        return Single<String>.create(subscribe: { single in
            let headers: HTTPHeaders = [
                "Authorization": "bearer " + "fcc386db559023962a0c291e9c74f529cf90804a",
                ]
            AF.request(self.baseURL, method: self.method, parameters: self.queryJSON, encoding: JSONEncoding.default, headers: headers)
                .responseJSON(completionHandler: { response in
                    print(response)
                    single(.success("a"))
                })
            return Disposables.create()
        })
    }
}
