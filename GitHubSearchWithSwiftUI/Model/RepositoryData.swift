//
//  RepositoryData.swift
//  GitHubSearchWithSwiftUI
//
//  Created by marty-suzuki on 2019/06/05.
//  Copyright © 2019 jp.marty-suzuki. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

extension JSONDecoder: TopLevelDecoder {}

final class RepositoryData: BindableObject {

    let didChange: AnyPublisher<RepositoryData, Never>
    private let _didChange = PassthroughSubject<RepositoryData, Never>()

    private let _searchWithQuery = PassthroughSubject<String, Never>()
    private lazy var repositoriesAssign = Subscribers.Assign(object: self, keyPath: \.repositories)

    private(set) var repositories: [Repository] = [] {
        didSet {
            // TODO: Do not want to use DispatchQueue.main here
            DispatchQueue.main.async {
                self._didChange.send(self)
            }
        }
    }

    deinit {
        repositoriesAssign.cancel()
    }

    init() {
        self.didChange = _didChange.eraseToAnyPublisher()

        _searchWithQuery
            .flatMap { query -> AnyPublisher<[Repository], Never> in
                RepositoryAPI.search(query: query)
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
            }
            .receive(subscriber: repositoriesAssign)
    }
    
    func search(query: String) {
        _searchWithQuery.send(query)
    }
}
