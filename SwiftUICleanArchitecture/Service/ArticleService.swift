//
//  ArticleConcurrencyUseCase.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/5/21.
//

import Foundation

struct SearchArticleResult: Decodable {
    @Default.EmptyList var articles: [Article]
    @Default.Zero var totalResults: Int
}

protocol ArticleService {
    func findArticlesByKeyword(_ keyword: String, pageSize: Int, page: Int) async throws -> [Article]
}

actor DefaultArticleService: ArticleService {
    func findArticlesByKeyword(_ keyword: String, pageSize: Int, page: Int) async throws -> [Article] {
        return try await ArticleAPI
            .fetchArticles(keyword: keyword, pageSize: pageSize, page: page)
            .call(SearchArticleResult.self)
            .articles
    }
}
