//
//  Navigation.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/7/21.
//

import SwiftUI

struct Navigation {
    func getArticleListView_() -> ArticleListView {
        return ArticleListView(viewModel: .init())
    }
}
