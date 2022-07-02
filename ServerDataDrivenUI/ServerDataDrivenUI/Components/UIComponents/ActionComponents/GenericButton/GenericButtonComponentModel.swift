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

    override var view: AnyView {
        AnyView(GenericButtonComponent(componentModel: self))
    }
    
    override var data: [String: Set<AnyCodable>] {
        guard let componentAction = componentAction else { return [:] }
        let key: String
        switch componentAction {
        case .refresh(let apiEndPoint),
                .apiCall(let apiEndPoint),
                .validatedAPICall(let apiEndPoint):
            key = apiEndPoint.key
        case .displayScreen: return [:]
        }
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
         componentAction: ComponentAction? = nil,
         title: String,
         notifyChange: PassthroughSubject<String, Never>,
         performAction: PassthroughSubject<UIActionComponentModel, Never>) {

        self.title = title
                
        super.init(key: key,
                   rules: rules,
                   componentAction: componentAction,
                   notifyChange: notifyChange,
                   performAction: performAction)
    }
        
    func pressed() {
        self.hideKeyboard()
        
        self.isLoading = true
        self.performAction.send(self)
    }
}
