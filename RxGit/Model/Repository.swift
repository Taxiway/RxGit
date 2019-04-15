//
//  Repository.swift
//  RxGit
//
//  Created by Hang on 2/15/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import ObjectMapper

class Repository: Mappable {
    var name: String!
    var description: String!
    var nameWithOwner: String!
    var languages: Languages!
    var owner: String {
        return nameWithOwner.components(separatedBy: "/")[0]
    }

    convenience init?(json: Data) {
        guard let jsonString = String(data: json, encoding: .utf8) else { return nil }
        self.init(JSONString: jsonString)
    }

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        nameWithOwner <- map["nameWithOwner"]
        description <- map["description"]
        languages <- map["languages"]
        if name == nil {
            name <- map["data.repository.name"]
            nameWithOwner <- map["data.repository.nameWithOwner"]
            description <- map["data.repository.description"]
            languages <- map["data.repository.languages"]
        }
    }
}
