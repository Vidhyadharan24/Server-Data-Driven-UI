//
//  PhoneFieldView.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import SwiftUI

let dropdownCornerRadius: CGFloat = 8

struct PhoneFieldView: View {
    @ObservedObject var viewModel: PhoneFieldViewModel
    
    @State var showDropdown = false
    
    var body: some View {
        HStack {
            Button(action: {
                if viewModel.countryCodes.count > 1 {
                    self.showDropdown.toggle()
                }
            }) {
                HStack {
                    Text(viewModel.selectedCountryCode)
                    if viewModel.countryCodes.count > 1 {
                        Image(systemName: self.showDropdown ? "chevron.up" : "chevron.down")
                    }
                }
            }
            .foregroundColor(Color.black)
            .padding(.vertical, 12)
            .dropdown(showDropdown: $showDropdown,
                      selected: $viewModel.selectedCountryCode,
                      options: viewModel.countryCodes)
            TextField("Phone Number", text: $viewModel.phoneNumber)
                .keyboardType(.phonePad)
            Spacer()
        }
    }
}

struct PhoneFieldView_Previews: PreviewProvider {
    static var previews: some View {
        let countryCodes = ["+91", "+65"]
        let viewModel = PhoneFieldViewModel(serverKey: "",
                                            countryCodes: countryCodes,
                                            selectedCountryCode: countryCodes.first!)
        PhoneFieldView(viewModel: viewModel)
    }
}
