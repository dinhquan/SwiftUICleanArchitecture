//
//  ArticleListView.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 2/23/21.
//

import SwiftUI
import Introspect
import Combine

struct ArticleListView: View {
    @EnvironmentObject var store: AppStore
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    TextField("Input a keyword", text: $searchText, onCommit: {
                        store.dispatch(fetchArticle(keyword: searchText, page: 1))
//                        store.dispatch(.article(.fetchArticle(keyword: searchText, page: 1)))
                        })
                        .textFieldStyle(.roundedBorder)
                        .padding(.init(top: 10, leading: 20, bottom: 0, trailing: 20))
                }
                List {
                    ForEach(store.state.articles) { article in
                        NavigationLink(destination: ArticleDetailView(viewModel: ArticleDetailViewModel(article: article))) {
                            ArticleListRow(article: article)
                        }
                    }
//                    if viewModel.isFetching {
//                        VStack(alignment: .center) {
//                            HStack {
//                                Spacer()
//                            }
//                            ProgressView()
//                        }
//                    }
                }
                .listStyle(PlainListStyle())
            }.navigationBarTitle("Articles")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct ArticleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArticleListView(viewModel: .init())
//    }
//}
