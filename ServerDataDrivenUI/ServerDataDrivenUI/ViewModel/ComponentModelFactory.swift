//
//  ComponentModelFactory.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 19/06/22.
//

import Foundation
import Combine

struct ComponentModelFactory {
    static let enumDataModel: EnumDataModel = {
        Utils.loadJson(filename: "EnumData")!
    }()

    
    static func componentModel(for dataModel: UIComponentDataModel,
                               notifyChange: PassthroughSubject<String, Never>,
                               performAction: PassthroughSubject<UIComponentModel, Never>) -> UIComponentModel {
        switch dataModel {
        case .phoneNumber(let dataModel):
            return PhoneFieldComponentModel(key: dataModel.key,
                                            uiComponent: dataModel.uiComponent,
                                            rules: dataModel.componentStateRules,
                                            componentAction: dataModel.componentAction,
                                            countries: enumDataModel.countries,
                                            selectedCountryCode: enumDataModel.countries.first!.code,
                                            notifyChange: notifyChange,
                                            performAction: performAction)
        case .textField(let dataModel):
            return TextFieldComponentModel(key: dataModel.key,
                                           uiComponent: dataModel.uiComponent,
                                           rules: dataModel.componentStateRules,
                                           validations: dataModel.validations,
                                           componentAction: dataModel.componentAction,
                                           text: "",
                                           placeholder: "Login OTP",
                                           notifyChange: notifyChange,
                                           performAction: performAction)
        case .button(let dataModel):
            return GenericButtonComponentModel(key: dataModel.key,
                                               uiComponent: dataModel.uiComponent,
                                               rules: dataModel.componentStateRules,
                                               componentAction: dataModel.componentAction,
                                               title: dataModel.title,
                                               notifyChange: notifyChange,
                                               performAction: performAction)
        case .timerButton(let dataModel):
            return TimerButtonComponentModel(key: dataModel.key,
                                             uiComponent: dataModel.uiComponent,
                                             rules: dataModel.componentStateRules,
                                             title: dataModel.title,
                                             componentAction: dataModel.componentAction,
                                             countDownDuration: 60,
                                             notifyChange: notifyChange,
                                             performAction: performAction)
        }
    }
    
    static func componentModels(for dataModels: [UIComponentDataModel],
                                 notifyChange: PassthroughSubject<String, Never>,
                                performAction: PassthroughSubject<UIComponentModel, Never>) -> [UIComponentModel] {
        var componentModels = [UIComponentModel]()
        
        for dataModel in dataModels {
            componentModels.append(self.componentModel(for: dataModel,
                                                       notifyChange: notifyChange,
                                                       performAction: performAction))
        }
        
        return componentModels
    }
    
}
