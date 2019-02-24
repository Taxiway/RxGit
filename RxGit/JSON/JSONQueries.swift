//
//  JSONQueries.swift
//  RxGit
//
//  Created by Hang on 1/27/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

enum JSONQueries: String {
    case Login = "query { viewer { login } }"
    case Repositories = "query { viewer { repositories(last: 100) { nodes { name description } } } }"
    case RepositorySearch = "query { search(query: \"%@\", type: REPOSITORY, first: 10) { repositoryCount nodes { ... on Repository { name nameWithOwner description primaryLanguage { name } } } } }"
}
