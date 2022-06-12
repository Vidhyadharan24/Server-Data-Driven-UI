//
//  Validator.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import Foundation

protocol Validator {
    var uiViewModels: [UIViewModel] { get }
    
    func validate() -> String?
}


extension Validator {
    func validate() -> String? {
        for vm in uiViewModels {
            guard let inputVM = vm as? UIInputViewModel,
                    !inputVM.isHidden,
                    let error = inputVM.isValid else { continue }
            return error
        }
        return nil
    }
}
