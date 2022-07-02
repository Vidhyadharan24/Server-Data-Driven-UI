//
//  APIEndpoint.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import Foundation
import AnyCodable

public enum HTTPMethod: String, Codable {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum RequestGenerationError: Error {
    case components
}

public struct APIEndPoint: Codable {
    let key: String
    let path: String
    let method: HTTPMethod
    let headerParamaters: [String: String]? = [:]
    var queryParameters: [String: AnyCodable]? = [:]
    var bodyParameters: [String: AnyCodable]? = [:]
    
    mutating func set(queryParameters: [String: AnyCodable] = [:],
                      bodyParameters: [String: AnyCodable] = [:]) {
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
    }
    
    public func urlRequest(with apiConfig: ApiConfig) throws -> URLRequest {
        let url = try self.url(with: apiConfig)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = apiConfig.headers
        headerParamaters?.forEach { allHeaders.updateValue($1, forKey: $0) }

        if let params = bodyParameters, !params.isEmpty {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        return urlRequest
    }
    
    private func url(with apiConfig: ApiConfig) throws -> URL {
        let endpoint: String = apiConfig.baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()

        queryParameters?.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        apiConfig.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
}
