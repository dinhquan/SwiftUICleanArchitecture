//
//  ArticleTests.swift
//  SwiftUICleanArchitectureTests
//
//  Created by Quan on 10/6/21.
//

import XCTest
@testable import SwiftUICleanArchitecture

class ArticleTest: XCTestCase {

    func testformattedPublishedAt_validDate() async {
        var article = Article()
        article.publishedAt = "2021-02-04T02:37:06Z"
        
        XCTAssertEqual(article.formattedPublishedAt, "Updated: Jan 04, 09:37")
    }
}

