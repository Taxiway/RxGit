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
    case Repositories = "query { viewer { repositories(last: 100) { nodes { name description nameWithOwner } } } }"
    case RepositorySearch = "query { search(query: \"%@\", type: REPOSITORY, first: 10) { repositoryCount nodes { ... on Repository { name nameWithOwner description primaryLanguage { name } } } } }"
    case Repository = "query { repository(owner: \"%@\", name: \"%@\") { name nameWithOwner description languages(last: 100) { totalCount totalSize nodes { name color } edges { size } } } }"
    case CodeDirectory = "query { repository(owner:\"%@\" name:\"%@\") { object(expression:\"master:%@\") { ... on Tree { entries { name type } } } } }"
}
