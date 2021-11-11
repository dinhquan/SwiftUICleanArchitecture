//
//  Store.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 11/3/21.
//

import Foundation
import Combine

struct Response<Model> {
    var value: Model
    var isLoading = false
    var error: Error? = nil
}

struct AppState {
    var articles: Response<[Article]> = .init(value: [])
}

enum AppAction {
    case article(ArticleAction)
}

struct Environment {
    @Injected var articleService: ArticleService
}

typealias AppStore = Store<AppState, AppAction, Environment>

final class StoreContainer {
    var store: AppStore? = nil
    
    static var shared = StoreContainer()
    
    func initializeStore() {
        let rootReducer = combineReducers(articleReducer)

        self.store = AppStore(
            initialState: AppState(),
            reducer: rootReducer,
            environment: Environment()
        )
    }
}

@propertyWrapper struct ReduxStore {
    var wrappedValue: AppStore {
        get {
            guard let store = StoreContainer.shared.store else {
                fatalError("Store is not created. Please create it first!")
            }
            return store
        }
    }
}
