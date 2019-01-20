//
//  GitService.swift
//  RxGit
//
//  Created by Hang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift

public typealias JSONDictionary = [String: Any]

protocol GitService {
    func run() -> Single<JSONDictionary>
}

class GitServiceImpl: GitService {
    func run() -> Single<JSONDictionary> {
        return Single<JSONDictionary>.create(subscribe: { single in
            single(.success(["a" : 1]))
            return Disposables.create()
        })
    }
}
