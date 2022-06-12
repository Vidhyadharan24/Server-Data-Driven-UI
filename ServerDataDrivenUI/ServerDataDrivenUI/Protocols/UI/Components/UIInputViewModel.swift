//
//  UIInputViewModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 05/06/22.
//

import Foundation
import UIKit
import Combine
import AnyCodable

protocol UIInputViewModel: UIViewModel, Validatable, APIDataProvider {
    var errorMessage: String? { get set }
    
    var validations: [Validation] { get }
    var keyboardType: UIKeyboardType { get }
    
    var isValid: String? { get }
}

extension UIInputViewModel {
    
    var keyboardType: UIKeyboardType {
        for validation in validations {
            guard validation.keyboardType != .default else { continue }
            return validation.keyboardType
        }
        return UIKeyboardType.default
    }
    
    @discardableResult func validate(text: String) -> String? {
        for validation in validations {
            guard let errorMessage = validation.validationFunction(text) else { continue }
            self.errorMessage = errorMessage
            return errorMessage
        }
        
        errorMessage = nil
        return nil
    }
    
}
