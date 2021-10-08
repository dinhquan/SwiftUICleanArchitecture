//
//  MockArticleService.swift
//  SwiftUICleanArchitectureTests
//
//  Created by Quan on 10/6/21.
//

import Foundation
import Network

struct MockArticleService: ArticleService {
    func searchArticlesByKeyword(_ keyword: String, page: Int) async throws -> [Article] {
        MockLoader.load("searchArticles.json", ofType: SearchArticleResult.self)!.articles
    }
}
