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
        [componentDataModel.key: [AnyCodable(text)]]
    }

    init(componentDataModel: TextFieldComponentDataModel,
         notifyChange: PassthroughSubject<String, Never>,
         performAction: PassthroughSubject<UIComponentModel, Never>) {
        self.text = componentDataModel.defaultText ?? ""
        self.placeholder = componentDataModel.placeholder ?? ""

        super.init(componentDataModel: componentDataModel,
                   notifyChange: notifyChange,
                   performAction: performAction)
                
        self.setUpBindings()
    }
    
    func setUpBindings() {
        $text.sink { [weak self] text in
            guard let self = self else { return }
            self.validate(text: text)
            self.notifyChange.send(self.componentDataModel.key)
        }.store(in: &cancellableSet)
    }
}
