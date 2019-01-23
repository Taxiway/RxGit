//
//  User.swift
//  RxGit
//
//  Created by Hang on 1/23/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String
    var token: String

    init(name: String, token: String) {
        self.name = name
        self.token = token
        super.init()
    }

    convenience init?(json: String) {
        if json == "" {
            return nil
        } else {
            self.init(name: "a", token: "b")
        }
    }
}
