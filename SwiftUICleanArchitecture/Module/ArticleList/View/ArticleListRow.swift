//
//  ArticleListRow.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 2/23/21.
//

import SwiftUI

struct ArticleListRow: View {
    @State var article: Article

    var body: some View {
        Text(article.title)
    }
}

struct ArticleListRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListRow(article: Article())
    }
}
