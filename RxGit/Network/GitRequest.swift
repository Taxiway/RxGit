//
//  GitRequest.swift
//  RxGit
//
//  Created by Hang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift

protocol GitRequest {
    func start() -> Single<String>
}

class GitRequestImpl: GitRequest {
    func start() -> Single<String> {
        return Single<String>.create(subscribe: { single in
            single(.success("a"))
            return Disposables.create()
        })
    }
}
