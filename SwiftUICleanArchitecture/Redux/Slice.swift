//
//  Slice.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 11/4/21.
//

import Foundation
import Combine

//struct ArticleSlice<State, Action> {
//    struct State {
//        var articles: [Article] = []
//    }
//
//    enum Action {
//        case fetchArticle(keyword: String, page: Int)
//        case fetchArticleSuccess(articles: [Article])
//        case fetchArticleFailure(error: Error)
//    }
//
//    var state: State
//    var reducer: (State, Action) -> State
//    var middleware: (State, Action) -> AnyPublisher<Action, Never>
//
//    init(
//        name: String,
//        initialState: State,
//        reducer: @escaping (State, Action) -> State,
//        middleware: @escaping (State, Action) -> AnyPublisher<Action, Never>
//    ) {
//        self.state = initialState
//        self.reducer = reducer
//        self.middleware = middleware
//    }
//}
//
//let articleSlice = ArticleSlice(
//    name: "article",
//    initialState: ArticleSlice.State(),
//    reducer: { state, action in
//        var newState = state
//        switch action {
//        case .fetchArticleSuccess(let articles):
//            newState.articles = articles
//        default: ()
//        }
//        return newState
//    },
//    middleware: { state, action in
//        switch action {
//        case .fetchArticle(let keyword, let page):
//            let service: ArticleService = DefaultArticleService()
//            return service.searchArticlesByKeyword(keyword, page: page)
//                .map { .fetchArticleSuccess(articles: $0) }
//                .catch { Just(.fetchArticleFailure(error: $0)).eraseToAnyPublisher() }
//                .eraseToAnyPublisher()
//        default: ()
//        }
//        return Empty().eraseToAnyPublisher()
//    }
//)
