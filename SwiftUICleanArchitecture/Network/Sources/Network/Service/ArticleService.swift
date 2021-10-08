//
//  ArticleConcurrencyUseCase.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/5/21.
//

import Foundation

public struct SearchArticleResult: Decodable {
    @Default.Empty public var articles: [Article]
    @Default.Zero public var totalResults: Int
}

public protocol ArticleService {
    func searchArticlesByKeyword(_ keyword: String, page: Int) async throws -> [Article]
}

actor DefaultArticleService: ArticleService {
    func searchArticlesByKeyword(_ keyword: String, page: Int) async throws -> [Article] {
        return try await ArticleAPI
            .searchArticles(keyword: keyword, page: page)
            .call(SearchArticleResult.self)
            .articles
    }
}
