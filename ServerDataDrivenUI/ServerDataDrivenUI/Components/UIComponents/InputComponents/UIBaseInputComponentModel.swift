//
//  UIBaseInputComponentModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 07/06/22.
//

import Foundation
import Combine
import AnyCodable
import SwiftUI

class UIBaseInputComponentModel: UIBaseComponentModel, UIInputComponentModel {
    var errorMessage: String?
    
    var validations: [Validation]?
    
    var isMandatory: Bool
    var isValid: String? {
        self.validate(text: "")
    }
            
    override var view: AnyView {
        AnyView(EmptyView())
    }
        
    init(key: String,
         rules: ComponentStateRule? = nil,
         validations: [Validation]? = nil,
         componentAction: ComponentAction? = nil,
         notifyChange: PassthroughSubject<String, Never>,
         performAction: PassthroughSubject<UIActionComponentModel, Never>) {
        self.validations = validations
        self.isMandatory = validations?.filter {
            if case .nonEmpty = $0 {
                return true
            }
            return false
        }.count ?? 0 > 0
        
        super.init(key: key,
                   rules: rules,
                   componentAction: componentAction,
                   notifyChange: notifyChange,
                   performAction: performAction)
    }
}
