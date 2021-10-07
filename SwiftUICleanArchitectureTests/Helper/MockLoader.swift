//
//  MockLoader.swift
//  SwiftUICleanArchitectureTests
//
//  Created by Quan on 10/6/21.
//

import Foundation

struct MockLoader {
    static func load(_ file: String) -> String? {
        let bundle = Bundle.allBundles.first { $0.bundlePath.hasSuffix(".xctest") }
        guard let path = bundle?.path(forResource: file, ofType: "") else { return nil }
        let json = try? String(contentsOfFile: path)
        return json
    }

    static func load<T: Decodable>(_ file: String, ofType type: T.Type) -> T? {
        let bundle = Bundle.allBundles.first { $0.bundlePath.hasSuffix(".xctest") }
        guard let path = bundle?.url(forResource: file, withExtension: nil),
              let data = try? Data(contentsOf: path) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
