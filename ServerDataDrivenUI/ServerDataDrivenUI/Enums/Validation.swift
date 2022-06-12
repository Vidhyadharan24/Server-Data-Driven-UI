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
}

struct LengthValidationData: Codable {
    let length: Int
    let errorMessage: String
}

struct RegexValidationData: Codable {
    let regex: String
    let errorMessage: String
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
