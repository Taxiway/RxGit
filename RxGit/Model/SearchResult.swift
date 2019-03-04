//
//  SearchResult.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 2/24/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchResults: Mappable {
    var repositories: [Repository]!
    
    convenience init?(json: Data) {
        guard let jsonString = String(data: json, encoding: .utf8) else { return nil }
        self.init(JSONString: jsonString)
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        repositories <- map["data.search.nodes"]
    }
}
