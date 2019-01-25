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

    convenience init?(json: Data) {
        do {
            let parsedData = try JSONSerialization.jsonObject(with: json, options: .allowFragments)
            var dict = parsedData as? Dictionary<String, Any>
            dict = dict!["data"] as? Dictionary<String, Any>
            dict = dict!["viewer"] as? Dictionary<String, Any>
            let login = dict!["login"] as? String
            print(login!)
            self.init(name: login!, token: "b")
        }
        catch {
            return nil
        }
    }
}
