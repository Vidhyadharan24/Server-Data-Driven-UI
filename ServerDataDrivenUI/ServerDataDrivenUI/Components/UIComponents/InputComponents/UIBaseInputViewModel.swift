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
    
    var isValid: Bool {
        true
    }
        
    override var view: AnyView {
        AnyView(EmptyView())
    }
        
    override func data() -> [String : AnyCodable] {
        return [:]
    }
        
    init(key: String,
         rules: [ViewStateRule] = [],
         validations: [Validation] = []) {
        self.validations = validations
        
        super.init(key: key,
                   rules: rules)
    }
        
    func notifyChange(_ block: @escaping () -> Void) {
        self.objectWillChange.sink {
            block()
        }.store(in: &cancellableSet)
    }
    
}
