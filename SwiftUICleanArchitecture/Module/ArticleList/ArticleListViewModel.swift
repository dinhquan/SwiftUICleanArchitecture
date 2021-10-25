//
//  ArticleListViewModel.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 2/23/21.
//

import Foundation
import Combine

final class ArticleListViewModel: ObservableObject {
    @Injected var articleService: ArticleService

    @Published private(set) var articles: [Article] = []
    @Published private(set) var isFetching = false

    private var disposables = Set<AnyCancellable>()

    func fetchArticles() {
        isFetching = true

        articleService.searchArticlesByKeyword("Tesla", page: 1)
            .replaceError(with: [])
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isFetching = false
            })
            .assign(to: \ArticleListViewModel.articles, on: self)
            .store(in: &disposables)
    }
}
