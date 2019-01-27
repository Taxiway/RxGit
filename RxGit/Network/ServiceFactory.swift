//
//  ServiceFactory.swift
//  RxGit
//
//  Created by Hang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

protocol ServiceFactory {
    func newLoginService(token: String, requestFactory: RequestFactory, userTokenManager: UserTokenManager) -> LoginService
}

class ServiceFactoryImpl: ServiceFactory {
    static let sharedInstance = ServiceFactoryImpl()

    func newLoginService(token: String, requestFactory: RequestFactory, userTokenManager: UserTokenManager) -> LoginService {
        return LoginServiceImpl(token: token, requestFactory: requestFactory, userTokenManager: userTokenManager)
    }
}
