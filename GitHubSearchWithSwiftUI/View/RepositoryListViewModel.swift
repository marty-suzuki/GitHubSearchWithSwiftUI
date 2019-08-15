//
//  RepositoryListViewModel.swift
//  GitHubSearchWithSwiftUI
//
//  Created by marty-suzuki on 2019/06/06.
//  Copyright © 2019 jp.marty-suzuki. All rights reserved.
//

import Combine
import Foundation
import Ricemill
import SwiftUI

final class RepositoryListViewModel: Machine<RepositoryListViewModel.Resolver> {
    typealias Output = Store

    final class Input: BindableInputType {
        let search = PassthroughSubject<Void, Never>()
        @Published var text: String = ""
    }

    final class Store: StoredOutputType {
        @Published var repositories: [Repository] = []
        @Published var errorMessage: String? = nil
        @Published var isLoading = false
        @Published fileprivate var query: String = ""
    }

    struct Extra: ExtraType {
        typealias SearchRepositories = (String) -> AnyPublisher<Result<[Repository], ErrorResponse>, Never>
        let searchRepositories: SearchRepositories
        let mainScheduler: AnyScheduler<DispatchQueue.SchedulerTimeType, DispatchQueue.SchedulerOptions>
    }

    enum Resolver: ResolverType {

        static func polish(input: Publishing<Input>,
                           store: Store,
                           extra: Extra) -> Polished<Output> {

            var cancellables: [AnyCancellable] = []

            let searchTrigger = input.search
                .flatMap { _ in Just(store.query) }
                .filter { !$0.isEmpty }
                .debounce(for: .milliseconds(300), scheduler: extra.mainScheduler)

            searchTrigger
                .map { _ in true }
                .assign(to: \.isLoading, on: store)
                .store(in: &cancellables)

            let response = searchTrigger
                .flatMapLatest { query -> AnyPublisher<([Repository], String?), Never> in
                    extra.searchRepositories(query)
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
                .receive(on: extra.mainScheduler)
                .share()

            response
                .map { _ in false }
                .assign(to: \.isLoading, on: store)
                .store(in: &cancellables)

            response
                .map { $0.0 }
                .assign(to: \.repositories, on: store)
                .store(in: &cancellables)

            response
                .map { $0.1 }
                .assign(to: \.errorMessage, on: store)
                .store(in: &cancellables)

            input.$text
                .assign(to: \.query, on: store)
                .store(in: &cancellables)

            return Polished(cancellables: cancellables)
        }
    }

    static func make(extra: Extra) -> RepositoryListViewModel {
        RepositoryListViewModel(input: Input(), store: Store(), extra: extra)
    }
}
