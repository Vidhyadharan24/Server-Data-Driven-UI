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
        loadJson(filename: "EnumData")!
    }()

    
    static func componentModel(for dataModel: UIComponentDataModel,
                               notifyChange: ObservableObjectPublisher,
                               performAction: PassthroughSubject<ComponentAction, Never>) -> UIComponentModel {
        switch dataModel {
        case .phoneNumber(let phoneComponentDataModel):
            return PhoneFieldComponentModel(key: phoneComponentDataModel.key,
                                            rules: phoneComponentDataModel.componentStateRules,
                                            countries: enumDataModel.countries,
                                            selectedCountryCode: enumDataModel.countries.first!.code,
                                            notifyChange: notifyChange,
                                            performAction: performAction)
        case .textField(let textFieldComponentDataModel):
            return TextFieldComponentModel(key: textFieldComponentDataModel.key,
                                           rules: textFieldComponentDataModel.componentStateRules,
                                           validations: textFieldComponentDataModel.validations,
                                           text: "",
                                           placeholder: "Login OTP",
                                           notifyChange: notifyChange,
                                           performAction: performAction)
        case .button(let buttonComponentDataModel):
            return GenericButtonComponentModel(key: buttonComponentDataModel.key,
                                               rules: buttonComponentDataModel.componentStateRules,
                                               title: buttonComponentDataModel.title,
                                               notifyChange: notifyChange,
                                               performAction: performAction)
        case .timerButton(let timerButtonComponentDataModel):
            return TimerButtonComponentModel(key: timerButtonComponentDataModel.key,
                                             rules: timerButtonComponentDataModel.componentStateRules,
                                             title: timerButtonComponentDataModel.title,
                                             countDownDuration: 60,
                                             notifyChange: notifyChange,
                                             performAction: performAction)
        }
    }
    
    static func componentModels(for dataModels: [UIComponentDataModel],
                                 notifyChange: ObservableObjectPublisher,
                                performAction: PassthroughSubject<ComponentAction, Never>) -> [UIComponentModel] {
        var componentModels = [UIComponentModel]()
        
        for dataModel in dataModels {
            componentModels.append(self.componentModel(for: dataModel,
                                                       notifyChange: notifyChange,
                                                       performAction: performAction))
        }
        
        return componentModels
    }
    
}
