//
//  ArticleListViewModel.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 2/23/21.
//

import Foundation
import Combine

final class ArticleListViewModel: ObservableObject {
    @Injected var articleUseCase: ArticleUseCase
    
    private var disposables = Set<AnyCancellable>()
    
    /// Mark: Input
    let onAppear = PassthroughSubject<Void, Never>()
    
    /// Mark: Output
    @Published private(set) var articles: [Article] = []
    
    init() {
        transform()
    }
    
    private func transform() {
        onAppear
            .flatMap {
                return self.articleUseCase
                    .findArticlesByKeyword("Tesla", pageSize: 20, page: 1)
                    .replaceError(with: [])
            }
            .eraseToAnyPublisher()
            .assign(to: \ArticleListViewModel.articles, on: self)
            .store(in: &disposables)
    }
}
