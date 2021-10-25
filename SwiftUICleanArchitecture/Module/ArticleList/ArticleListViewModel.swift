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

    private var currentPage = 1
    private var keyword = ""
    private var disposables = Set<AnyCancellable>()

    func searchArticles(keyword: String) {
        currentPage = 1
        self.keyword = keyword
        fetchArticles()
    }

    func loadMore() {
        currentPage += 1
        fetchArticles()
    }

    func fetchArticles() {
        isFetching = true
        articleService.searchArticlesByKeyword(keyword, page: currentPage)
            .replaceError(with: [])
            .sink(receiveValue: { [weak self] articles in
                self?.articles.append(contentsOf: articles)
                self?.isFetching = false
            })
            .store(in: &disposables)
    }
}
