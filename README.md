# SwiftUICleanArchitecture
iOS Clean Architecture with SwiftUI, Swift Concurrency with MVVM pattern.

## High level overview

![alt text](https://github.com/dinhquan/SwiftUICleanArchitecture/blob/main/Images/Architecture.png)

The whole design architecture is separated into 5 parts in horizontal axis:
- **View**: UI layer, doesn't contain any business logic
- **ViewModel**: UI Logic layer.
- **Service**: Middle layer between ViewModel and Data Layer.
- **Data Layer**: Database, Networking, User Preferences, Analytics, ... or any third party services
- **Model**: Model is shared layer. Model can be accessed from any where.

## Detail overview

### Model
**Model** are implemented as Swift struct
```swift
struct Article: Decodable {
    var author: String
    var title: String
    var description: String
    var url: String
    var urlToImage: String
    var publishedAt: String
    var content: String
}
```
### Service
Each **Service** includes a protocol and a default implementation.
```swift
protocol ArticleService {
    func searchArticlesByKeyword(_ keyword: String, page: Int) async throws -> [Article]
}

actor DefaultArticleService: ArticleService {
    func searchArticlesByKeyword(_ keyword: String, page: Int) async throws -> [Article] {
        return try await ArticleAPI
            .searchArticles(keyword: keyword, page: page)
            .call([Article].self)
    }
}
```

### ViewModel
The **ViewModel** performs pure transformation of a user Input to the Output
```swift
final class ArticleListViewModel: ObservableObject {
    @Injected var articleService: ArticleService

    @Published private(set) var articles: [Article] = []
    @Published private(set) var isFetching = false

    @MainActor
    func fetchArticles() async throws {
        isFetching = true
        defer { isFetching = false }

        articles = try await articleService.searchArticlesByKeyword("Tesla", page: 1)
    }
}
```
As you can see, `articleService` is injected to ViewModel by `@Injected` annotation. Thanks to [Resolver](https://github.com/hmlongco/Resolver) library to make dependency injection easier.

### View
The **View** only sends input and observe the output state to update UI
```swift
struct ArticleListView: View {
    @ObservedObject var viewModel: ArticleListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.articles) { article in
                    ArticleListRow(article: article)
                }
                if viewModel.isFetching {
                    ProgressView()
                }
                Button("Load Articles") {
                    Task {
                        try? await viewModel.fetchArticles()
                    }
                }
            }
        }
    }
}
```

## Code generator
The clean architecture, MVVM or VIPER will create a lot of files when you start a new module. So using a code generator is the smart way to save time.

[codegen](https://github.com/dinhquan/codegen) is a great tool for code generator.
