//
//  Validator.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import Foundation

protocol Validator {
    func validate() -> Bool
}


extension Validator {
    func validate() -> Bool {
//        for vm in uiViewModels {
//            guard vm.isValid else { return false }
//        }
        return true
    }
}
