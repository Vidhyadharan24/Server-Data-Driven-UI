//
//  UIComponentModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import Combine
import AnyCodable

protocol UIComponentModel: AnyObject {
    var key: String { get }
    var uiComponent: UIComponent { get }
    var isHidden: Bool { get set }
    var isDisabled: Bool { get set }
    var isLoading: Bool { get set }

    var actionPerformed: Bool { get set }
    var componentStateRules: ComponentStateRule? { get }
    var componentAction: ComponentAction? { get }

    var notifyChange: PassthroughSubject<String, Never> { get }
    func resetIfNeeded(onChange: String) -> Bool
    
    var data: [String: Set<AnyCodable>] { get }
    func updateState(currentValues: [String: Set<AnyCodable>])
        
    var performAction: PassthroughSubject<UIComponentModel, Never> { get }
    func actionCompleted(success: Bool)
}

extension UIComponentModel {
        
    func updateState(currentValues: [String: Set<AnyCodable>]) {
        if let hidingRules = componentStateRules?.hideOn {
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
        if let disableOnRules = componentStateRules?.disableOn {
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

 
