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

    var viewStateRules: ViewStateRule? { get }

    var objectDidChange: ObservableObjectPublisher { get }
    func updateState(currentValues: [String: AnyCodable])
    
    var data: [String: AnyCodable] { get }
}

extension UIViewModel {
        
    func updateState(currentValues: [String: AnyCodable]) {
        if let hidingRules = viewStateRules?.hideOn {
            for (name, value) in hidingRules {
                let result = currentValues[name] == value
                guard result != isHidden else { continue }
                isHidden = result
            }
        }
        if let disableOnRules = viewStateRules?.disableOn {
            for (name, value) in disableOnRules {
                let result = currentValues[name] == value
                guard result != isDisabled else { continue }
                isDisabled = result
            }
        }
    }
    
}

