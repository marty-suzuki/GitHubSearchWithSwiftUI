//
//  ErrorResponse.swift
//  GitHubSearchWithSwiftUI
//
//  Created by marty-suzuki on 2019/06/08.
//  Copyright © 2019 jp.marty-suzuki. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable, Error {
    let message: String
}
