//
//  API.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/6/21.
//

import Foundation
import SwiftUI

protocol RestAPI {
    var path: String { get }
    var method: Networker.HttpMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: String]? { get }
    var body: [String: Any]? { get }
    var mockFile: String? { get }

    func call<T: Decodable>(_ type: T.Type) async throws -> T
}

extension RestAPI {
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
    var method: Networker.HttpMethod { .get }
    var parameters: [String: String]? { nil }
    var body: [String: Any]? { nil }
    var mockFile: String? { nil }

    func call<T: Decodable>(_ type: T.Type) async throws -> T {
        if let mockFile = mockFile,
           NetworkConfig.current.isEnabledNetworkMock,
           let path = Bundle.module.path(forResource: mockFile, ofType: ""),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let decoder = JSONDecoder()
            do {
                let value = try decoder.decode(type, from: data)
                return value
            } catch {
                throw(error)
            }
        }

        let url = "\(NetworkConfig.current.baseUrl)/\(path)"
        return try await Networker.request(url,
                                 method: method,
                                 parameters: parameters,
                                 body: body,
                                 headers: headers)
            .responseDecodable(type)
    }
}
