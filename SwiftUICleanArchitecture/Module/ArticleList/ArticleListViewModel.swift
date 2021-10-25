//
//  ArticleListViewModel.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 2/23/21.
//

import Foundation
import Combine

private protocol Input {
    func searchArticles(keyword: String)
    func loadMore()
}

private protocol Output {
    var articles: [Article] { get }
    var isFetching: Bool { get }
}

final class ArticleListViewModel: ObservableObject, Input, Output {
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

    private func fetchArticles() {
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
