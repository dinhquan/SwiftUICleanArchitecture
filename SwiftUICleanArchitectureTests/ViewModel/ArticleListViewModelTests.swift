//
//  ArticleListViewModelTests.swift
//  SwiftUICleanArchitectureTests
//
//  Created by Quan on 10/6/21.
//

import XCTest
@testable import SwiftUICleanArchitecture

class ArticleListViewModelTests: XCTestCase {
    private typealias ViewModel = ArticleListViewModel

    private var viewModel: ViewModel = .init()

    override func setUpWithError() throws {
        viewModel.articleService = MockArticleService()
    }

    override func tearDownWithError() throws {}

    func testFetchArticles_whenSuccess() async {
        try? await viewModel.fetchArticles()

        XCTAssertFalse(viewModel.isFetching)
        XCTAssertEqual(viewModel.articles.count, 20)
    }
}

