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

final class RepositoryListViewModel: ObservableObject {
    typealias SearchRepositories = (String) -> AnyPublisher<Result<[Repository], ErrorResponse>, Never>

    private let _searchWithQuery = PassthroughSubject<String, Never>()
    private var cancellables: [AnyCancellable] = []

    @Published private(set) var repositories: [Repository] = []
    @Published private(set) var errorMessage: String? = nil
    @Published private(set) var isLoading = false
    var text: String = ""

    init<S: Scheduler>(searchRepositories: @escaping SearchRepositories = RepositoryAPI.search,
                       mainScheduler: S) {

        let searchTrigger = _searchWithQuery
            .filter { !$0.isEmpty }
            .debounce(for: .milliseconds(300), scheduler: mainScheduler)

        searchTrigger
            .map { _ in true }
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)

        let response = searchTrigger
            .flatMapLatest { query -> AnyPublisher<([Repository], String?), Never> in
                searchRepositories(query)
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
            .receive(on: mainScheduler)
            .share()

        response
            .map { _ in false }
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)

        response
            .map { $0.0 }
            .assign(to: \.repositories, on: self)
            .store(in: &cancellables)

        response
            .map { $0.1 }
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }

    func search() {
        _searchWithQuery.send(text)
    }
}
