//
//  Validation.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import Foundation
import UIKit

typealias ValidationFunction = (String) -> String?

enum Validation: Codable {
    case nonEmpty(ValidationData)
    case min(LengthValidationData)
    case max(LengthValidationData)
    case numbers(ValidationData)
    case email(ValidationData)
    case regex(RegexValidationData)
    
    enum CodingKeys: String, CodingKey {
        case nonEmpty = "non_empty"
        case min
        case max
        case numbers
        case email
        case regex
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(ValidationData.self, forKey: .nonEmpty) {
            self = .nonEmpty(value)
        } else if let value = try? container.decode(LengthValidationData.self, forKey: .min) {
            self = .min(value)
        } else if let value = try? container.decode(LengthValidationData.self, forKey: .max) {
            self = .max(value)
        } else if let value = try? container.decode(ValidationData.self, forKey: .numbers) {
            self = .numbers(value)
        } else if let value = try? container.decode(ValidationData.self, forKey: .email) {
            self = .email(value)
        } else if let value = try? container.decode(RegexValidationData.self, forKey: .regex) {
            self = .regex(value)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath,
                                                                    debugDescription: "Data doesn't match"))
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .numbers:
            return UIKeyboardType.numberPad
        case .email:
            return UIKeyboardType.emailAddress
        default:
            return UIKeyboardType.default
        }
    }
    
    var validationFunction: ValidationFunction {
        switch self {
        case .nonEmpty(let validationData):
            return { text in
                ValidationFunctions.nonEmpty(text: text,
                                             validationData: validationData)
            }
        case .min(let validationData):
            return { text in
                ValidationFunctions.min(text: text,
                                        validationData: validationData)
            }
        case .max(let validationData):
            return { text in
                ValidationFunctions.max(text: text,
                                        validationData: validationData)
            }
        case .numbers(let validationData):
            return { text in
                ValidationFunctions.numbers(text: text,
                                            validationData: validationData)
            }
        case .email(let validationData):
            return { text in
                ValidationFunctions.email(text: text,
                                          validationData: validationData)
            }
        case .regex(let validationData):
            return { text in
                ValidationFunctions.regex(text: text,
                                          validationData: validationData)
            }
        }
    }
}

struct ValidationData: Codable {
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "error_message"
    }
}

struct LengthValidationData: Codable {
    let length: Int
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case length
        case errorMessage = "error_message"
    }
}

struct RegexValidationData: Codable {
    let regex: String
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case regex
        case errorMessage = "error_message"
    }
}

struct ValidationFunctions {
    
    static func nonEmpty(text: String,
                         validationData: ValidationData) -> String? {
        return text.isEmpty ? validationData.errorMessage : nil
    }
    
    static func min(text: String,
                         validationData: LengthValidationData) -> String? {
        return text.count < validationData.length ? validationData.errorMessage : nil
    }
    
    static func max(text: String,
                         validationData: LengthValidationData) -> String? {
        return text.count > validationData.length ? validationData.errorMessage : nil
    }
    
    static func numbers(text: String,
                         validationData: ValidationData) -> String? {
        return Int(text) == nil ? validationData.errorMessage : nil
    }
    
    static func email(text: String,
                         validationData: ValidationData) -> String? {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let result = "test@test.com".range(
            of: emailPattern,
            options: .regularExpression
        )
        return result == nil ? validationData.errorMessage : nil
    }
    
    static func regex(text: String,
                         validationData: RegexValidationData) -> String? {
        let result = text.range(
            of: validationData.regex,
            options: .regularExpression
        )
        return result == nil ? validationData.errorMessage : nil
    }
    
}
