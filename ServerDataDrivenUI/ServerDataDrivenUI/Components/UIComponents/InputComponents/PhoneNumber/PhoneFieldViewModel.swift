//
//  PhoneFieldViewModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//
   
import SwiftUI
import Combine
import AnyCodable

class PhoneFieldViewModel: UIBaseInputViewModel {
    @Published var selectedCountryCode: String
    @Published var phoneNumber: String

    override var view: AnyView {
        AnyView(PhoneFieldView(viewModel: self)
            .zIndex(100))
    }

    override var isValid: Bool {
        validate(text: phoneNumber) == nil
    }
    
    override var data: [String: AnyCodable] {
        [key: AnyCodable(phoneNumber)]
    }
        
    let countryCodeData: [String: Int]
    var countryCodes: [String] {
        Array(countryCodeData.keys)
    }

    init(key: String,
         rules: ViewStateRule? = nil,
         validations: [Validation] = [],
         countryCodeData: [String: Int],
         selectedCountryCode: String,
         phoneNumber: String = "") {
        self.countryCodeData = countryCodeData
        self.selectedCountryCode = selectedCountryCode
        self.phoneNumber = phoneNumber

        super.init(key: key,
                   rules: rules,
                   validations: validations)
        
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
