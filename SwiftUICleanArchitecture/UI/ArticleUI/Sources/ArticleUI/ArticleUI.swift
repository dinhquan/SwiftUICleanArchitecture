import SwiftUI

public struct ArticleUI {
    @ViewBuilder
    public static func ListView() -> some View {
        ArticleListView(viewModel: .init())
    }
}
