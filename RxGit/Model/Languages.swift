//
//  Languages.swift
//  RxGit
//
//  Created by Hang on 3/11/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import ObjectMapper

class SizeArrayTransformType: TransformType {
    
    public typealias Object = [Int]
    public typealias JSON = [[String : Any]]
    
    func transformToJSON(_ value: Object?) -> JSON? {
        if let sizes = value {
            var result = JSON()
            for size in sizes {
                result.append(["size": size])
            }
            return result
        }
        return nil
    }
    
    func transformFromJSON(_ value: Any?) -> Object? {
        if let sizes = value as? [[String: Any]] {
            var resultSizes = [Int]()
            for size in sizes {
                if let sizeInt = size["size"] as? Int {
                    resultSizes.append(sizeInt)
                }
            }
            return resultSizes
        }
        return nil
    }
}

class Languages: Mappable {
    var totalCount: Int!
    var totalSize: Int!
    var sizes: [Int]!
    var languages: [Language]!

    convenience init?(json: Data) {
        guard let jsonString = String(data: json, encoding: .utf8) else { return nil }
        self.init(JSONString: jsonString)
    }

    init() {
        totalCount = 0
        totalSize = 0
        sizes = [Int]()
        languages = [Language]()
    }

    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        totalCount <- map["totalCount"]
        totalSize <- map["totalSize"]
        sizes <- (map["edges"], SizeArrayTransformType())
        languages <- map["nodes"]
    }
}
