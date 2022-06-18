//
//  PhoneFieldComponentModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//
   
import SwiftUI
import Combine
import AnyCodable

class PhoneFieldComponentModel: UIBaseInputComponentModel {
    @Published var selectedCountryCode: String
    @Published var phoneNumber: String

    override var view: AnyView {
        AnyView(PhoneFieldComponent(componentModel: self)
            .zIndex(100))
    }

    override var isValid: String? {
        validatePhoneNo(text: phoneNumber)
    }
    
    override var data: [String: Set<AnyCodable>] {
        [key: [AnyCodable(phoneNumber)]]
    }
        
    let countryCodeData: [String: Int]
    var countryCodes: [String] {
        Array(countryCodeData.keys)
    }

    init(key: String,
         rules: ComponentStateRule? = nil,
         validations: [Validation] = [],
         countryCodeData: [String: Int],
         selectedCountryCode: String,
         phoneNumber: String = "",
         notifyChange: ObservableObjectPublisher,
         performAction: PassthroughSubject<ComponentAction, Never>) {
        self.countryCodeData = countryCodeData
        self.selectedCountryCode = selectedCountryCode
        self.phoneNumber = phoneNumber

        super.init(key: key,
                   rules: rules,
                   validations: validations,
                   notifyChange: notifyChange,
                   performAction: performAction)
        
        self.setUpBindings()
    }
    
    func setUpBindings() {
        $selectedCountryCode
            .sink { [weak self] _ in
                self?.phoneNumber = ""
                self?.errorMessage = nil
            }.store(in: &cancellableSet)
        
        $phoneNumber
            .dropFirst()
            .sink {[weak self] text in
                self?.validatePhoneNo(text: text)
                self?.notifyChange.send()
            }.store(in: &cancellableSet)
    }
    
    @discardableResult func validatePhoneNo(text: String) -> String? {
        if let phoneTextCount = countryCodeData[self.selectedCountryCode],
            text.count != phoneTextCount {
            let errorMessage = "Phone number should be \(phoneTextCount) chars long"
            
            self.errorMessage = errorMessage
            return errorMessage
        }

        return self.validate(text: text)
    }
    
}
