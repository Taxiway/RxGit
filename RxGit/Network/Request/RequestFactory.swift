//
//  RequestFactory.swift
//  RxGit
//
//  Created by Hang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

protocol RequestFactory {
    var userTokenManager: UserTokenManager? { get set }
    func newRequest() -> GitRequest?
}

class RequestFactoryImpl: RequestFactory {
    static let sharedInstance = RequestFactoryImpl()
    var userTokenManager: UserTokenManager?

    func newRequest() -> GitRequest? {
        guard let manager = self.userTokenManager else { return nil }
        return GitRequestImpl(userTokenManager: manager)
    }
}
