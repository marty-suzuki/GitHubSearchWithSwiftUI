//
//  Repository.swift
//  GitHubSearchWithSwiftUI
//
//  Created by marty-suzuki on 2019/06/05.
//  Copyright © 2019 jp.marty-suzuki. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    let name: String
    let description: String?
    let stargazers: Count
    let url: URL
}

extension Repository {

    struct Count: Decodable {
        let totalCount: Int
    }
}
