//
//  Validator.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import Foundation

protocol Validator {
    var uiComponentModels: [UIComponentModel] { get }
    
    func validate() -> String?
}


extension Validator {
    func validate() -> String? {
        for vm in uiComponentModels {
            guard let inputVM = vm as? UIInputComponentModel,
                    !inputVM.isHidden,
                    let error = inputVM.isValid else { continue }
            return error
        }
        return nil
    }
}
