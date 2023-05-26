// Created by Tobiáš Hládek on 24/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import Foundation
struct ImageDTO: Codable, Equatable {
    var image: String
}

enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var scheme: String { "https" }
    var host: String { "mobility.cleverlance.com" }
}

enum NetworkingError: Error {
    case encoding
    case empty
    case decoding
    case unauthorized
    case unknown
    case invalidURL

    var customMessage: String {
        switch self {
        case .encoding:
            return "Failed to encode URL"
        case .decoding:
            return "Failed to decode response"
        case .unauthorized:
            return "Session expired"
        case .empty:
            return "Response is empty"
        default:
            return "Unknown error"
        }
    }
}

protocol NetworkService {
    func sendRequest<T: Decodable>(endpoint: Endpoint) async -> Result<T, NetworkingError>
}

extension NetworkService {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint
    ) async -> Result<T, NetworkingError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        print(urlComponents.url!)

        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }

        if let body = endpoint.body {
            print(body.map { URLQueryItem(name: $0, value: $1) })
            urlComponents.queryItems = body.map { URLQueryItem(name: $0, value: $1) }
//                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) //TODO: this decision should be made on endpoint logic
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        request.httpBody = urlComponents.query?.data(using: .utf8)

        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)

            guard let response = response as? HTTPURLResponse else {
                return .failure(.empty)
            }
            switch response.statusCode {
            case 200 ..< 300:
                guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                    return .failure(.decoding)
                }
                return .success(result)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unknown)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
