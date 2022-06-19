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
    
    var isValid: String? {
        self.validate(text: "")
    }
            
    override var view: AnyView {
        AnyView(EmptyView())
    }
        
    init(key: String,
         rules: ComponentStateRule? = nil,
         validations: [Validation]? = nil,
         notifyChange: ObservableObjectPublisher,
         performAction: PassthroughSubject<ComponentAction, Never>) {
        self.validations = validations
        
        super.init(key: key,
                   rules: rules,
                   notifyChange: notifyChange,
                   performAction: performAction)
    }
}
