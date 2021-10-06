//
//  Networker.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 10/5/21.
//

import Foundation
import Combine

struct Networker {
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    enum NetworkError: Error {
        case invalidUrl
        case invalidBody
        case invalidJSONResponse
        case decodeFailure
    }

    static let timeoutInterval = 60.0
    static let defaultHeaders = ["Content-Type": "application/json"]

    static func request(_ url: String,
                        method: HttpMethod = .get,
                        parameters: [String: String]? = nil,
                        body: [String: Any]? = nil,
                        headers: [String: String] = defaultHeaders) -> Request {
        var urlString = url

        if let params = parameters {
            var components = URLComponents()
            components.queryItems = params.map {
                 URLQueryItem(name: $0, value: $1)
            }
            urlString = "\(urlString)\(components.string ?? "")"
        }

        guard let _url = URL(string: urlString) else { return Request(request: nil, preError: .invalidUrl) }
        var request = URLRequest(url: _url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval

        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            do {
                let data = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = data
            } catch {
                return Request(request: request, preError: .invalidBody)
            }
        }

        return Request(request: request, preError: nil)
    }
}

extension Networker {
    struct Request {
        let request: URLRequest?
        let preError: NetworkError?

        init(request: URLRequest?, preError: NetworkError?) {
            self.request = request
            self.preError = preError
        }

        func responseDecodable<T: Decodable>(_ type: T.Type) async throws -> T {
            guard let request = request else {
                throw(preError!)
            }
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        }

        func responseJSON(success: @escaping (_ result: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
            guard let request = request else {
                failure(preError!)
                return
            }

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    failure(error!)
                    return
                }
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        failure(NetworkError.invalidJSONResponse)
                        return
                    }
                    success(json)
                } catch {
                    failure(error)
                }
            }

            task.resume()
        }

        func responseDecodable<T: Decodable>(_ type: T.Type, success: @escaping (_ result: T) -> Void, failure: @escaping (_ error: Error) -> Void) {
            guard let request = request else {
                failure(preError!)
                return
            }

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    failure(error!)
                    return
                }
                do {
                    let decodable = try JSONDecoder().decode(type, from: data)
                    success(decodable)
                } catch {
                    failure(error)
                }
            }

            task.resume()
        }

        func responseDecodable<T: Decodable>(_ type: T.Type) -> AnyPublisher<T, Error> {
            guard let request = request,
                  let _ = request.url?.absoluteString else {
                return Fail(error: preError!)
                    .eraseToAnyPublisher()
            }

            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { result -> T in
                    let data = result.data
                    return try JSONDecoder().decode(T.self, from: data)
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}
