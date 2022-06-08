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
        TextField("text", text: $viewModel.text)
            .keyboardType(viewModel.keyboardType)
            .padding(.vertical, 11)
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView(viewModel: TextFieldViewModel(serverKey: "",
                                                    text: ""))
    }
}
