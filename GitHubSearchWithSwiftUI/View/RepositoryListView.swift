//
//  RepositoryListView.swift
//  GitHubSearchWithSwiftUI
//
//  Created by marty-suzuki on 2019/06/05.
//  Copyright © 2019 jp.marty-suzuki. All rights reserved.
//

import SwiftUI

struct RepositoryListView : View {

    @EnvironmentObject private var viewModel: RepositoryListViewModel

    var body: some View {

        NavigationView {

            TextField(viewModel[\.text],
                      placeholder: Text("Search reposipories..."),
                      onCommit: { self.viewModel.search() })
                .frame(height: 40)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                .border(Color.gray, cornerRadius: 8)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

            List {

                viewModel.errorMessage.map(Text.init)?
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)

                ForEach(viewModel.repositories.identified(by: \.id)) { repository in
                     RepositoryView(repository: repository)
                }
            }
            .navigationBarTitle(Text("Search🔍"))
        }
    }
}
