//
//  UIInputComponentModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 05/06/22.
//

import Foundation
import UIKit
import Combine
import AnyCodable

protocol UIInputComponentModel: UIComponentModel, Validatable {
    var errorMessage: String? { get set }
    
    var keyboardType: UIKeyboardType { get }
    
    var isValid: String? { get }
    var isMandatory: Bool { get }
}

extension UIInputComponentModel {
    
    var keyboardType: UIKeyboardType {
        if let validations = componentDataModel.validations {
            for validation in validations {
                guard validation.keyboardType != .default else { continue }
                return validation.keyboardType
            }
        }
        return UIKeyboardType.default
    }
    
    @discardableResult func validate(text: String) -> String? {
        if !isMandatory, text.count == 0 {
            return nil
        }
        
        if let validations = componentDataModel.validations {
            for validation in validations {
                guard let errorMessage = validation.validationFunction(text) else { continue }
                self.errorMessage = errorMessage
                return errorMessage
            }
        }
        
        errorMessage = nil
        return nil
    }
    
}
