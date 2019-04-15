//
//  FilePath.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 4/7/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import ObjectMapper

class Files: Mappable {
    var files: [File]!
    
    convenience init?(json: Data) {
        guard let jsonString = String(data: json, encoding: .utf8) else { return nil }
        self.init(JSONString: jsonString)
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        files <- map["data.repository.object.entries"]
    }
}

class File: Mappable {
    var name: String!
    var type: String!
    
    convenience init?(json: Data) {
        guard let jsonString = String(data: json, encoding: .utf8) else { return nil }
        self.init(JSONString: jsonString)
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        type <- map["type"]
    }
}
