//
//  TextFieldComponent.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import SwiftUI
import Combine

struct TextFieldComponent: View {
    
    @ObservedObject var componentModel: TextFieldComponentModel
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(componentModel.placeholder,
                      text: $componentModel.text)
                .foregroundColor(componentModel.isDisabled ? Color.gray : Color.black)
                .disabled(componentModel.isDisabled)
                .keyboardType(componentModel.keyboardType)
                .padding(.vertical, 11)
            if let msg = componentModel.errorMessage {
                Divider()
                Text(msg)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        let componentDataModel = TextFieldComponentDataModel(key: "otp",
                                                             uiComponent: .textField,
                                                             defaultText: "",
                                                             placeholder: "",
                                                             validations: nil,
                                                             componentStateRules: nil,
                                                             componentAction: nil)
        let notifyChange = PassthroughSubject<String, Never>()
        let performAction = PassthroughSubject<UIComponentModel, Never>()
        let componentModel = TextFieldComponentModel(componentDataModel: componentDataModel,
                                                     notifyChange: notifyChange,
                                                     performAction: performAction)
        
        TextFieldComponent(componentModel: componentModel)
    }
}
