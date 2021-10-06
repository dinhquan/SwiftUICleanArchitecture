//
//  ArticleListViewModel.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 2/23/21.
//

import Foundation

@MainActor final class ArticleListViewModel: ObservableObject {
    @Injected var articleService: ArticleService

    @Published private(set) var articles: [Article] = []
    @Published private(set) var isFetching = false

    func fetchArticles() async throws {
        isFetching = true
        defer { isFetching = false }

        articles = try await articleService.findArticlesByKeyword("Tesla", pageSize: 20, page: 1)
    }
}
