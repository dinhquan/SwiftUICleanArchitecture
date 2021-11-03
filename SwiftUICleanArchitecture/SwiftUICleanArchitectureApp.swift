//
//  SwiftUICleanArchitectureApp.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/6/21.
//

import SwiftUI

@main
struct SwiftUICleanArchitectureApp: App {
    let store = AppStore(initial: AppState(), reducer: appReducer, middlewares: [appMiddleware])
    
    var body: some Scene {
        WindowGroup {
            ArticleListView()
                .environmentObject(store)
        }
    }
}

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register {
            DefaultArticleService() as ArticleService
        }
    }
}
