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
                guard var components = URLComponents(string: "https://api.github.com/search/repositories") else {
                    return Publishers.Empty<[Repository], Never>().eraseToAnyPublisher()
                }
                components.queryItems = [URLQueryItem(name: "q", value: query)]

                guard let url = components.url else {
                    return Publishers.Empty<[Repository], Never>().eraseToAnyPublisher()
                }

                var request = URLRequest(url: url)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return URLSession.shared.combine.send(request: request)
                    .decode(type: ItemResponse<Repository>.self, decoder: decoder)
                    .map { $0.items }
                    .replaceError(with: [])
                    .handleEvents(receiveOutput: { print($0) },
                                  receiveCompletion: { print($0)})
                    .eraseToAnyPublisher()
            }
            .receive(subscriber: repositoriesAssign)
    }

    // TODO: Separate API access from here
    func search(query: String) {
        _searchWithQuery.send(query)
    }
}
