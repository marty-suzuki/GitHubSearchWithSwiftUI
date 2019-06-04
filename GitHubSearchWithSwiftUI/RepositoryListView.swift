//
//  RepositoryListView.swift
//  GitHubSearchWithSwiftUI
//
//  Created by marty-suzuki on 2019/06/05.
//  Copyright © 2019 jp.marty-suzuki. All rights reserved.
//

import SwiftUI

struct RepositoryListView : View {

    @State private var text: String = ""

    var body: some View {

        NavigationView {

            TextField($text, placeholder: Text("Search reposipories..."), onCommit: { print(self.text) })
                .frame(height: 40)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                .border(Color.gray, cornerRadius: 8)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

            List {
                 RepositoryView(repository: Repository(name: "Repository Name",
                                                      description: "Hoge",
                                                      stargazers: .init(totalCount: 100),
                                                      url: URL(string: "https://github.com")!))
            }
            .navigationBarTitle(Text("Search🔍"))
        }
    }
}

#if DEBUG
struct RepositoryListView_Previews : PreviewProvider {
    static var previews: some View {
        RepositoryListView()
    }
}
#endif
