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
        let vm = GenericButtonComponentModel(key: "",
                                        title: "Button",
                                        notifyChange: ObservableObjectPublisher(),
         performAction: PassthroughSubject<ComponentAction, Never>())
        vm.isLoading = true
        return Group {
            GenericButtonComponent(componentModel: GenericButtonComponentModel(key: "",
                                                            title: "Button",
                                                            notifyChange: ObservableObjectPublisher(),
                                                            performAction: PassthroughSubject<ComponentAction, Never>()))
            GenericButtonComponent(componentModel: vm)
        }
    }
}
