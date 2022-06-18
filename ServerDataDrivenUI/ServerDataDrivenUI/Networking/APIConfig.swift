//
//  APIConfig.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 13/06/22.
//

import Foundation

public struct ApiConfig {
    public let baseURL: String
    public let maxRetryCount: Int
    public let headers: [String: String]
    public let queryParameters: [String: String]
    
     public init(baseURL: String,
                 maxRetryCount: Int = 5,
                 headers: [String: String] = [:],
                 queryParameters: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
        self.maxRetryCount = maxRetryCount
    }
}
