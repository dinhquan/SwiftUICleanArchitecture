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
    case article(ArticleAction)
}

typealias AppStore = Store<AppState, AppAction>

let rootReducer = combineReducers(articleReducer)
let rootMiddleware = combineMiddlewares(articleMiddleware)

func createStore() -> AppStore {
    let store = AppStore(
        initial: AppState(),
        reducer: rootReducer,
        middlewares: [rootMiddleware]
    )
    return store
}
