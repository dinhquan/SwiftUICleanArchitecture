//
//  Reducer.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 11/3/21.
//

import Foundation
import Combine

let articleReducer: Reducer<AppState, AppAction> = { state, action in
    var newState = state
    switch action {
    case .fetchArticleSuccess(let articles):
        newState.articles = articles
    default: ()
    }
    return newState
}

let articleMiddleware: Middleware<AppState, AppAction> = { state, action in
    switch action {
    case .fetchArticle(let keyword, let page):
        let service: ArticleService = DefaultArticleService()
        return service.searchArticlesByKeyword(keyword, page: page)
            .map { AppAction.fetchArticleSuccess(articles: $0) }
            .catch { Just(AppAction.fetchArticleFailure(error: $0)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    default: ()
    }
    return Empty().eraseToAnyPublisher()
}
