//
//  News.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import Foundation

public struct Article: Decodable {
    @Default.Empty public var author: String
    @Default.Empty public var title: String
    @Default.Empty public var description: String
    @Default.Empty public var url: String
    @Default.Empty public var urlToImage: String
    @Default.Empty public var publishedAt: String
    @Default.Empty public var content: String

    public init() {}
}

extension Article: Identifiable {
    public var id: String {
        title
    }
}

extension Article {
    public var formattedPublishedAt: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ssZ"
        guard let date = formatter.date(from: publishedAt) else { return "" }

        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "MMM dd, HH:mm"
        return "\(NSLocalizedString("Updated", comment: "")): \(outFormatter.string(from: date))"
    }
}
