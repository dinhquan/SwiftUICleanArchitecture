//
//  SwiftUICleanArchitectureApp.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/6/21.
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
