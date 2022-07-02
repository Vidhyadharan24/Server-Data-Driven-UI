//
//  GenericButtonComponent.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 04/06/22.
//

import SwiftUI
import Combine
                   
struct GenericButtonComponent: View {
    @ObservedObject var componentModel: GenericButtonComponentModel
    
    var body: some View {
        Button {
            hideKeyboard()
            componentModel.pressed()
        } label: {
            if componentModel.isLoading {
                ActivityIndicator(isAnimating: .constant(true),
                                  style: .medium,
                                  color: UIColor.white)
                .foregroundColor(.white)
            } else {
                Text(componentModel.title)
            }
        }
        .disabled(componentModel.isDisabled)
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 15)
        .background(
            Capsule(style: .circular)
                .fill(componentModel.isDisabled ? Color.gray : Color.blue)
        )
    }
}

struct GenericButton_Previews: PreviewProvider {
    static var previews: some View {
        let sendOTPDataModel = ButtonComponentDataModel(key: "send_otp",
                                                        uiComponent: .genericButton,
                                                        title: "Send OTP",
                                                        validations: nil,
                                                        componentStateRules: nil,
                                                        componentAction: nil)
        
        let verifyOTPDataModel = ButtonComponentDataModel(key: "verify_otp",
                                                          uiComponent: .genericButton,
                                                          title: "Verify OTP",
                                                          validations: nil,
                                                          componentStateRules: nil,
                                                          componentAction: nil)
        
        let notifyChange = PassthroughSubject<String, Never>()
        let performAction = PassthroughSubject<UIComponentModel, Never>()
        
        let vm = GenericButtonComponentModel(componentDataModel: sendOTPDataModel,
                                             notifyChange: notifyChange,
                                             performAction: performAction)
        vm.isLoading = true
        return Group {
            GenericButtonComponent(componentModel: vm)
            GenericButtonComponent(componentModel: GenericButtonComponentModel(componentDataModel: verifyOTPDataModel,
                                                                               notifyChange: notifyChange,
                                                                               performAction: performAction))
        }
    }
}
