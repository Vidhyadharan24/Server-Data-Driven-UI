//
//  TextFieldViewModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import SwiftUI
import Combine
import AnyCodable

class TextFieldViewModel: UIBaseInputViewModel {
    @Published var text: String
    
    override var view: AnyView {
        AnyView(TextFieldView(viewModel: self))
    }
    
    override var isValid: Bool {
        validate(text: text) == nil
    }
    
    override func data() -> [String : AnyCodable] {
        [serverKey: AnyCodable(text)]
    }

    init(serverKey: String,
         rules: [ViewStateRule] = [],
         validations: [Validation] = [],
         text: String) {
        self.text = text

        super.init(serverKey: serverKey,
                   rules: rules,
                   validations: validations)
                
        self.setUpBindings()
    }
    
    func setUpBindings() {
        $text.sink { [weak self] text in
            self?.validate(text: text)
        }.store(in: &cancellableSet)
    }
}
