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
    
    override func data() -> [String : AnyCodable] {
        [key: AnyCodable(phoneNumber)]
    }
        
    let countryCodes: [String]

    init(key: String,
         rules: [ViewStateRule] = [],
         validations: [Validation] = [],
         countryCodes: [String],
         selectedCountryCode: String,
         phoneNumber: String = "") {
        self.countryCodes = countryCodes
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
            .sink {[weak self] text in
                self?.validate(text: text)
            }.store(in: &cancellableSet)
    }
    
}
