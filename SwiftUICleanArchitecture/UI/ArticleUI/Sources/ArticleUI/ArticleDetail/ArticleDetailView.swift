//
//  ArticleDetailView.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/7/21.
//

import SwiftUI
import struct Network.Article

struct ArticleDetailView: View {
    @ObservedObject var viewModel: ArticleDetailViewModel

    var body: some View {
        Text(viewModel.article.title)
    }
}

struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetailView(viewModel: .init(article: Article()))
    }
}
