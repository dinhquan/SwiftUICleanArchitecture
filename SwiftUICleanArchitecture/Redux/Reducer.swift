//
//  Reducer.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 11/3/21.
//

import Foundation
import Combine

enum ArticleAction {
    case fetchArticle(keyword: String, page: Int)
    case fetchArticleSuccess(articles: [Article])
    case fetchArticleFailure(error: Error)
}

let articleReducer: Reducer<AppState, AppAction, Environment> = { state, action, env in
    guard case let .article(articleAction) = action else { return Empty().eraseToAnyPublisher() }
    switch articleAction {
    case let .fetchArticle(keyword, page):
        return env.articleService.searchArticlesByKeyword(keyword, page: page)
            .map { .article(.fetchArticleSuccess(articles: $0)) }
            .catch { Just(.article(.fetchArticleFailure(error: $0))).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case let .fetchArticleSuccess(articles):
        state.articles = articles
    case let .fetchArticleFailure(error):
        print("Failed to load article with error \(error.localizedDescription)")
    }
    return Empty().eraseToAnyPublisher()
}
