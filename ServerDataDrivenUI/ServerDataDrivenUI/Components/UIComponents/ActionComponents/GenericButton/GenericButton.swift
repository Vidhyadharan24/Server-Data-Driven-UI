//
//  GenericButton.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 04/06/22.
//

import SwiftUI
import Combine
                   
struct GenericButton: View {
    @ObservedObject var viewModel: GenericButtonViewModel
    
    var body: some View {
        Button {
            viewModel.pressed()
        } label: {
            if viewModel.isLoading {
                ActivityIndicator(isAnimating: .constant(true),
                                  style: .medium,
                                  color: UIColor.white)
                .foregroundColor(.white)
            } else {
                Text(viewModel.title)
            }
        }
        .disabled(viewModel.isDisabled)
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 15)
        .background(
            Capsule(style: .circular)
                .fill(viewModel.isDisabled ? Color.gray : Color.blue)
        )
    }
}

struct GenericButton_Previews: PreviewProvider {
    static var previews: some View {
        let vm = GenericButtonViewModel(key: "",
                                        title: "Button",
                                        notifyChange: ObservableObjectPublisher(),
         performAction: PassthroughSubject<ViewAction, Never>())
        vm.isLoading = true
        return Group {
            GenericButton(viewModel: GenericButtonViewModel(key: "",
                                                            title: "Button",
                                                            notifyChange: ObservableObjectPublisher(),
                                                            performAction: PassthroughSubject<ViewAction, Never>()))
            GenericButton(viewModel: vm)
        }
    }
}
