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
            List(viewModel.articles) { article in
                ArticleListRow(article: article)
            }
        }
        .onAppear(perform: {
            self.viewModel.onAppear.send()
        })
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView(viewModel: .init())
    }
}

extension Article: Identifiable {
    var id: String {
        title
    }
}
