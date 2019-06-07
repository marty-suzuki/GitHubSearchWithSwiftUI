//
//  Publisher.flatMapLatest.swift
//  GitHubSearchWithSwiftUI
//
//  Created by marty-suzuki on 2019/06/08.
//  Copyright © 2019 jp.marty-suzuki. All rights reserved.
//

import Combine

extension Publisher {

    /// - seealso: https://twitter.com/peres/status/1136132104020881408
    func flatMapLatest<T: Publisher>(_ transform: @escaping (Self.Output) -> T) -> Publishers.SwitchToLatest<T, Publishers.Map<Self, T>> where T.Failure == Self.Failure {
        map(transform).switchToLatest()
    }
}

extension Publisher {

    static func empty<Output, Failure>() -> AnyPublisher<Output, Failure> {
        return Publishers.Empty()
            .eraseToAnyPublisher()
    }

    static func just<Output>(_ output: Output) -> AnyPublisher<Output, Never> {
        return Publishers.Just(output)
            .eraseToAnyPublisher()
    }
}
