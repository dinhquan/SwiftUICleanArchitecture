//
//  SwiftUICleanArchitectureApp.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/6/21.
//

import SwiftUI
import ArticleUI

@main
struct SwiftUICleanArchitectureApp: App {
    var body: some Scene {
        WindowGroup {
            ArticleUI.ListView()
        }
    }
}
