//
//  ArticleListViewModel.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 2/23/21.
//

import Foundation

final class ArticleListViewModel: ObservableObject {
    @Injected var articleService: ArticleService

    @Published private(set) var articles: [Article] = []
    @Published private(set) var isFetching = false

    @MainActor
    func fetchArticles() async throws {
        isFetching = true
        defer { isFetching = false }

        articles = try await articleService.searchArticlesByKeyword("Tesla", page: 1)
    }
}
