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

struct Environment {
    @Injected var articleService: ArticleService
}

typealias AppStore = Store<AppState, AppAction, Environment>

let rootReducer = combineReducers(articleReducer)

func createStore() -> AppStore {
    let store = AppStore(
        initialState: AppState(),
        reducer: rootReducer,
        environment: Environment()
    )
    return store
}
