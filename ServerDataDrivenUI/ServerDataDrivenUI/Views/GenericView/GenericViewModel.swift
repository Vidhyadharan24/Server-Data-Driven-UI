//
//  GenericViewModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import SwiftUI
import Combine
import AnyCodable

class GenericViewModel: GenericViewModelProtocol {
    let uiViewModels: [UIViewModel]
    
    private var cancellableSet = Set<AnyCancellable>()
    
    init() {
        let phoneFieldRules = ViewStateRule(disableOn: ["loading": true])
        let phoneFieldViewModel = PhoneFieldViewModel(key: "phone_field",
                                                      rules: phoneFieldRules,
                                                      countryCodeData: ["+91": 10,
                                                                        "+65": 8],
                                                      selectedCountryCode: "+91")
        
        
        let otpFieldRules = ViewStateRule(hideOn: ["send_otp" : false],
                                          disableOn: ["loading" : true])
        let minLength = Validation.min(LengthValidationData(length: 4,
                                                            errorMessage: "OTP should have min 4 chars in length"))
        let maxLength = Validation.max(LengthValidationData(length: 4,
                                                            errorMessage: "OTP should be max 4 chars in length"))
        let numbers = Validation.numbers(ValidationData(errorMessage: "OTP should contain only digits"))

        let textFieldViewModel = TextFieldViewModel(key: "otp_field",
                                                    rules: otpFieldRules,
                                                    validations: [minLength,
                                                                 maxLength,
                                                                 numbers],
                                                    text: "",
                                                    placeholder: "Login OTP")

        
        let sendOtpRule = ViewStateRule(hideOn: ["send_otp" : true],
                                        disableOn: ["loading": true])
        let sendOTPButton = GenericButtonViewModel(key: "send_otp",
                                                   rules: sendOtpRule,
                                                   title: "Send OTP")
        
        
        let otpRules = ViewStateRule(hideOn: ["send_otp" : false],
                                     disableOn: ["loading" : true])

        let verifyOTPButton = GenericButtonViewModel(key: "verify_otp",
                                                     rules: otpRules,
                                                     title: "Verify OTP")
        
        let timerButton = TimerButtonViewModel(key: "resend_otp_button",
                                               rules: otpRules,
                                               title: "Resend OTP",
                                               countDownDuration: 60)
        
        uiViewModels = [phoneFieldViewModel,
                        textFieldViewModel,
                        sendOTPButton,
                        verifyOTPButton,
                        timerButton]
        
        for uiViewModel in uiViewModels {
            uiViewModel.objectDidChange.sink { [weak self] in
                self?.updateViewState()
                self?.objectWillChange.send()
            }.store(in: &cancellableSet)            
        }
        
        updateViewState()
    }
    
    func updateViewState() {
        var viewData = [String: AnyCodable]()
        uiViewModels.forEach { viewModel in
            for (key, value) in viewModel.data {
                viewData[key] = value
            }
        }
        uiViewModels.forEach { $0.updateState(currentValues: viewData) }
    }
}
