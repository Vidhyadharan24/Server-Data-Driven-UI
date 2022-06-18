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
        GenericButtonComponent(componentModel: GenericButtonComponentModel(key: "",
                                                        title: "Resend OTP",
                                                        notifyChange: ObservableObjectPublisher(),
                                                        performAction: PassthroughSubject<ComponentAction, Never>()))
    }
}
