//
//  GenericButton.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 04/06/22.
//

import SwiftUI

struct TimerButton: View {
    
    @ObservedObject var viewModel: TimerButtonViewModel
    
    var body: some View {
        let vm = GenericButtonViewModel(key: viewModel.key,
                                        title: viewModel.title,
                                        isDisabled: viewModel.isDisabled) {
            viewModel.pressed()
        }
        
        GenericButton(viewModel: vm)
            .disabled(viewModel.isDisabled)
    }
}

struct TimerButton_Previews: PreviewProvider {
    static var previews: some View {
        GenericButton(viewModel: GenericButtonViewModel(key: "",
                                                        title: "Resend OTP"))
    }
}
