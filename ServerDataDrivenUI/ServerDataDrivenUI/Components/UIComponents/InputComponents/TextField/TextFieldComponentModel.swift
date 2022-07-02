//
//  TextFieldComponentModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import Combine
import AnyCodable

class TextFieldComponentModel: UIBaseInputComponentModel {
    @Published var text: String
    
    var placeholder: String
    
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
         uiComponent: UIComponent,
         rules: ComponentStateRule? = nil,
         validations: [Validation]? = nil,
         componentAction: ComponentAction? = nil,
         text: String,
         placeholder: String,
         notifyChange: PassthroughSubject<String, Never>,
         performAction: PassthroughSubject<UIComponentModel, Never>) {
        self.text = text
        self.placeholder = placeholder

        super.init(key: key,
                   uiComponent: uiComponent,
                   rules: rules,
                   validations: validations,
                   componentAction: componentAction,
                   notifyChange: notifyChange,
                   performAction: performAction)
                
        self.setUpBindings()
    }
    
    func setUpBindings() {
        $text.sink { [weak self] text in
            guard let self = self else { return }
            self.validate(text: text)
            self.notifyChange.send(self.key)
        }.store(in: &cancellableSet)
    }
}
