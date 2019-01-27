//
//  JSONParser.swift
//  RxGit
//
//  Created by Hang on 1/27/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

class JSONParser: NSObject {
    static let sharedInstance = JSONParser()

    func parseString(json: Dictionary<String, Any>, path: [String]) -> String? {
        var root: Any = json
        for key in path {
            guard let rootJson = root as? Dictionary<String, Any> else { return nil }
            guard let child = rootJson[key] else { return nil }
            root = child
        }
        guard let rootString = root as? String else { return nil }
        return rootString
    }
}
