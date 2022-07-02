//
//  ComponentAction.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 12/06/22.
//

import Foundation

enum ComponentAction: Codable {
    case refresh(APIEndPoint)
    case displayScreen(String)
    case apiCall(APIEndPoint)
    case validatedAPICall(APIEndPoint)
    
    enum CodingKeys: String, CodingKey {
        case refresh
        case displayScreen = "display_screen"
        case apiCall = "api_call"
        case validatedAPICall = "validated_api_call"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(APIEndPoint.self, forKey: .refresh) {
            self = .refresh(value)
        } else if let value = try? container.decode(String.self, forKey: .displayScreen) {
            self = .displayScreen(value)
        } else if let value = try? container.decode(APIEndPoint.self, forKey: .apiCall) {
            self = .apiCall(value)
        } else if let value = try? container.decode(APIEndPoint.self, forKey: .validatedAPICall) {
            self = .validatedAPICall(value)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath,
                                                                    debugDescription: "Data doesn't match"))
        }
    }
}

enum ComponentActionError: Error {
    case validationError
    case apiError
}
