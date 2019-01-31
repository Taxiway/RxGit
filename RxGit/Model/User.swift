//
//  User.swift
//  RxGit
//
//  Created by Hang on 1/23/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import ObjectMapper

class User: Mappable {
    static let jsonPathName = ["data", "viewer", "login"]
    var name: String!
    var token: String!

    convenience init?(json: Data) {
        guard let jsonString = String(data: json, encoding: .utf8) else { return nil }
        self.init(JSONString: jsonString)
    }

    var description: String {
        get {
            return "User name: \(String(describing: self.name)), token: \(String(describing: self.token))"
        }
    }

    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        name <- map["data.viewer.login"]
    }
}
