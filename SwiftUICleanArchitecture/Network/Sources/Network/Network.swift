public struct Network {}

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register {
            DefaultArticleService() as ArticleService
        }
    }
}
