//
//  RepositoryListViewModel.swift
//  GitHubSearchWithSwiftUI
//
//  Created by marty-suzuki on 2019/06/06.
//  Copyright © 2019 jp.marty-suzuki. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

final class RepositoryListViewModel: BindableObject {

    let didChange: AnyPublisher<RepositoryListViewModel, Never>

    private let _searchWithQuery = PassthroughSubject<String, Never>()
    private var cancellable: AnyCancellable?

    private(set) var repositories: [Repository] = []
    private(set) var errorMessage: String?
    var text: String = ""

    init() {
        let _didChange = PassthroughSubject<RepositoryListViewModel, Never>()
        self.didChange = _didChange.eraseToAnyPublisher()

        let sink = _searchWithQuery
            .flatMapLatest { query -> AnyPublisher<([Repository], String?), Never> in
                RepositoryAPI.search(query: query)
                    .map { result -> ([Repository], String?) in
                        switch result {
                        case let .success(repositories):
                            return (repositories, nil)
                        case let .failure(response):
                            return ([], response.message)
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] repositories, message in
                // TODO: Do not want to use DispatchQueue.main here
                DispatchQueue.main.async {
                    guard let me = self else {
                        return
                    }
                    me.repositories = repositories
                    me.errorMessage = message
                    _didChange.send(me)
                }
            }

        self.cancellable = AnyCancellable(sink)
    }

    func search() {
        if text.isEmpty {
            return
        }
        _searchWithQuery.send(text)
    }
}
