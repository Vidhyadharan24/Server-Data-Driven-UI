//
//  TextFieldComponentModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import SwiftUI
import Combine
import AnyCodable

class TextFieldComponentModel: UIBaseInputComponentModel {
    @Published var text: String
    
    var placeholder: String
    
    override var view: AnyView {
        AnyView(TextFieldComponent(componentModel: self))
    }
    
    override var isHidden: Bool {
        didSet {
            guard isHidden, !oldValue else { return }
            self.text = ""
        }
    }
    
    override var isValid: String? {
        validate(text: text)
    }
    
    override var data: [String: Set<AnyCodable>] {
        [key: [AnyCodable(text)]]
    }

    init(key: String,
         rules: ComponentStateRule? = nil,
         validations: [Validation] = [],
         text: String,
         placeholder: String,
         notifyChange: ObservableObjectPublisher,
         performAction: PassthroughSubject<ComponentAction, Never>) {
        self.text = text
        self.placeholder = placeholder

        super.init(key: key,
                   rules: rules,
                   validations: validations,
                   notifyChange: notifyChange,
                   performAction: performAction)
                
        self.setUpBindings()
    }
    
    func setUpBindings() {
        $text.sink { [weak self] text in
            self?.validate(text: text)
            self?.notifyChange.send()
        }.store(in: &cancellableSet)
    }
}
