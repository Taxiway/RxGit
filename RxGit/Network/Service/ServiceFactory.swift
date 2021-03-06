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
    func newRepositoriesService(requestFactory: RequestFactory, userTokenManager: UserTokenManager) -> RepositoriesService
    func newRepositorySearchService(requestFactory: RequestFactory, userTokenManager: UserTokenManager) -> RepositorySearchService
    func newRepositoryService(requestFactory: RequestFactory, userTokenManager: UserTokenManager, owner: String, name: String) -> RepositoryService
    func newRepositoryFilesService(requestFactory: RequestFactory, userTokenManager: UserTokenManager, owner: String, name: String) -> RepositoriesFilesService
}

class ServiceFactoryImpl: ServiceFactory {
    static let sharedInstance = ServiceFactoryImpl()

    func newLoginService(token: String, requestFactory: RequestFactory, userTokenManager: UserTokenManager) -> LoginService {
        return LoginServiceImpl(token: token, requestFactory: requestFactory, userTokenManager: userTokenManager)
    }

    func newRepositoriesService(requestFactory: RequestFactory, userTokenManager: UserTokenManager) -> RepositoriesService {
        return RepositoriesServiceImpl(requestFactory: requestFactory, userTokenManager: userTokenManager)
    }
    
    func newRepositorySearchService(requestFactory: RequestFactory, userTokenManager: UserTokenManager) -> RepositorySearchService {
        return RepositorySearchServiceImpl(requestFactory: requestFactory, userTokenManager: userTokenManager)
    }

    func newRepositoryService(requestFactory: RequestFactory, userTokenManager: UserTokenManager, owner: String, name: String) -> RepositoryService {
        return RepositoryServiceImpl(requestFactory: requestFactory, userTokenManager: userTokenManager, owner: owner, name: name)
    }

    func newRepositoryFilesService(requestFactory: RequestFactory, userTokenManager: UserTokenManager, owner: String, name: String) -> RepositoriesFilesService {
        return RepositoriesFilesServiceImpl(requestFactory: requestFactory, userTokenManager: userTokenManager, owner: owner, name: name)
    }
}
