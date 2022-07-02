//
//  PhoneFieldComponentModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//
   
import Combine
import AnyCodable

class PhoneFieldComponentModel: UIBaseInputComponentModel {
    @Published var selectedCountryCode: String
    @Published var phoneNumber: String

    override var isValid: String? {
        validatePhoneNo(text: phoneNumber)
    }
    
    override var data: [String: Set<AnyCodable>] {
        [componentDataModel.key: [AnyCodable(phoneNumber)]]
    }
        
    let countries: [Country]
    var countryCodes: [String] {
        Array(countries.map { $0.code })
    }

    init(componentDataModel: PhoneComponentDataModel,
         countries: [Country],
         selectedCountryCode: String,
         phoneNumber: String = "",
         notifyChange: PassthroughSubject<String, Never>,
         performAction: PassthroughSubject<UIComponentModel, Never>) {
        self.countries = countries
        self.selectedCountryCode = selectedCountryCode
        self.phoneNumber = phoneNumber

        super.init(componentDataModel: componentDataModel,
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
                guard let self = self else { return }
                self.validatePhoneNo(text: text)
                self.notifyChange.send(self.componentDataModel.key)
            }.store(in: &cancellableSet)
    }
    
    @discardableResult func validatePhoneNo(text: String) -> String? {
        if let country = countries.first(where: { $0.code == self.selectedCountryCode }),
           text.count != country.length {
            let errorMessage = "Phone number should be \(country.length) chars long"
            
            self.errorMessage = errorMessage
            return errorMessage
        }

        return self.validate(text: text)
    }
    
}
