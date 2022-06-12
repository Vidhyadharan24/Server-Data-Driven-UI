//
//  UIBaseInputViewModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 07/06/22.
//

import Foundation
import Combine
import AnyCodable
import SwiftUI

class UIBaseInputViewModel: UIBaseViewModel, UIInputViewModel {        
    var errorMessage: String?
    
    var validations: [Validation]
    
    var isValid: String? {
        self.validate(text: "")
    }
            
    override var view: AnyView {
        AnyView(EmptyView())
    }
        
    init(key: String,
         rules: ViewStateRule? = nil,
         validations: [Validation] = [],
         notifyChange: ObservableObjectPublisher,
         performAction: PassthroughSubject<ViewAction, Never>) {
        self.validations = validations
        
        super.init(key: key,
                   rules: rules,
                   notifyChange: notifyChange,
                   performAction: performAction)
    }
}
