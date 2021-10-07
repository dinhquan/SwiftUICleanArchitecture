//
//  ArticleAPI.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/6/21.
//

import Foundation

enum ArticleAPI: RestAPI {
    case fetchArticles(keyword: String, pageSize: Int, page: Int)
}

extension ArticleAPI {
    var path: String {
        switch self {
        case .fetchArticles:
            return "everything"
        }
    }

    var parameters: [String : String]? {
        switch self {
        case .fetchArticles(let keyword, let pageSize, let page):
            return [
                "q": keyword.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) ?? "",
                "apiKey": NetworkConfig.current.apiKey,
                "from": "2021-10-01",
                "sortBy": "publishedAt",
                "pageSize": "\(pageSize)",
                "page": "\(page)"
            ]
        }
    }

    var mockFile: String? { "searchArticles.json" }
}
