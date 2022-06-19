//
//  PhoneFieldComponent.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import SwiftUI
import Combine

let dropdownCornerRadius: CGFloat = 8

struct PhoneFieldComponent: View {
    @ObservedObject var componentModel: PhoneFieldComponentModel
    
    @State var showDropdown = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    if componentModel.countryCodes.count > 1 {
                        self.showDropdown.toggle()
                    }
                }) {
                    HStack {
                        Text(componentModel.selectedCountryCode)
                        if componentModel.countryCodes.count > 1 {
                            Image(systemName: self.showDropdown ? "chevron.up" : "chevron.down")
                        }
                    }
                }
                .disabled(componentModel.isDisabled)
                .foregroundColor(componentModel.isDisabled ? Color.gray : Color.black)
                .padding(.vertical, 12)
                .dropdown(showDropdown: $showDropdown,
                          selected: $componentModel.selectedCountryCode,
                          options: componentModel.countryCodes)
                TextField("Phone Number", text: $componentModel.phoneNumber)
                    .foregroundColor(componentModel.isDisabled ? Color.gray : Color.black)
                    .keyboardType(.phonePad)
                    .disabled(componentModel.isDisabled)
                Spacer()
            }
            if let msg = componentModel.errorMessage {
                Divider()
                Text(msg)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

//struct PhoneFieldView_Previews: PreviewProvider {
//    static var previews: some View {
//        let countryCodeData = ["+91": 10, "+65": 8]
//        let componentModel = PhoneFieldComponentModel(key: "",
//                                            countryCodeData: countryCodeData,
//                                            selectedCountryCode: "+65",
//                                            notifyChange: ObservableObjectPublisher(),
//                                            performAction: PassthroughSubject<ComponentAction, Never>())
//        PhoneFieldComponent(componentModel: componentModel)
//    }
//}
