//
//  Language.swift
//  RxGit
//
//  Created by Hang on 3/11/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import ObjectMapper

class Language: Mappable {
    var name: String!
    var color: String!

    convenience init?(json: Data) {
        guard let jsonString = String(data: json, encoding: .utf8) else { return nil }
        self.init(JSONString: jsonString)
    }

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        name <- map["name"]
        color <- map["color"]
    }
}
