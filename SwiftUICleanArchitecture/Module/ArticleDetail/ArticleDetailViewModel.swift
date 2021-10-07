//
//  ArticleDetailViewModel.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/7/21.
//

import Foundation
import UIKit

final class ArticleDetailViewModel: ObservableObject {
    @Published private(set) var article: Article

    init(article: Article) {
        self.article = article
    }
}
