//
//  ArticleListViewModel.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 2/23/21.
//

import Foundation
import Combine
import UIKit

final class ArticleListViewModel: ObservableObject {
    @ReduxStore var store: AppStore

    @Published private(set) var isLoading = false
    @Published private(set) var articles: [Article] = []
    
    func searchArticles(keyword: String) {
        store.dispatch(.article(.fetchArticle(keyword: keyword, page: 1)))
    }
    
    init() {
        store.$state.map(\.articles.value).assign(to: &$articles)
        store.$state.map(\.articles.isLoading).assign(to: &$isLoading)
    }
}

