//
//  UIBaseInputComponentModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 07/06/22.
//

import Foundation
import Combine
import AnyCodable

class UIBaseInputComponentModel: UIBaseComponentModel, UIInputComponentModel {
    var errorMessage: String?
        
    var isMandatory: Bool
    var isValid: String? {
        self.validate(text: "")
    }
            
    override init(componentDataModel: ComponentDataModel,
         notifyChange: PassthroughSubject<String, Never>,
         performAction: PassthroughSubject<UIComponentModel, Never>) {
        self.isMandatory = componentDataModel.validations?.filter {
            if case .nonEmpty = $0 {
                return true
            }
            return false
        }.count ?? 0 > 0
        
        super.init(componentDataModel: componentDataModel,
                   notifyChange: notifyChange,
                   performAction: performAction)
    }
}
