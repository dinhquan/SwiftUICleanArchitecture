//
//  Config.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/6/21.
//

import Foundation

protocol EnvironmentParam {
    var baseUrl: String { get }
    var apiKey: String { get }
    var isEnabledNetworkMock: Bool { get }
}

struct Environment {
    static let current = Development()

    struct Development: EnvironmentParam {
        let baseUrl = "http://newsapi.org/v2"
        let apiKey = "ff5445a21c1d44c4928c1c3f0e7ed0f6"
        let isEnabledNetworkMock = true
    }

    struct Production: EnvironmentParam {
        let baseUrl = "http://newsapi.org/v2"
        let apiKey = "ff5445a21c1d44c4928c1c3f0e7ed0f6"
        let isEnabledNetworkMock = false
    }
}
