//
//  UIComponentModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import SwiftUI
import Combine
import AnyCodable

protocol UIComponentModel: AnyObject {
    var key: String { get }
    var view: AnyView { get }
    
    var isHidden: Bool { get set }
    var isDisabled: Bool { get set }
    var isLoading: Bool { get set }

    var viewStateRules: ComponentStateRule? { get }

    var notifyChange: ObservableObjectPublisher { get }
    var performAction: PassthroughSubject<ComponentAction, Never> { get }
    
    func updateState(currentValues: [String: Set<AnyCodable>])
    
    var data: [String: Set<AnyCodable>] { get }
    
    func actionCompleted(action: ComponentAction, success: Bool)
}

extension UIComponentModel {
        
    func updateState(currentValues: [String: Set<AnyCodable>]) {
        if let hidingRules = viewStateRules?.hideOn {
            for (rule, values) in hidingRules {
                if let currentRuleValues = currentValues[rule] {
                    if #available(iOS 16.0, *) {
                        isHidden = values.contains(currentRuleValues)
                    } else {
                        isHidden = currentRuleValues.isSubset(of: values)
                    }
                } else {
                    isHidden = false
                }
            }
        }
        if let disableOnRules = viewStateRules?.disableOn {
            for (rule, values) in disableOnRules {
                if let currentRuleValues = currentValues[rule] {
                    if #available(iOS 16.0, *) {
                        isDisabled = values.contains(currentRuleValues)
                    } else {
                        isDisabled = currentRuleValues.isSubset(of: values)
                    }
                } else {
                    isDisabled = false
                }
            }
        }
    }
    
}

 
