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
    
    var placeholder: String
    
    override var view: AnyView {
        AnyView(TextFieldView(viewModel: self))
    }
    
    override var isHidden: Bool {
        didSet {
            guard isHidden, !oldValue else { return }
            self.text = ""
        }
    }
    
    override var isValid: Bool {
        validate(text: text) == nil
    }
    
    override var data: [String: AnyCodable] {
        [key: AnyCodable(text)]
    }

    init(key: String,
         rules: ViewStateRule? = nil,
         validations: [Validation] = [],
         text: String,
         placeholder: String) {
        self.text = text
        self.placeholder = placeholder

        super.init(key: key,
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
