//
//  ServiceFactory.swift
//  RxGit
//
//  Created by Hang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

enum ServiceType {
    case LoginService
}

protocol ServiceFactory {
    func newService(_ type: ServiceType) -> GitService
}

class ServiceFactoryImpl: ServiceFactory {
    func newService(_ type: ServiceType) -> GitService {
        return GitServiceImpl()
    }
}
