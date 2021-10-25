//
//  ArticleConcurrencyUseCase.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/5/21.
//

import Foundation
import Combine

struct SearchArticleResult: Decodable {
    @Default.EmptyList var articles: [Article]
    @Default.Zero var totalResults: Int
}

protocol ArticleService {
    func searchArticlesByKeyword(_ keyword: String, page: Int) -> AnyPublisher<[Article], Error>
}

struct DefaultArticleService: ArticleService {
    func searchArticlesByKeyword(_ keyword: String, page: Int) -> AnyPublisher<[Article], Error> {
        return ArticleAPI
            .searchArticles(keyword: keyword, page: page)
            .call(SearchArticleResult.self)
            .map(\.articles)
            .eraseToAnyPublisher()
    }
}
