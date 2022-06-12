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
    var isLoading: Bool { get set }

    var viewStateRules: ViewStateRule? { get }

    var notifyChange: ObservableObjectPublisher { get }
    var performAction: PassthroughSubject<ViewAction, Never> { get }
    
    func updateState(currentValues: [String: [String: AnyCodable]])
    
    var data: [String: [String: AnyCodable]] { get }
    
    func actionCompleted(action: ViewAction, success: Bool)
}

extension UIViewModel {
        
    func updateState(currentValues: [String: [String: AnyCodable]]) {
        if let hidingRules = viewStateRules?.hideOn {
            for (viewName, viewRules) in hidingRules {
                let viewStateData = currentValues[viewName]
                for (stateName, value) in viewRules {
                    isHidden = viewStateData?[stateName] == value
                }
            }
        }
        if let disableOnRules = viewStateRules?.disableOn {
            for (viewName, viewRules) in disableOnRules {
                let viewStateData = currentValues[viewName]
                for (stateName, value) in viewRules {
                    isDisabled = viewStateData?[stateName] == value
                }
            }
        }
    }
    
}

