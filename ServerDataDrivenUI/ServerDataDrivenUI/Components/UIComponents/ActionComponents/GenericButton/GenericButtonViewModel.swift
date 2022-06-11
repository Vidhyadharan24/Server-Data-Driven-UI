//
//  GenericButtonViewModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 04/06/22.
//

import SwiftUI
import AnyCodable

class GenericButtonViewModel: UIBaseViewModel {
    @Published var title: String
    var action: (() -> Void)?

    override var view: AnyView {
        AnyView(GenericButton(viewModel: self))
    }
    
    override func data() -> [String : AnyCodable] {
        [key: AnyCodable(title)]
    }

    var isParentDisabled: Bool
    
    init(key: String,
         rules: [ViewStateRule] = [],
         validations: [Validation] = [],
         title: String,
         isDisabled: Bool = false,
         action: (() -> Void)? = nil) {

        self.title = title
        self.isParentDisabled = isDisabled
        self.action = action
        
        super.init(key: key,
                   rules: rules)
        
        self.isDisabled = isDisabled
    }
    
    func pressed() {
        if let action = action {
            action()
        } else {
            // run code
        }
    }
}
