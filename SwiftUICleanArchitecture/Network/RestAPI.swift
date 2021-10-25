//
//  API.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/6/21.
//

import Foundation
import Swinet
import Combine

protocol RestAPI {
    var path: String { get }
    var method: Swinet.HttpMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: String]? { get }
    var body: [String: Any]? { get }
    var mockFile: String? { get }

    func call<T: Decodable>(_ type: T.Type) -> AnyPublisher<T, Error>
}

extension RestAPI {
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
    var method: Swinet.HttpMethod { .get }
    var parameters: [String: String]? { nil }
    var body: [String: Any]? { nil }
    var mockFile: String? { nil }

    func call<T: Decodable>(_ type: T.Type) -> AnyPublisher<T, Error> {
        if let mockFile = mockFile,
           NetworkConfig.current.isEnabledNetworkMock,
            let path = Bundle.main.path(forResource: mockFile, ofType: ""),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                let decoder = JSONDecoder()
                let value = try decoder.decode(type, from: data)
                return Just(value)
                    .mapError { _ in Swinet.NetworkError.unknown }
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }

        let url = "\(NetworkConfig.current.baseUrl)/\(path)"
        return Swinet.request(url,
                                 method: method,
                                 parameters: parameters,
                                 body: body,
                                 headers: headers)
            .publishDecodable(type)
    }
}
