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

final class RepositoryData: BindableObject {

    let didChange: AnyPublisher<RepositoryData, Never>
    private let _didChange = PassthroughSubject<RepositoryData, Never>()

    private(set) var repositories: [Repository] = [] {
        didSet {
            // TODO: Do not want to use DispatchQueue.main here
            DispatchQueue.main.async {
                self._didChange.send(self)
            }
        }
    }

    init() {
        self.didChange = AnyPublisher(_didChange)
    }

    // TODO: Separate API access from here
    func search(query: String) {
        guard var components = URLComponents(string: "https://api.github.com/search/repositories") else {
            return
        }
        components.queryItems = [URLQueryItem(name: "q", value: query)]

        guard let url = components.url else {
            return
        }

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else {
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self?.repositories = try decoder.decode(Items<Repository>.self, from: data).items
            } catch {
                print(error)
            }
        }.resume()
    }
}

extension RepositoryData {

    private struct Items<T: Decodable>: Decodable {
        let items: [T]
    }
}
