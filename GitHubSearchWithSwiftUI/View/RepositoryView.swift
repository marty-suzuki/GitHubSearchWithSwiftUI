//
//  RepositoryView.swift
//  GitHubSearchWithSwiftUI
//
//  Created by marty-suzuki on 2019/06/05.
//  Copyright © 2019 jp.marty-suzuki. All rights reserved.
//

import SwiftUI

struct RepositoryView : View {

    let repository: Repository

    var body: some View {
        
        VStack(alignment: .leading) {

            HStack {
                Image(systemName: "doc.text")
                Text(repository.name)
                    .bold()
            }

            // Show text if description exists
            repository.description.map(Text.init)

            HStack {
                Image(systemName: "star")
                Text("\(repository.stargazers.totalCount)")
            }
        }
    }
}

#if DEBUG
struct RepositoryView_Previews : PreviewProvider {
    static var previews: some View {
        RepositoryView(repository: Repository(name: "Repository Name",
                                              description: "Hoge",
                                              stargazers: .init(totalCount: 100),
                                              url: URL(string: "https://github.com")!))
    }
}
#endif
