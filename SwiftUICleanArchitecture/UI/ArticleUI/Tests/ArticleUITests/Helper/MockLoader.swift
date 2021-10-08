//
//  MockLoader.swift
//  SwiftUICleanArchitectureTests
//
//  Created by Quan on 10/6/21.
//

import Foundation

struct MockLoader {
    static func load(_ file: String) -> String? {
        guard let path = Bundle.module.path(forResource: file, ofType: "") else { return nil }
        let json = try? String(contentsOfFile: path)
        return json
    }

    static func load<T: Decodable>(_ file: String, ofType type: T.Type) -> T? {
        guard let path = Bundle.module.url(forResource: file, withExtension: nil),
              let data = try? Data(contentsOf: path) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
