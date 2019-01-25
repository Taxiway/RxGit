//
//  UserTokenManager.swift
//  RxGit
//
//  Created by Hang on 1/25/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

protocol UserTokenManager {
    var userToken: String { get set }
}

class UserTokenManagerImpl: UserTokenManager {
    var userToken: String

    init() {
        // TODO: Need to read the user token from keychain
        self.userToken = ""
    }
}
