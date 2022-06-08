//
//  GenericButton.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 04/06/22.
//

import SwiftUI

struct GenericButton: View {
    @ObservedObject var viewModel: GenericButtonViewModel
    
    var body: some View {
        Button(viewModel.title) {
            viewModel.pressed()
        }
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
        GenericButton(viewModel: GenericButtonViewModel(serverKey: "",
                                                        title: "Button"))
    }
}