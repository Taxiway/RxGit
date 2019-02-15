//
//  Repositories.swift
//  RxGit
//
//  Created by Hang on 2/15/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import ObjectMapper

class Repositories: Mappable {
    var repositories: [Repository]!

    convenience init?(json: Data) {
        guard let jsonString = String(data: json, encoding: .utf8) else { return nil }
        self.init(JSONString: jsonString)
    }

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        repositories <- map["data.viewer.repositories.nodes"]
    }
}
