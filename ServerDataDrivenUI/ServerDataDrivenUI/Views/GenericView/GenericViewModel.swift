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
    
    let notifyChange = ObservableObjectPublisher()
    var performAction = PassthroughSubject<ViewAction, Never>()

    private var cancellableSet = Set<AnyCancellable>()
    
    init() {
        let phoneFieldRules = ViewStateRule(disableOn: ["view": ["loading": true]])
        let phoneFieldViewModel = PhoneFieldViewModel(key: "phone_field",
                                                      rules: phoneFieldRules,
                                                      countryCodeData: ["+91": 10,
                                                                        "+65": 8],
                                                      selectedCountryCode: "+91",
                                                      notifyChange: notifyChange,
                                                      performAction: performAction)
        
        
        let otpFieldRules = ViewStateRule(hideOn: ["send_otp": ["action": false]],
                                          disableOn: ["view": ["loading": true]])
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
                                                    placeholder: "Login OTP",
                                                    notifyChange: notifyChange,
                                                    performAction: performAction)
        
        
        let sendOtpRule = ViewStateRule(hideOn: ["send_otp": ["action": true]],
                                        disableOn: ["view": ["loading": true]])
        let sendOTPButton = GenericButtonViewModel(key: "send_otp",
                                                   rules: sendOtpRule,
                                                   title: "Send OTP",
                                                   notifyChange: notifyChange,
                                                   performAction: performAction)
        
        
        let otpRules = ViewStateRule(hideOn: ["send_otp": ["action": false]],
                                     disableOn: ["view": ["loading": true]])
        
        let verifyOTPButton = GenericButtonViewModel(key: "verify_otp",
                                                     rules: otpRules,
                                                     title: "Verify OTP",
                                                     notifyChange: notifyChange,
                                                     performAction: performAction)
        
        let timerButton = TimerButtonViewModel(key: "resend_otp_button",
                                               rules: otpRules,
                                               title: "Resend OTP",
                                               countDownDuration: 60,
                                               notifyChange: notifyChange,
                                               performAction: performAction)
        
        uiViewModels = [phoneFieldViewModel,
                        textFieldViewModel,
                        sendOTPButton,
                        verifyOTPButton,
                        timerButton]
        
        setUpBindings()
        
        updateViewState()
    }
    
    func setUpBindings() {
        notifyChange.sink { [weak self] _ in
            self?.updateViewState()
            self?.objectWillChange.send()
        }.store(in: &cancellableSet)
        
        performAction.sink { [weak self] action in
            switch action {
            case .validatedAPICall(let key):
                guard self?.validate() == nil else {
                    self?.action(key: key,
                                 action: action,
                                 success: false)
                    return
                }
                self?.apiCall(key: key,
                              action: action)
            case .apiCall(let key):
                self?.apiCall(key: key,
                              action: action)
            default: break
            }
        }.store(in: &cancellableSet)
    }
    
    func apiCall(key: String,
                 action: ViewAction) {
        updateViewState()
        objectWillChange.send()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.action(key: key, action: action, success: true)
        }
    }
    
    func action(key: String,
                action: ViewAction,
                success: Bool) {
        let vm: UIViewModel? = uiViewModels.filter { $0.key == key }.last
        vm?.actionCompleted(action: action,
                            success: success)
        
        updateViewState()
        objectWillChange.send()
    }
    
    func updateViewState() {
        var viewData = [String: [String: AnyCodable]]()
        uiViewModels.forEach { viewModel in
            for (key, value) in viewModel.data {
                viewData[key] = value
            }
        }
        uiViewModels.forEach { $0.updateState(currentValues: viewData) }
    }
}
