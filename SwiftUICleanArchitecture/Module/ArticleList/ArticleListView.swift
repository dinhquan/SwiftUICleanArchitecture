//
//  ArticleListView.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 2/23/21.
//

import SwiftUI
import Combine

struct ArticleListView: View {
    @ObservedObject var viewModel: ArticleListViewModel
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    TextField("Input a keyword", text: $searchText, onCommit: {
                        viewModel.searchArticles(keyword: searchText)
                        })
                        .textFieldStyle(.roundedBorder)
                        .padding(.init(top: 10, leading: 20, bottom: 0, trailing: 20))
                }
                List {
                    if viewModel.isLoading {
                        VStack(alignment: .center) {
                            HStack {
                                Spacer()
                            }
                            ProgressView()
                        }
                    }
                    ForEach(viewModel.articles) { article in
                        NavigationLink(destination: ArticleDetailView(viewModel: ArticleDetailViewModel(article: article))) {
                            ArticleListRow(article: article)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }.navigationBarTitle("Articles")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView(viewModel: .init())
    }
}
