//
//  UIInputViewModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 05/06/22.
//

import Foundation
import UIKit

typealias ValidationFunction = (String) -> String?

protocol UIInputViewModel: UIViewModel, Validatable {
    var errorMessage: String? { get }
    
    var validations: [Validation] { get }
    var keyboardType: UIKeyboardType { get }
    
    func notifyChange(_ block: @escaping () -> Void)
    
    var isValid: Bool { get }
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
            return errorMessage
        }
        
        return nil
    }
    
}
