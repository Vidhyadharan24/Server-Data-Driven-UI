//
//  TextFieldView.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import SwiftUI
import Combine

struct TextFieldView: View {
    
    @ObservedObject var viewModel: TextFieldViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(viewModel.placeholder,
                      text: $viewModel.text)
                .foregroundColor(viewModel.isDisabled ? Color.gray : Color.black)
                .disabled(viewModel.isDisabled)
                .keyboardType(viewModel.keyboardType)
                .padding(.vertical, 11)
            if let msg = viewModel.errorMessage {
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
        TextFieldView(viewModel: TextFieldViewModel(key: "",
                                                    text: "",
                                                    placeholder: "Placeholder",
                                                    notifyChange: ObservableObjectPublisher(),
                                                    performAction: PassthroughSubject<ViewAction, Never>()))
    }
}
