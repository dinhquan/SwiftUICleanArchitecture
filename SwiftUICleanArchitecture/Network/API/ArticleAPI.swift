//
//  ArticleAPI.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/6/21.
//

import Foundation

enum ArticleAPI: RestAPI {
    case searchArticles(keyword: String, page: Int)
}

extension ArticleAPI {
    var path: String {
        switch self {
        case .searchArticles:
            return "everything"
        }
    }

    var parameters: [String : String]? {
        switch self {
        case .searchArticles(let keyword, let page):
            return [
                "q": keyword.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) ?? "",
                "apiKey": NetworkConfig.current.apiKey,
                "from": "2021-10-01",
                "sortBy": "publishedAt",
                "pageSize": "20",
                "page": "\(page)"
            ]
        }
    }
}
