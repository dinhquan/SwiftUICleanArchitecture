//
//  ArticleConcurrencyUseCase.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/5/21.
//

import Foundation

protocol ArticleConcurrencyUseCase {
    func findArticlesByKeyword(_ keyword: String, pageSize: Int, page: Int) async throws -> [Article]
}

struct DefaultArticleConcurrencyUseCase: ArticleConcurrencyUseCase {
    func findArticlesByKeyword(_ keyword: String, pageSize: Int, page: Int) async throws -> [Article] {
        let encodedQ = keyword.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) ?? ""
        let url = "\(Config.current.baseUrl)/everything?q=\(encodedQ)&from=2021-10-01&sortBy=publishedAt&apiKey=\(Config.current.apiKey)&pageSize=\(pageSize)&page=\(page)"
        return try await Networker.request(url)
            .responseDecodable(SearchArticleResult.self)
            .articles
    }
}
