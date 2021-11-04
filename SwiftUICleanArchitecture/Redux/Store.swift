//
//  Store.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 11/3/21.
//

import Foundation
import Combine

struct AppState {
    var articles: [Article] = []
}

enum AppAction {
    case fetchArticle(keyword: String, page: Int)
    case fetchArticleSuccess(articles: [Article])
    case fetchArticleFailure(error: Error)
}

typealias AppStore = Store<AppState, AppAction>

func createStore() -> AppStore {
    let store = AppStore(
        initial: AppState(),
        reducer: combineReducers(articleReducer),
        middlewares: [articleMiddleware]
    )
    return store
}
