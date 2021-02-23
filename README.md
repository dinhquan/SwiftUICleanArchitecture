# SwiftUICleanArchitecture
iOS Clean Architecture with SwiftUI, Combine, MVVM

## High level overview

![alt text](https://github.com/dinhquan/iOSCleanArchitecture/blob/main/Images/HighLevel.png)

The whole design architecture is separated into 4 rings:
- **Entities**: Enterprise business rules
- **UseCases**: Application business rules
- **Data**: Network & Data persistent
- **Application**: UI & Devices

The most important rule is that the inner ring knows nothing about outer ring. Which means the variables, functions and classes (any entities) that exist in the outer layers can not be mentioned in the more inward levels.

## Detail overview

![alt text](https://github.com/dinhquan/iOSCleanArchitecture/blob/main/Images/DetailLevel.png)

### Domain
**Entities** are implemented as Swift struct
```swift
struct Article: Decodable {
    @Default.Empty var author: String
    @Default.Empty var title: String
    @Default.Empty var description: String
    @Default.Empty var url: String
    @Default.Empty var urlToImage: String
    @Default.Empty var publishedAt: String
    @Default.Empty var content: String
}
```

**UseCases** are protocols
```swift
protocol ArticleUseCase {
    func findArticlesByKeyword(_ keyword: String, pageSize: Int, page: Int) -> AnyPublisher<[Article], Error>
}

```

Domain layer doesn't depend on UIKit or any 3rd party framework.

### Data
**Repositories** are concrete implementation of UseCases
```swift
struct SearchArticleResult: Decodable {
    @Default.EmptyList var articles: [Article]
    @Default.Zero var totalResults: Int
}

struct ArticleRepository: ArticleUseCase {
    func findArticlesByKeyword(_ keyword: String, pageSize: Int, page: Int) -> AnyPublisher<[Article], Error> {
        return ArticleService
            .searchArticlesByKeyword(q: keyword, pageSize: pageSize, page: page)
            .request(returnType: SearchArticleResult.self)
            .map(\.articles)
            .eraseToAnyPublisher()
    }
}
```

### Application
Application is implemented with the MVVM pattern. The **ViewModel** performs pure transformation of a user Input to the Output
```swift
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
```
As you can see, `articleUseCase` is injected to ViewModel by `@Injected` annotation. Thanks to [Resolver](https://github.com/hmlongco/Resolver) library to make dependency injection easier.

The **View** only sends input and observe the output state to update UI
```swift
struct ArticleListView: View {
    @ObservedObject var viewModel: ArticleListViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.articles) { article in
                ArticleListRow(article: article)
            }
        }
        .onAppear(perform: {
            self.viewModel.onAppear.send()
        })
    }
}
```

## Code generator
The clean architecture, MVVM or VIPER will create a lot of files when you start a new module. So using a code generator is the smart way to save time.

[codegen](https://github.com/dinhquan/codegen) is a great tool to do it.
