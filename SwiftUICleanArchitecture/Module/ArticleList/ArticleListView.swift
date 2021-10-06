//
//  ArticleListView.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 2/23/21.
//

import SwiftUI

struct ArticleListView: View {
    @ObservedObject var viewModel: ArticleListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.articles) { article in
                    ArticleListRow(article: article)
                }
                if viewModel.isFetching {
                    ProgressView()
                }
                Button("Load Articles") {
                    Task {
                        try? await viewModel.fetchArticles()
                    }
                }
            }
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView(viewModel: .init())
    }
}
