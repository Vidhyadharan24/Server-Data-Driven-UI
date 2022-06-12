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
    
    override var data: [String: AnyCodable] {
        if !isLoading {
            return [key: AnyCodable(actionPerformed)]
        } else {
            return [key: AnyCodable(actionPerformed),
                    "loading": true]
        }
    }
    
    @Published var isLoading: Bool = false
    var actionPerformed: Bool = false
    
    init(key: String,
         rules: ViewStateRule? = nil,
         validations: [Validation] = [],
         title: String,
         action: (() -> Void)? = nil) {

        self.title = title
        
        self.action = action
        
        super.init(key: key,
                   rules: rules)
    }
    
    func pressed() {
        self.hideKeyboard()
        
        self.isLoading = true
        self.objectDidChange.send()
        action?()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.actionPerformed = true
            self.objectDidChange.send()
        }
    }
}
