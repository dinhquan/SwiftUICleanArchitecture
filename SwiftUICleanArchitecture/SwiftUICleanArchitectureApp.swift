//
//  SwiftUICleanArchitectureApp.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 2/23/21.
//

import SwiftUI

@main
struct SwiftUICleanArchitectureApp: App {
    var body: some Scene {
        WindowGroup {
            ArticleListView(viewModel: .init())
        }
    }
}

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register {
            ArticleRepository() as ArticleUseCase
        }
        register {
            DefaultArticleConcurrencyUseCase() as ArticleConcurrencyUseCase
        }
    }
}
