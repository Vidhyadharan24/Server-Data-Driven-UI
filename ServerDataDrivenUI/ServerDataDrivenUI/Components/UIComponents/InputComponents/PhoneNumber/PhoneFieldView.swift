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
        VStack(alignment: .leading) {
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
                .disabled(viewModel.isDisabled)
                .foregroundColor(viewModel.isDisabled ? Color.gray : Color.black)
                .padding(.vertical, 12)
                .dropdown(showDropdown: $showDropdown,
                          selected: $viewModel.selectedCountryCode,
                          options: viewModel.countryCodes)
                TextField("Phone Number", text: $viewModel.phoneNumber)
                    .foregroundColor(viewModel.isDisabled ? Color.gray : Color.black)
                    .keyboardType(.phonePad)
                    .disabled(viewModel.isDisabled)
                Spacer()
            }
            if let msg = viewModel.errorMessage {
                Divider()
                Text(msg)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

struct PhoneFieldView_Previews: PreviewProvider {
    static var previews: some View {
        let countryCodeData = ["+91": 10, "+65": 8]
        let viewModel = PhoneFieldViewModel(key: "",
                                            countryCodeData: countryCodeData,
                                            selectedCountryCode: "+65")
        PhoneFieldView(viewModel: viewModel)
    }
}
