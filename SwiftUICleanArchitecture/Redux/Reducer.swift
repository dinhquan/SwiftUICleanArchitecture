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

func fetchArticle(keyword: String, page: Int) -> Thunk<AppState, AppAction> {
    return { dispatch, getState in
        var cancellable = Set<AnyCancellable>()
        let service: ArticleService = DefaultArticleService()
        service.searchArticlesByKeyword(keyword, page: page)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    dispatch(.article(.fetchArticleFailure(error: error)))
                default: ()
                }
            } receiveValue: { articles in
                dispatch(.article(.fetchArticleSuccess(articles: articles)))
            }
            .store(in: &cancellable)
    }
}

let articleReducer: Reducer<AppState, AppAction> = { state, action in
    guard case let .article(articleAction) = action else { return state }
    var newState = state
    switch articleAction {
    case .fetchArticleSuccess(let articles):
        newState.articles = articles
    default: ()
    }
    return newState
}

let articleMiddleware: Middleware<AppState, AppAction> = { state, action in
    switch action {
    case .article(.fetchArticle(let keyword, let page)):
        let service: ArticleService = DefaultArticleService()
        return service.searchArticlesByKeyword(keyword, page: page)
            .map { .article(.fetchArticleSuccess(articles: $0)) }
            .catch { Just(.article(.fetchArticleFailure(error: $0))).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    default: ()
    }
    return Empty().eraseToAnyPublisher()
}
