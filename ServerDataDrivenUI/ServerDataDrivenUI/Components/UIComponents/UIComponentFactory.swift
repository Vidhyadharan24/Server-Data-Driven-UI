//
//  UIComponentFactory.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 02/07/22.
//

import Foundation
import SwiftUI

class UIComponentFactory {
    
    static func component(for componentModel: UIComponentModel) -> AnyView? {
        switch componentModel.componentDataModel.uiComponent {
        case UIComponent.phoneNumber where componentModel is PhoneFieldComponentModel:
            return AnyView(PhoneFieldComponent(componentModel: componentModel as! PhoneFieldComponentModel))
        case UIComponent.textField where componentModel is TextFieldComponentModel:
            return AnyView(TextFieldComponent(componentModel: componentModel as! TextFieldComponentModel))
        case UIComponent.genericButton where componentModel is GenericButtonComponentModel:
            return AnyView(GenericButtonComponent(componentModel: componentModel as! GenericButtonComponentModel))
        case UIComponent.timerButton where componentModel is TimerButtonComponentModel:
            return AnyView(TimerButtonComponent(componentModel: componentModel as! TimerButtonComponentModel))
        default:
            print("Invalid config \(componentModel.componentDataModel.uiComponent)")
            return nil
        }
    }
    
}
