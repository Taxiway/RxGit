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

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        nameWithOwner <- map["nameWithOwner"]
        description <- map["description"]
    }
}
