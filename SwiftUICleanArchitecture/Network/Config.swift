//
//  Config.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/6/21.
//

import Foundation


import Foundation

protocol EnvConfiguration {
    var baseUrl: String { get }
    var apiKey: String { get }
}

struct Config {
    // TODO: automatically environment switch by Bundle Id
    static let current = Dev()

    struct Dev: EnvConfiguration {
        let baseUrl = "http://newsapi.org/v2"
        let apiKey = "ff5445a21c1d44c4928c1c3f0e7ed0f6"
        let mockEnabled = false
    }

    struct Prod: EnvConfiguration {
        let baseUrl = "http://newsapi.org/v2"
        let apiKey = "ff5445a21c1d44c4928c1c3f0e7ed0f6"
    }
}
