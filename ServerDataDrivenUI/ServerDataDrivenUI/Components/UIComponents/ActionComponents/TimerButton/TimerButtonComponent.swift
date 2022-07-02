//
//  TimerButtonComponent.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 04/06/22.
//

import SwiftUI
import Combine

struct TimerButtonComponent: View {
    @ObservedObject var componentModel: TimerButtonComponentModel
        
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
        .disabled(componentModel.buttonDisabled)
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 15)
        .background(
            Capsule(style: .circular)
                .fill(componentModel.buttonDisabled ? Color.gray : Color.blue)
        )
    }
    
}

struct TimerButton_Previews: PreviewProvider {
    static var previews: some View {
        let notifyChange = PassthroughSubject<String, Never>()
        let performAction = PassthroughSubject<UIComponentModel, Never>()
        let componentModel = TimerButtonComponentModel(key: "resend_otp",
                                                       uiComponent: .timerButton,
                                                       title: "Resend OTP",
                                                       countDownDuration: 60,
                                                       notifyChange: notifyChange,
                                                       performAction: performAction)
        return TimerButtonComponent(componentModel: componentModel)
    }
}
