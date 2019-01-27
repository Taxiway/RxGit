//
//  User.swift
//  RxGit
//
//  Created by Hang on 1/23/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

class User: NSObject {
    static let jsonPathName = ["data", "viewer", "login"]
    var name: String
    var token: String

    convenience init(name: String) {
        self.init(name: name, token: "")
    }

    init(name: String, token: String) {
        self.name = name
        self.token = token
        super.init()
    }

    convenience init?(json: Data) {
        do {
            let parsedData = try JSONSerialization.jsonObject(with: json, options: .allowFragments)
            guard let dict = parsedData as? Dictionary<String, Any> else { return nil }
            guard let login = JSONParser.sharedInstance.parseString(json: dict, path: User.jsonPathName) else { return nil }
            self.init(name: login)
        }
        catch {
            return nil
        }
    }

    override var description: String {
        get {
            return "User name: \(self.name), token: \(self.token)"
        }
    }
}
