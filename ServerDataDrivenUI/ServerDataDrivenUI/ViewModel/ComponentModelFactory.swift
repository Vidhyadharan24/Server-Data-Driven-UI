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
            return PhoneFieldComponentModel(componentDataModel: dataModel,
                                            countries: enumDataModel.countries,
                                            selectedCountryCode: enumDataModel.countries.first!.code,
                                            notifyChange: notifyChange,
                                            performAction: performAction)
        case .textField(let dataModel):
            return TextFieldComponentModel(componentDataModel: dataModel,
                                           notifyChange: notifyChange,
                                           performAction: performAction)
        case .button(let dataModel):
            return GenericButtonComponentModel(componentDataModel: dataModel,
                                               notifyChange: notifyChange,
                                               performAction: performAction)
        case .timerButton(let dataModel):
            return TimerButtonComponentModel(componentDataModel: dataModel,
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
