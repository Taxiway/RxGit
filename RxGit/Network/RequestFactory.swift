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
    var userTokenManager: UserTokenManager? { get set }
    func newRequest(_ type: RequestType) -> GitRequest?
}

class RequestFactoryImpl: RequestFactory {
    static let sharedInstance = RequestFactoryImpl()
    var userTokenManager: UserTokenManager?

    func newRequest(_ type: RequestType) -> GitRequest? {
        guard let manager = self.userTokenManager else { return nil }
        return GitRequestImpl(userTokenManager: manager)
    }
}
