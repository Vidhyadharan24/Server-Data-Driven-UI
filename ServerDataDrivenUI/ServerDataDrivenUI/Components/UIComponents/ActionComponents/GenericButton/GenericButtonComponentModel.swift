//
//  GenericButtonComponentModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 04/06/22.
//

import SwiftUI
import Combine
import AnyCodable

class GenericButtonComponentModel: UIBaseActionComponentModel {
    @Published var title: String
    var action: (() -> Void)?

    override var view: AnyView {
        AnyView(GenericButtonComponent(componentModel: self))
    }
    
    override var data: [String: Set<AnyCodable>] {
        if !isLoading {
            return [key: [AnyCodable(actionPerformed)]]
        } else {
            return [key: [AnyCodable(actionPerformed)],
                    "loading": [true]]
        }
    }
        
    init(key: String,
         rules: ComponentStateRule? = nil,
         validations: [Validation] = [],
         title: String,
         notifyChange: ObservableObjectPublisher,
         performAction: PassthroughSubject<ComponentAction, Never>) {

        self.title = title
                
        super.init(key: key,
                   rules: rules,
                   notifyChange: notifyChange,
                   performAction: performAction)
    }
        
    func pressed() {
        self.hideKeyboard()
        
        self.isLoading = true
        self.performAction.send(.validatedAPICall(key))
    }
}
