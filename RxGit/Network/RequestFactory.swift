//
//  RequestFactory.swift
//  RxGit
//
//  Created by Hang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

enum RequestType {
    case LoginRequest
}

protocol RequestFactory {
    func newRequest(_ type: RequestType) -> GitRequest
}

class RequestFactoryImpl: RequestFactory {
    func newRequest(_ type: RequestType) -> GitRequest {
        return GitRequestImpl()
    }
}
