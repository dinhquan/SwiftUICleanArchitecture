//
//  RestAPI.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import Foundation
import Combine
import Alamofire

struct ResponseError: Error {
    enum ErrorType {
        case af
        case json
        case unknown
    }

    let type: ErrorType
    let error: Error?
    let afError: AFError?

    var message: String {
        switch type {
        case .af:
            return afError?.localizedDescription ?? ""
        case .json:
            return error?.localizedDescription ?? ""
        default:
            return "Unknown error"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"

    var afMethod: Alamofire.HTTPMethod {
        return Alamofire.HTTPMethod(rawValue: self.rawValue)
    }
}

protocol RestAPI {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var mockFile: String { get }

    func request<T: Decodable, K: Encodable>(returnType: T.Type, paramType: K.Type, params: K) -> AnyPublisher<T, Error>
    func request<T: Decodable>(returnType: T.Type) -> AnyPublisher<T, Error>
}

extension RestAPI {
    var headers: HTTPHeaders {
        return [
            "Content-Type": "application/json"
        ]
    }

    var mockFile: String {
        return ""
    }
    
    func request<T: Decodable>(returnType: T.Type) -> AnyPublisher<T, Error> {
        if Config.current.mockEnabled,
           !mockFile.isEmpty,
           let path = Bundle.main.path(forResource: mockFile, ofType: ""),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let decoder = JSONDecoder()
            do {
                let value = try decoder.decode(returnType, from: data)
                return Just(value)
                    .mapError { _ in ResponseError(type: .unknown, error: nil, afError: nil) }
                    .eraseToAnyPublisher()
            } catch {
                let error = ResponseError(type: .json, error: error, afError: nil)
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        
        let url = "\(Config.current.baseUrl)/\(path)"
        return AF.request(url,
                          method: method.afMethod,
                          headers: headers)
            .validate(statusCode: 200 ..< 300)
            .publishDecodable(type: T.self)
            .value()
            .mapError { ResponseError(type: .af, error: nil, afError: $0) }
            .eraseToAnyPublisher()
    }
    
    func request<T: Decodable, K: Encodable>(returnType: T.Type, paramType: K.Type, params: K) -> AnyPublisher<T, Error> {
        if Config.current.mockEnabled,
           !mockFile.isEmpty,
           let path = Bundle.main.path(forResource: mockFile, ofType: ""),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let decoder = JSONDecoder()
            do {
                let value = try decoder.decode(returnType, from: data)
                return Just(value)
                    .mapError { _ in ResponseError(type: .unknown, error: nil, afError: nil) }
                    .eraseToAnyPublisher()
            } catch {
                let error = ResponseError(type: .json, error: error, afError: nil)
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        
        let url = "\(Config.current.baseUrl)/\(path)"
        return AF.request(url,
                          method: method.afMethod,
                          parameters: params,
                          encoder: JSONParameterEncoder.default,
                          headers: headers)
            .validate(statusCode: 200 ..< 300)
            .publishDecodable(type: T.self)
            .value()
            .mapError { ResponseError(type: .af, error: nil, afError: $0) }
            .eraseToAnyPublisher()
    }
}
