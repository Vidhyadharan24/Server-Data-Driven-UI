//
//  UIViewModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import SwiftUI
import Combine
import AnyCodable

protocol UIViewModel: AnyObject {
    var key: String { get }
    var view: AnyView { get }
    
    var isHidden: Bool { get set }
    var isDisabled: Bool { get set }

    var viewStateRules: [ViewStateRule] { get }

    func updateState(currentValues: [String: AnyCodable])
    
    func data() -> [String: AnyCodable]
}

extension UIViewModel {
        
    func updateState(currentValues: [String: AnyCodable]) {
        for viewStateRule in viewStateRules {
            if let hidingRules = viewStateRule.hideOn {
                for (name, value) in hidingRules {
                    isHidden = currentValues[name] == value
                }
            }
            if let disableOnRules = viewStateRule.disableOn {
                for (name, value) in disableOnRules {
                    isDisabled = currentValues[name] == value
                }
            }
        }
    }
    
}

