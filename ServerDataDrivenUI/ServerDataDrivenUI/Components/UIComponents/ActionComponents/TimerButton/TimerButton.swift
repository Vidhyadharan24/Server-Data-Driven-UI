//
//  GenericButton.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 04/06/22.
//

import SwiftUI
import Combine

struct TimerButton: View {
    @ObservedObject var viewModel: TimerButtonViewModel
        
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
        .disabled(viewModel.buttonDisabled)
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 15)
        .background(
            Capsule(style: .circular)
                .fill(viewModel.buttonDisabled ? Color.gray : Color.blue)
        )
    }
    
}

struct TimerButton_Previews: PreviewProvider {
    static var previews: some View {
        GenericButton(viewModel: GenericButtonViewModel(key: "",
                                                        title: "Resend OTP",
                                                        notifyChange: ObservableObjectPublisher(),
                                                        performAction: PassthroughSubject<ViewAction, Never>()))
    }
}
